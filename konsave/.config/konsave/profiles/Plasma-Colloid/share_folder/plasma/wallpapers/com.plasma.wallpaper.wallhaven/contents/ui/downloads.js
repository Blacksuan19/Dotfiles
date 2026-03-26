function saveEntry(ctx, imageUrl, thumbnailUrl, localPath, isDark) {
    const normalizedLocalPath = ctx.utils.normalizePath(localPath || "");
    const darkFlag = isDark === true ? "1" : isDark === false ? "0" : "";
    const savedEntry = imageUrl + "|||" + thumbnailUrl + "|||" + normalizedLocalPath + "|||" + darkFlag;
    let currentList = ctx.config.SavedWallpapers || [];
    const alreadySaved = currentList.some((entry) => {
        const parts = entry.split("|||");
        return parts[0] === imageUrl;
    });
    if (alreadySaved) {
        ctx.notify("Wallhaven Wallpaper", "Wallpaper already saved", "dialog-information", false);
        return;
    }
    let newList = currentList.slice();
    newList.push(savedEntry);
    ctx.config.SavedWallpapers = newList;
    ctx.writeConfig();
    if (ctx.log)
        ctx.log("Saved wallpaper: " + imageUrl + (normalizedLocalPath ? " (local: " + normalizedLocalPath + ")" : ""));

    const msg = normalizedLocalPath ? "Wallpaper downloaded and saved! Total: " + newList.length : "Wallpaper saved (download failed). Total: " + newList.length;
    ctx.notify("Wallhaven Wallpaper", msg, "plugin-wallpaper", false);
}

function queueDownload(ctx, imageUrl, thumbnailUrl, isDark) {
    const wallhavenId = ctx.utils.extractWallhavenId(imageUrl);
    if (!wallhavenId) {
        if (ctx.log)
            ctx.log("Could not extract Wallhaven ID from URL: " + imageUrl);
        saveEntry(ctx, imageUrl, thumbnailUrl, "", isDark);
        return;
    }
    if (!ctx.savedDir) {
        if (ctx.log)
            ctx.log("Saved wallpapers directory is empty, saving URL only");
        ctx.notify("Wallhaven Wallpaper", "Download failed, saving URL only", "dialog-warning", false);
        saveEntry(ctx, imageUrl, thumbnailUrl, "", isDark);
        return;
    }

    const localPath = ctx.savedDir + "/" + wallhavenId + ".jpg";
    if (ctx.log)
        ctx.log("Downloading wallpaper to: " + localPath);

    ctx.pendingDownloads[imageUrl] = {
        thumbnail: thumbnailUrl,
        localPath: localPath,
        wallhavenId: wallhavenId,
        isDark: isDark
    };
    const mkdirCmd = `mkdir -p "${ctx.savedDir}"`;
    ctx.exec(mkdirCmd);
}

function handleExecResult(ctx, sourceName, data) {
    const exitCode = data["exit code"];
    const stdout = data["stdout"];
    const stderr = data["stderr"];
    if (ctx.log)
        ctx.log("Command executed: " + sourceName);
    if (ctx.log)
        ctx.log("Exit code: " + exitCode + ", stdout: " + stdout + ", stderr: " + stderr);

    if (sourceName.startsWith("mkdir")) {
        if (exitCode !== 0) {
            if (ctx.log)
                ctx.log("Failed to create directory: " + stderr);
            ctx.notify("Wallhaven Wallpaper", "Download failed, saving URL only", "dialog-warning", false);
            for (let url in ctx.pendingDownloads) {
                const info = ctx.pendingDownloads[url];
                saveEntry(ctx, url, info.thumbnail, "", info.isDark);
                delete ctx.pendingDownloads[url];
                break;
            }
            ctx.disconnect(sourceName);
            return;
        }
        for (let url in ctx.pendingDownloads) {
            const info = ctx.pendingDownloads[url];
            const downloadCmd = `curl -L -o "${info.localPath}" "${url}"`;
            if (ctx.log)
                ctx.log("Starting download: " + downloadCmd);
            ctx.exec(downloadCmd);
            break;
        }
    } else if (sourceName.startsWith("curl")) {
        for (let url in ctx.pendingDownloads) {
            if (sourceName.includes(url)) {
                const info = ctx.pendingDownloads[url];
                if (exitCode === 0) {
                    if (ctx.log)
                        ctx.log("Download successful: " + info.localPath);
                    saveEntry(ctx, url, info.thumbnail, info.localPath, info.isDark);
                } else {
                    if (ctx.log)
                        ctx.log("Download failed: " + stderr);
                    ctx.notify("Wallhaven Wallpaper", "Download failed, saving URL only", "dialog-warning", false);
                    saveEntry(ctx, url, info.thumbnail, "", info.isDark);
                }
                delete ctx.pendingDownloads[url];
                break;
            }
        }
    }
    ctx.disconnect(sourceName);
}
