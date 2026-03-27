function saveCurrentWallpaper(ctx) {
    const currentUrl = ctx.currentUrl();
    if (!currentUrl || currentUrl === "" || currentUrl === "blackscreen.jpg") {
        ctx.notify("Wallhaven Wallpaper Error", "No valid wallpaper to save", "dialog-error", true);
        return;
    }
    const thumbnail = ctx.thumbnail();
    if (ctx.utils.isHttpUrl(currentUrl)) {
        ctx.notify("Wallhaven Wallpaper", "Downloading wallpaper...", "download", false);
        ctx.downloadWallpaper(currentUrl, thumbnail, ctx.isDark);
    } else {
        ctx.saveEntry(currentUrl, thumbnail, "", null);
    }
}

function loadFromSavedWallpapers(ctx) {
    const config = ctx.config;
    const fullSavedList = config.SavedWallpapers || [];
    if (fullSavedList.length === 0) {
        ctx.notify("Wallhaven Wallpaper", "No saved wallpapers found. Fetching from Wallhaven...", "plugin-wallpaper", false);
        ctx.fetchFromWallhaven("No saved wallpapers found. Fetching from Wallhaven...");
        return;
    }

    // Filter to dark wallpapers when FollowSystemTheme is enabled and system is in dark mode.
    // Entries with unknown darkness (isDark === null, e.g. older saved entries) are always included.
    let savedList = fullSavedList;
    if (config.FollowSystemTheme && ctx.systemDarkMode) {
        const darkList = fullSavedList.filter((entry) => {
            const parsed = ctx.utils.parseSavedEntry(entry);
            return parsed.isDark !== false; // include dark (true) and unknown (null)
        });
        if (darkList.length > 0) {
            savedList = darkList;
        } else {
            ctx.log("No dark saved wallpapers found, cycling all saved wallpapers");
        }
    }

    let shownList = ctx.getShownList();
    if (shownList.length >= savedList.length) {
        if (config.CycleSavedWallpapers) {
            ctx.notify("Wallhaven Wallpaper", "Restarting saved wallpapers cycle", "plugin-wallpaper", false);
            ctx.setShownList([]);
            shownList = [];
        } else {
            ctx.setShownList([]);
            ctx.fetchFromWallhaven("All " + savedList.length + " saved wallpapers shown. Fetching new from Wallhaven...");
            return;
        }
    }

    const lastLoadedUrl = ctx.state.lastLoadedUrl || "";
    const lastLoadedPath = ctx.utils.normalizePath(lastLoadedUrl);
    const isCurrentEntry = (entry) => {
        const parsed = ctx.utils.parseSavedEntry(entry);
        if (ctx.utils.isHttpUrl(lastLoadedUrl))
            return parsed.fullUrl === lastLoadedUrl;
        if (lastLoadedPath && parsed.localPath)
            return parsed.localPath === lastLoadedPath;
        return parsed.fullUrl === lastLoadedUrl;
    };
    const isShownEntry = (entry) => {
        return shownList.indexOf(entry) !== -1;
    };

    let unshownWallpapers = savedList.filter((entry) => {
        return !isShownEntry(entry);
    });

    if (!config.CycleSavedWallpapers && unshownWallpapers.length === 0) {
        ctx.setShownList([]);
        ctx.fetchFromWallhaven("All " + savedList.length + " saved wallpapers shown. Fetching new from Wallhaven...");
        return;
    }

    const pickNextSequential = () => {
        const currentIndex = savedList.findIndex((entry) => {
            return isCurrentEntry(entry);
        });
        const startIndex = currentIndex >= 0 ? currentIndex : -1;
        for (let offset = 1; offset <= savedList.length; offset++) {
            const idx = (startIndex + offset) % savedList.length;
            const entry = savedList[idx];
            if (isCurrentEntry(entry))
                continue;
            if (unshownWallpapers.length > 0 && !isShownEntry(entry))
                return entry;
            if (unshownWallpapers.length === 0)
                return entry;
        }
        return "";
    };

    let selectedEntry = "";
    if (config.ShuffleSavedWallpapers) {
        let availableWallpapers = unshownWallpapers.filter((entry) => {
            return !isCurrentEntry(entry);
        });
        if (availableWallpapers.length === 0) {
            if (config.CycleSavedWallpapers) {
                ctx.notify("Wallhaven Wallpaper", "Only one saved wallpaper available", "plugin-wallpaper", false);
                availableWallpapers = savedList.filter((entry) => {
                    return !isCurrentEntry(entry);
                });
                if (availableWallpapers.length === 0)
                    availableWallpapers = savedList.slice();
                ctx.setShownList([]);
                shownList = [];
            } else {
                ctx.fetchFromWallhaven("Only one saved wallpaper. Fetching new from Wallhaven...");
                return;
            }
        }
        const randomIndex = Math.floor(Math.random() * availableWallpapers.length);
        selectedEntry = availableWallpapers[randomIndex];
    } else {
        selectedEntry = pickNextSequential();
        if (!selectedEntry) {
            if (config.CycleSavedWallpapers) {
                ctx.setShownList([]);
                shownList = [];
                unshownWallpapers = savedList.slice();
                selectedEntry = pickNextSequential();
                if (!selectedEntry) {
                    ctx.notify("Wallhaven Wallpaper", "Only one saved wallpaper available", "plugin-wallpaper", false);
                    selectedEntry = savedList[0];
                }
            } else {
                ctx.setShownList([]);
                ctx.fetchFromWallhaven("All " + savedList.length + " saved wallpapers shown. Fetching new from Wallhaven...");
                return;
            }
        }
    }

    const parsed = ctx.utils.parseSavedEntry(selectedEntry);
    const finalUrl = parsed.localPath ? "file://" + parsed.localPath : parsed.fullUrl;
    const thumbnailSource = parsed.localPath ? "file://" + parsed.localPath : parsed.thumbUrl;

    let newShownList = shownList.slice();
    newShownList.push(selectedEntry);
    ctx.setShownList(newShownList);
    const source = parsed.localPath ? "local" : "online";
    const selectedIndex = savedList.indexOf(selectedEntry) + 1;
    ctx.notify("Wallhaven Wallpaper", "Loading saved wallpaper " + selectedIndex + " of " + savedList.length + " (" + source + ")", "plugin-wallpaper", false);

    ctx.setCurrentUrl(finalUrl);
    ctx.setLastValidImagePath(finalUrl);
    ctx.setThumbnail(thumbnailSource);
    ctx.writeConfig();
    ctx.loadImage();
    ctx.setLoading(false);
}
