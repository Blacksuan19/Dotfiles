import "./lib"
import QtMultimedia
import QtQuick

QtObject {
    id: notificationManager

    property var executable

    function start(args) {
        switch (args) {
        case 1:
        case 3:
        case 5:
        case 7:
            createNotification({
                "appName": "fokus",
                "summary": "Focus on your work!",
                "soundFile": plasmoid.configuration.timer_start_sfx_enabled ? plasmoid.configuration.timer_start_sfx_filepath : undefined
            });
            break;
        case 2:
        case 4:
        case 6:
            createNotification({
                "appName": "fokus",
                "summary": "Go for a walk.",
                "soundFile": plasmoid.configuration.timer_start_sfx_enabled ? plasmoid.configuration.timer_start_sfx_filepath : undefined
            });
            break;
        case 8:
            createNotification({
                "appName": "fokus",
                "summary": "Take a long break!",
                "soundFile": plasmoid.configuration.timer_start_sfx_enabled ? plasmoid.configuration.timer_start_sfx_filepath : undefined
            });
            break;
        }
    }

    function end(args) {
        switch (args) {
        case 1:
        case 3:
        case 5:
        case 7:
            createNotification({
                "appName": "fokus",
                "summary": "End of focus time.",
                "soundFile": plasmoid.configuration.timer_stop_sfx_enabled ? plasmoid.configuration.timer_stop_sfx_filepath : undefined
            });
            break;
        case 2:
        case 4:
        case 8:
        case 6:
            createNotification({
                "appName": "fokus",
                "summary": "End of break.",
                "soundFile": plasmoid.configuration.timer_stop_sfx_enabled ? plasmoid.configuration.timer_stop_sfx_filepath : undefined
            });
            break;
        }
    }

    function getPath(fileUrl) {
        // remove prefixed "file://"
        return fileUrl.toString().replace(/^file:\/\//, "");
    }

    function createNotification(args) {
        args.sound = args.sound || args.soundFile;
        var cmd = ['python3', getPath(Qt.resolvedUrl("../scripts/notification.py"))];
        if (args.appName)
            cmd.push('--app-name', args.appName);

        if (args.appIcon)
            cmd.push('--icon', args.appIcon);

        if (args.sound) {
            cmd.push('--sound', args.sound);
            if (args.loop)
                cmd.push('--loop', args.loop);

        }
        if (typeof args.expireTimeout !== 'undefined')
            cmd.push('--timeout', args.expireTimeout);

        if (args.actions) {
            for (var i = 0; i < args.actions.length; i++) {
                var action = args.actions[i];
                cmd.push('--action', action);
            }
        }
        cmd.push('--metadata', '' + Date.now());
        var sanitizedSummary = executable.sanitizeString(args.summary);
        cmd.push(sanitizedSummary);
        if (args.body) {
            var sanitizedBody = executable.sanitizeString(args.body);
            cmd.push(sanitizedBody);
        } else {
            cmd.push("");
        }
        executable.exec(cmd, function(cmd, exitCode, exitStatus, stdout, stderr) {
        });
    }

    executable: ExecUtil {
        id: executable
    }

}
