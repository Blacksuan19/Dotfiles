import "./lib"
import Qt5Compat.GraphicalEffects
import QtMultimedia
import QtQuick
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.private.kicker as Kicker

PlasmoidItem {
    id: root

    property var executable
    property string clock_fontfamily: plasmoid.configuration.clock_fontfamily || "Noto Sans"
    property var stateVal: 1
    property var initialSeconds: setInitialSeconds()
    property var counterSeconds: initialSeconds
    property var counterMilliseconds: counterSeconds * 1000
    property var tickingSeconds: plasmoid.configuration.ticking_time
    property var customIconSource: "../icons/pomodoro-start-light.svg"
    property var sessionBtnText: "St&art"
    property var sessionBtnIconSource: "media-playback-start"
    property var statusText: "focus"
    property var timeText: formatCounter()
    property var previousTime: new Date()
    property var numberOfSessions: plasmoid.configuration.number_of_sessions
    property var inhibitCmd: "kde-inhibit --notifications sleep 99999"
    readonly property var flowmodoroModeEnabled: plasmoid.configuration.flowmodoro_mode_enabled // to update counter seconds when flowmode is enabled
    readonly property var focusTime: plasmoid.configuration.focus_time

    onFlowmodoroModeEnabledChanged: {
        stop();
    }
    onFocusTimeChanged: {
        stop();
    }

    function setInitialSeconds() {
        // sets default value for counter
        if (flowmodoroModeEnabled && !isBreak()) {
            return 0;
        } else {
            return plasmoid.configuration.focus_time * 60;
        }
    }

    function formatNumberLength(num, length) {
        var r = "" + num;
        while (r.length < length)
            r = "0" + r;
        return r;
    }

    function shiftCounter(seconds) {
        if (counterSeconds + seconds > 0) {
            counterMilliseconds += seconds * 1000;
            counterSeconds += seconds;
            initialSeconds += seconds;
        }
    }

    function formatCounter() {
        var sec = counterSeconds % 60;
        var min = Math.floor(counterSeconds / 60) % 60;
        var hours = Math.floor(counterSeconds / 60 / 60);
        if (hours > 0) {
            return formatNumberLength(hours) + ":" + formatNumberLength(min, 2) + ":" + formatNumberLength(sec, 2);
        } else {
            return formatNumberLength(min, 2) + ":" + formatNumberLength(sec, 2);
        }
    }

    function getToolTipText() {
        var text = "";
        if (timer.running) {
            if (stateVal == 2 * numberOfSessions)
                text = "Take a long break!";
            else if (stateVal != 0 && stateVal % 2 == 0)
                text = "Go for a walk.";
            else
                text = "Focus on your work!";
        }
        return text;
    }

    function start() {
        if (plasmoid.configuration.timer_start_notification_enabled)
            notificationManager.start(stateVal);
        if (!isBreak())
            doNotDisturbEnable();
        previousTime = new Date();
        executeScript(1);
        timer.start();
        if (flowmodoroModeEnabled) {
            sessionBtnText = "St&op";
            sessionBtnIconSource = "media-playback-stop";
        } else {
            sessionBtnText = "Pa&use";
            sessionBtnIconSource = "media-playback-pause";
            customIconSource = "../icons/pomodoro-indicator-light-61.svg";
            Plasmoid.status = PlasmaCore.Types.ActiveStatus;
        }
        showBreakDialogIfNeeded();
    }

    function pause() {
        doNotDisturbDisable();
        timer.stop();
        sessionBtnText = "St&art";
        sessionBtnIconSource = "media-playback-start";
        customIconSource = "../icons/pomodoro-start-light.svg";
    }

    function end() {
        doNotDisturbDisable();
        if (plasmoid.configuration.timer_end_notification_enabled)
            notificationManager.end(stateVal);
        executeScript(2);
        timer.stop();
        sessionBtnText = "St&art";
        sessionBtnIconSource = "media-playback-start";
        customIconSource = "../icons/pomodoro-start-light.svg";
        nextState();
        resetTime();
        if ((isBreak() && plasmoid.configuration.timer_auto_pause_enabled) || (!isBreak() && plasmoid.configuration.timer_auto_focus_enabled)) {
            start();
        } else {
            Plasmoid.status = PlasmaCore.Types.PassiveStatus;
        }
    }

    function skip() {
        nextState();
        resetTime();
        showBreakDialogIfNeeded();
        if (!isBreak()) {
            doNotDisturbEnable();
        } else {
            doNotDisturbDisable();
        }
        if (flowmodoroModeEnabled && !isBreak()) {
            sessionBtnText = "St&op";
            sessionBtnIconSource = "media-playback-stop";
        } else if (flowmodoroModeEnabled && isBreak()) {
            sessionBtnText = "Sk&ip";
            sessionBtnIconSource = "media-skip-forward";
        }
    }

    function postpone() {
        prevState();
        statusText = "focus";
        initialSeconds = plasmoid.configuration.focus_time * 60;
        previousTime = new Date();
        counterSeconds = 60 * 5;
        counterMilliseconds = counterSeconds * 1000;
        updateTime();
        showBreakDialogIfNeeded();
        if (!isBreak()) {
            doNotDisturbEnable();
        } else {
            doNotDisturbDisable();
        }
    }

    function stop() {
        doNotDisturbDisable();
        executeScript(0);
        timer.stop();
        stateVal = 1;
        resetTime();
        sessionBtnText = "St&art";
        sessionBtnIconSource = "media-playback-start";
        customIconSource = "../icons/pomodoro-start-light.svg";
        Plasmoid.status = PlasmaCore.Types.PassiveStatus;
    }

    function resetTime() {
        if (flowmodoroModeEnabled && !isBreak()) {
            initialSeconds = 0;
            statusText = "flow";
        } else if (flowmodoroModeEnabled && isBreak()) {
            initialSeconds = Math.floor(counterSeconds / plasmoid.configuration.flow_divisor);
            statusText = "flow break";
        } else if (stateVal == 2 * numberOfSessions) {
            initialSeconds = plasmoid.configuration.long_break_time * 60;
            statusText = "long break";
        } else if (stateVal != 0 && stateVal % 2 == 0) {
            initialSeconds = plasmoid.configuration.short_break_time * 60;
            statusText = "short break";
        } else {
            initialSeconds = plasmoid.configuration.focus_time * 60;
            statusText = "focus";
        }
        previousTime = new Date();
        counterSeconds = initialSeconds;
        counterMilliseconds = counterSeconds * 1000;
        updateTime();
    }

    function setTime() {
        var currentTime = new Date();
        var timeDiff = currentTime.getTime() - previousTime.getTime();
        previousTime = currentTime;
        var oldCounterSeconds = Math.ceil(counterMilliseconds / 1000);
        if (flowmodoroModeEnabled && !isBreak()) {
            counterMilliseconds += timeDiff;
        } else {
            counterMilliseconds -= timeDiff;
        }
        var newCounterSeconds = Math.ceil(counterMilliseconds / 1000);
        // Avoid too fast countdown when relying solely on QML's Timer
        if (newCounterSeconds === oldCounterSeconds)
            return;
        if (flowmodoroModeEnabled && !isBreak()) {
            counterSeconds++;
        } else {
            counterSeconds--;
            if (counterSeconds <= 0)
                end();
        }
        updateTime();
    }

    function doNotDisturbEnable() {
        if (plasmoid.configuration.do_not_disturb_enabled)
            executable.exec(inhibitCmd);
    }

    function doNotDisturbDisable() {
        if (plasmoid.configuration.do_not_disturb_enabled)
            executable.stopExec(inhibitCmd);
    }

    function updateTime() {
        timeText = formatCounter();
        if (timer.running) {
            customIconSource = "../icons/pomodoro-indicator-light-" + formatNumberLength(Math.ceil((counterSeconds / initialSeconds) * 61), 2) + ".svg";
            if (counterSeconds <= tickingSeconds && counterSeconds > 0 && plasmoid.configuration.timer_tick_sfx_enabled && !isBreak()) {
                sfx.source = plasmoid.configuration.timer_tick_sfx_filepath;
                sfx.volume = 1 - (counterSeconds / tickingSeconds);
                sfx.play();
            }
        }
    }

    function nextState() {
        if (stateVal < numberOfSessions * 2)
            stateVal++;
        else
            stateVal = 1;
        if (stateVal == 2 * numberOfSessions && plasmoid.configuration.short_break_time == 0)
            nextState();
        else if (stateVal != 0 && stateVal % 2 == 0 && plasmoid.configuration.long_break_time == 0)
            nextState();
    }

    function prevState() {
        if (stateVal != 1)
            stateVal--;
    }

    function getCircleColor() {
        var color;
        if (stateVal % 2 == 0)
            color = Kirigami.Theme.disabledTextColor;
        else
            color = Kirigami.Theme.highlightColor;
        return color;
    }

    function getTextColor() {
        var color;
        if (stateVal % 2 == 0)
            color = Kirigami.Theme.disabledTextColor;
        else
            color = Kirigami.Theme.textColor;
        return color;
    }

    function showBreakDialogIfNeeded() {
        if (!plasmoid.configuration.show_fullscreen_break)
            return;
        if (isBreak() && timer.running)
            breakDialog.showFullScreen();
        else
            breakDialog.hide();
    }

    function executeScript(state) {
        switch (state) {
        case 0:
            if (plasmoid.configuration.stop_script_enabled)
                executable.exec("sh " + plasmoid.configuration.stop_script_filepath);
            break;
        case 1:
            if (stateVal != 0 && stateVal % 2 == 0) {
                if (plasmoid.configuration.start_break_script_enabled)
                    executable.exec("sh " + plasmoid.configuration.start_break_script_filepath);
            } else if (stateVal != 0) {
                if (plasmoid.configuration.start_focus_script_enabled)
                    executable.exec("sh " + plasmoid.configuration.start_focus_script_filepath);
            }
            break;
        case 2:
            if (stateVal != 0 && stateVal % 2 == 0) {
                if (plasmoid.configuration.end_break_script_enabled)
                    executable.exec("sh " + plasmoid.configuration.end_break_script_filepath);
            } else if (stateVal != 0) {
                if (plasmoid.configuration.end_focus_script_enabled)
                    executable.exec("sh " + plasmoid.configuration.end_focus_script_filepath);
            }
            break;
        }
    }

    function isBreak() {
        if (stateVal != 0 && stateVal % 2 == 0)
            return true;
        else
            return false;
    }

    Plasmoid.status: PlasmaCore.Types.PassiveStatus
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground | PlasmaCore.Types.ConfigurableBackground
    toolTipMainText: formatCounter()
    toolTipSubText: getToolTipText()
    switchWidth: Kirigami.Units.gridUnit * 12
    switchHeight: Kirigami.Units.gridUnit * 11

    Component.onCompleted: {
        if (plasmoid.configuration.autostart) {
            start();
        }
    }

    NotificationManager {
        id: notificationManager
    }

    MediaPlayer {
        id: sfx

        audioOutput: AudioOutput {}
    }

    Timer {
        id: timer

        interval: 100
        repeat: true
        running: false
        triggeredOnStart: false
        onTriggered: setTime()
    }

    Kicker.DashboardWindow {
        id: breakDialog

        flags: Qt.WindowStaysOnTopHint
        backgroundColor: Qt.hsla(Kirigami.Theme.backgroundColor.hslHue, Kirigami.Theme.backgroundColor.hslSaturation, Kirigami.Theme.backgroundColor.hslLightness, 0.85)

        Item {
            anchors.fill: parent

            ProgressCircle {
                id: dialogProgressCircle

                anchors.centerIn: parent
                size: Math.min(parent.width / 2.4, parent.height / 2.4)
                colorCircle: getCircleColor()
                arcBegin: 0
                arcEnd: Math.ceil((counterSeconds / initialSeconds) * 360)
                lineWidth: size / 30
            }

            Item {
                anchors.centerIn: parent
                height: dialogTimeLabel.height

                PlasmaComponents.Label {
                    id: dialogTimeLabel

                    text: timeText
                    font.pointSize: Math.max(dialogProgressCircle.width / 8, 1)
                    font.family: clock_fontfamily

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                }

                Controls.PageIndicator {
                    id: dialogPageIndicator
                    visible: flowmodoroModeEnabled ? false : numberOfSessions > 1
                    count: numberOfSessions
                    currentIndex: (stateVal - 1) / 2
                    spacing: dialogProgressCircle.width / 25

                    anchors {
                        bottom: dialogTimeLabel.top
                        horizontalCenter: parent.horizontalCenter
                        bottomMargin: dialogProgressCircle.width / 15
                    }

                    delegate: Rectangle {
                        visible: flowmodoroModeEnabled ? false : numberOfSessions > 1
                        implicitWidth: dialogProgressCircle.width / 34
                        implicitHeight: width
                        radius: width / 2
                        color: Kirigami.Theme.textColor
                        opacity: index === dialogPageIndicator.currentIndex ? 0.95 : 0.45

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 100
                            }
                        }
                    }
                }

                PlasmaComponents.Label {
                    text: statusText
                    font.pointSize: Math.max(dialogProgressCircle.width / 24, 1)
                    color: getTextColor()

                    anchors {
                        top: dialogTimeLabel.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: dialogProgressCircle.width / 20
                    }
                }
            }

            RowLayout {
                height: Kirigami.Units.gridUnit * 6
                width: parent.width

                anchors {
                    bottom: parent.bottom
                    bottomMargin: Kirigami.Units.gridUnit * 3
                }

                HoverHandler {
                    id: mouse
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    cursorShape: Qt.PointingHandCursor
                }

                RowLayout {
                    spacing: 10
                    visible: !plasmoid.configuration.show_buttons_on_hover || mouse.hovered
                    Layout.alignment: Qt.AlignHCenter

                    PlasmaComponents.Button {
                        visible: isBreak() && plasmoid.configuration.fullscreen_buttons_postpone
                        text: "&Postpone"
                        icon.name: "circular-arrow-shape"
                        onClicked: postpone()
                    }

                    PlasmaComponents.Button {
                        visible: isBreak() && plasmoid.configuration.fullscreen_buttons_skip
                        text: "Sk&ip"
                        icon.name: "go-next-skip"
                        onClicked: skip()
                    }

                    PlasmaComponents.Button {
                        visible: isBreak() && plasmoid.configuration.fullscreen_buttons_close
                        text: "&Close"
                        icon.name: "dialog-close"
                        onClicked: {
                            breakDialog.close();
                        }
                    }

                    PlasmaComponents.Button {
                        visible: !isBreak()
                        text: "St&art"
                        icon.name: "media-playback-start"
                        onClicked: start()
                    }
                }
            }
        }
    }

    executable: ExecUtil {
        id: executable
    }

    compactRepresentation: MouseArea {
        id: compactRoot

        property int wheelDelta: 0

        property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
        property bool showIcon: plasmoid.configuration.show_icon_in_compact_mode
        property bool showTime: plasmoid.configuration.show_time_in_compact_mode

        function scrollByWheel(wheelDelta, eventDelta) {
            // magic number 120 for common "one click"
            // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
            wheelDelta += eventDelta;
            var increment = 0;
            while (wheelDelta >= 120) {
                wheelDelta -= 120;
                increment++;
            }
            while (wheelDelta <= -120) {
                wheelDelta += 120;
                increment--;
            }
            while (increment != 0) {
                if (increment > 0)
                    shiftCounter(60);
                else
                    shiftCounter(-60);
                updateTime();
                increment += (increment < 0) ? 1 : -1;
            }
            return wheelDelta;
        }

        property int baseIconSize: Math.min(Kirigami.Units.iconSizes.large, isVertical ? root.width : root.height)
        property int baseHorizontalFontSize: Math.floor(Math.min(Kirigami.Units.iconSizes.large, root.height) * 0.6)

        function getFontSize() {
            if (isVertical) {
                return Math.floor(Math.min(Kirigami.Units.iconSizes.large * 0.4, root.width * 0.4));
            } else {
                if (timeLabel.text.length > 5) {
                    return Math.floor(baseHorizontalFontSize * 0.8);
                }
                return baseHorizontalFontSize;
            }
        }

        Layout.preferredHeight: (!showTime || !isVertical) ? baseIconSize : (baseIconSize + timeLabel.height)
        Layout.preferredWidth: (!showTime || isVertical) ? baseIconSize : baseIconSize + baseHorizontalFontSize * 2.5

        Layout.minimumWidth: Kirigami.Units.iconSizes.small
        Layout.minimumHeight: Kirigami.Units.iconSizes.small
        Layout.maximumHeight: Layout.preferredHeight
        Layout.maximumWidth: Layout.preferredWidth

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        onClicked: mouse => {
            if (mouse.button === Qt.LeftButton)
                root.expanded = !root.expanded;
            else if (timer.running) {
                if (flowmodoroModeEnabled) {
                    skip();
                } else {
                    pause();
                }
            } else
                start();
        }
        onWheel: wheel => {
            if (flowmodoroModeEnabled) {
                return;
            }

            wheelDelta = scrollByWheel(wheelDelta, wheel.angleDelta.y);
        }

        GridLayout {
            columns: isVertical ? 1 : 2
            rows: isVertical ? 2 : 1
            rowSpacing: 0
            columnSpacing: 0

            anchors.fill: parent
            visible: plasmoid.configuration.show_time_in_compact_mode

            Item {
                visible: plasmoid.configuration.show_icon_in_compact_mode

                Layout.alignment: isVertical ? Qt.AlignHCenter : Qt.AlignLeft | Qt.AlignVCenter
                Layout.preferredWidth: baseIconSize
                Layout.preferredHeight: baseIconSize

                Kirigami.Icon {
                    id: trayIcon2
                    height: parent.width
                    width: parent.width
                    source: Qt.resolvedUrl(customIconSource)
                    smooth: true
                    color: getTextColor()
                }

                ColorOverlay {
                    anchors.fill: trayIcon2
                    source: trayIcon2
                    color: getTextColor()
                }
            }

            PlasmaComponents.Label {
                id: timeLabel
                font.pointSize: -1
                font.pixelSize: getFontSize()
                fontSizeMode: Text.FixedSize
                font.family: clock_fontfamily
                text: timeText
                minimumPixelSize: 1
                color: getTextColor()
                smooth: true
                Layout.alignment: Qt.AlignCenter
            }
        }

        Item {
            visible: plasmoid.configuration.show_time_in_compact_mode ? false : true

            Kirigami.Icon {
                id: trayIcon

                width: compactRoot.width
                height: compactRoot.height
                Layout.preferredWidth: height
                source: Qt.resolvedUrl(customIconSource)
                smooth: true
                color: getTextColor()
            }

            ColorOverlay {
                anchors.fill: trayIcon
                source: trayIcon
                color: getTextColor()
            }
        }
    }

    fullRepresentation: Item {
        id: fullRoot

        Layout.minimumWidth: Kirigami.Units.gridUnit * 12
        Layout.maximumWidth: Kirigami.Units.gridUnit * 18
        Layout.minimumHeight: Kirigami.Units.gridUnit * 11
        Layout.maximumHeight: Kirigami.Units.gridUnit * 18

        HoverHandler {
            id: mouse
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            cursorShape: Qt.PointingHandCursor
        }

        Item {
            anchors {
                top: fullRoot.top
                left: fullRoot.left
                right: fullRoot.right
                bottom: buttonsRow.top
            }

            MouseArea {
                property int wheelDelta: 0

                function scrollByWheel(wheelDelta, eventDelta) {
                    // magic number 120 for common "one click"
                    // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                    wheelDelta += eventDelta;
                    var increment = 0;
                    while (wheelDelta >= 120) {
                        wheelDelta -= 120;
                        increment++;
                    }
                    while (wheelDelta <= -120) {
                        wheelDelta += 120;
                        increment--;
                    }
                    while (increment != 0) {
                        if (increment > 0)
                            shiftCounter(60);
                        else
                            shiftCounter(-60);
                        updateTime();
                        increment += (increment < 0) ? 1 : -1;
                    }
                    return wheelDelta;
                }

                anchors.fill: parent
                onWheel: wheel => {
                    if (flowmodoroModeEnabled) {
                        return;
                    }
                    wheelDelta = scrollByWheel(wheelDelta, wheel.angleDelta.y);
                }
            }

            ProgressCircle {
                id: progressCircle

                anchors.centerIn: parent
                size: Math.min(parent.width / 1.4, parent.height / 1.4)
                colorCircle: getCircleColor()
                arcBegin: 0
                arcEnd: {
                    if (flowmodoroModeEnabled && !isBreak()) {
                        0;
                    } else {
                        Math.ceil((counterSeconds / initialSeconds) * 360);
                    }
                }
                lineWidth: size / 30
            }

            Item {
                anchors.centerIn: parent
                height: time.height

                PlasmaComponents.Label {
                    id: time

                    text: timeText
                    font.pointSize: Math.max(progressCircle.width / 8, 1)
                    font.family: clock_fontfamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Controls.PageIndicator {
                    id: pageIndicator
                    visible: flowmodoroModeEnabled ? false : numberOfSessions > 1
                    count: numberOfSessions
                    currentIndex: (stateVal - 1) / 2
                    spacing: progressCircle.width / 25

                    anchors {
                        bottom: time.top
                        horizontalCenter: parent.horizontalCenter
                        bottomMargin: progressCircle.width / 15
                    }

                    delegate: Rectangle {
                        implicitWidth: progressCircle.width / 34
                        implicitHeight: width
                        radius: width / 2
                        color: Kirigami.Theme.textColor
                        opacity: index === pageIndicator.currentIndex ? 0.95 : 0.45

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 100
                            }
                        }
                    }
                }

                PlasmaComponents.Label {
                    text: statusText
                    font.pointSize: Math.max(progressCircle.width / 24, 1)
                    color: getTextColor()

                    anchors {
                        top: time.bottom
                        horizontalCenter: parent.horizontalCenter
                        topMargin: progressCircle.width / 20
                    }
                }
            }
        }

        RowLayout {
            id: buttonsRow
            spacing: 10
            height: Kirigami.Units.gridUnit * 2
            visible: !plasmoid.configuration.show_buttons_on_hover || mouse.hovered

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            PlasmaComponents.Button {
                text: "Sk&ip"
                icon.name: "media-skip-forward"
                visible: !flowmodoroModeEnabled
                onClicked: skip()
            }

            PlasmaComponents.Button {
                id: sessionBtn
                text: sessionBtnText
                icon.name: sessionBtnIconSource
                onClicked: {
                    if (sessionBtnText == "St&art")
                        start();
                    else if (flowmodoroModeEnabled) {
                        skip();
                    } else {
                        pause();
                    }
                }
            }

            PlasmaComponents.Button {
                text: flowmodoroModeEnabled ? "Re&set" : "St&op"
                icon.name: flowmodoroModeEnabled ? "chronometer-reset" : "media-playback-stop"
                onClicked: stop()
            }
        }
    }
}
