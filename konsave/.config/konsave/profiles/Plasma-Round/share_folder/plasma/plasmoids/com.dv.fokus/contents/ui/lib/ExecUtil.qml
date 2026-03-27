// Version 6

import QtQuick
import org.kde.plasma.plasma5support as Plasma5Support

Plasma5Support.DataSource {
    id: executable

    property var listeners: ({}) // Empty Map

    signal exited(string cmd, int exitCode, int exitStatus, string stdout, string stderr)

    function trimOutput(stdout) {
        return stdout.replace(/\n/g, ' ').trim();
    }

    function wrapToken(token) {
        token = "" + token;
        // ' => '"'"' to escape the single quotes
        token = token.replace(/\'/g, "\'\"\'\"\'");
        token = "\'" + token + "\'";
        return token;
    }

    function sanitizeString(str) {
        return str.replace(/[\x00-\x1F\'\"\x7F]/g, '');
    }

    function stripQuotes(str) {
        return str.replace(/[\'\"]/g, '');
    }

    function exec(cmd, callback) {
        if (Array.isArray(cmd)) {
            cmd = cmd.map(wrapToken);
            cmd = cmd.join(' ');
        }
        if (typeof callback === 'function') {
            if (listeners[cmd]) {
                // Our implementation only allows 1 callback per command.
                exited.disconnect(listeners[cmd]);
                delete listeners[cmd];
            }
            var listener = execCallback.bind(executable, callback);
            listeners[cmd] = listener;
        }
        connectSource(cmd);
    }

    function stopExec(cmd) {
        delete listeners[cmd];
        disconnectSource(cmd);
    }

    function execCallback(callback, cmd, exitCode, exitStatus, stdout, stderr) {
        delete listeners[cmd];
        callback(cmd, exitCode, exitStatus, stdout, stderr);
    }

    engine: "executable"
    connectedSources: []
    onNewData: (sourceName, data) => {
        console.log(sourceName);
        var cmd = sourceName;
        var exitCode = data["exit code"];
        var exitStatus = data["exit status"];
        var stdout = data["stdout"];
        var stderr = data["stderr"];
        var listener = listeners[cmd];
        if (listener)
            listener(cmd, exitCode, exitStatus, stdout, stderr);
        exited(cmd, exitCode, exitStatus, stdout, stderr);
        disconnectSource(sourceName); // cmd finished
    }
}
