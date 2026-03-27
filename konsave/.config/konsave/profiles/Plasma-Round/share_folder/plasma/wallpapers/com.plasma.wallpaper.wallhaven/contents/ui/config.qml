/*
 *  Copyright 2013 Marco Martin <mart@kde.org>
 *  Copyright 2014 Kai Uwe Broulik <kde@privat.broulik.de>
 *  Copyright 2022 Kyle Paulsen <kyle.a.paulsen@gmail.com>
 *  Copyright 2022 Link Dupont <link@sub-pop.net>
 *  Copyright 2024 Abubakar Yagoub <plasma@aolabs.dev>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import Qt.labs.platform 1.1 as Platform
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols 2.0 as KQuickControls
import org.kde.plasma.plasma5support 2.0 as Plasma5Support
import "utils.js" as Utils

Item {
    id: root

    // Accept the property systemsettings/plasmashell injects for KCMs.
    property var configDialog
    // Properties
    property var wallpaperConfiguration
    property alias cfg_Color: colorButton.color
    property alias cfg_Blur: blurRadioButton.checked
    property alias cfg_APIKey: apiKeyInput.text
    property alias cfg_Query: queryInput.text
    property int cfg_FillMode
    property int cfg_WallpaperDelay: 60
    property int cfg_WallpaperLimit: 100
    property int cfg_RetryRequestCount: 3
    property int cfg_RetryRequestDelay: 5
    property int cfg_ResolutionX: 1920
    property int cfg_ResolutionY: 1080
    property string cfg_Sorting
    property string cfg_TopRange
    property string cfg_SearchColor
    property bool cfg_CategoryGeneral
    property bool cfg_CategoryAnime
    property bool cfg_CategoryPeople
    property bool cfg_PuritySFW
    property bool cfg_PuritySketchy
    property bool cfg_PurityNSFW
    property bool cfg_RefreshNotification
    property bool cfg_ErrorNotification
    property bool cfg_FollowSystemTheme
    property bool cfg_RefetchSignal
    property string cfg_currentWallpaperThumbnail
    property bool cfg_UseSavedWallpapers
    property bool cfg_CycleSavedWallpapers
    property bool cfg_ShuffleSavedWallpapers
    property var cfg_SavedWallpapers
    property bool cfg_RatioAny
    property bool cfg_Ratio169
    property bool cfg_Ratio1610
    property bool cfg_RatioCustom
    property string cfg_RatioCustomValue
    readonly property string savedWallpapersDir: Utils.normalizePath(Platform.StandardPaths.writableLocation(Platform.StandardPaths.AppDataLocation)) + "/wallhaven-saved"
    readonly property string currentThumbnailSource: (wallpaperConfiguration && wallpaperConfiguration.currentWallpaperThumbnail) ? wallpaperConfiguration.currentWallpaperThumbnail : cfg_currentWallpaperThumbnail
    property bool systemSettingsContext: false

    function refreshImage() {
        cfg_RefetchSignal = !cfg_RefetchSignal;
        if (wallpaperConfiguration)
            wallpaperConfiguration.RefetchSignal = cfg_RefetchSignal;

        if (configDialog && "needsSave" in configDialog)
            configDialog.needsSave = true;

        if (configDialog && typeof configDialog.save === "function")
            configDialog.save();

    }

    function openSavedWallpapersFolder() {
        if (!savedWallpapersDir)
            return ;

        const cmd = `xdg-open "${savedWallpapersDir}"`;
        execHelper.connectSource(cmd);
    }

    function deleteSavedFiles(entries) {
        if (!entries || entries.length === 0)
            return ;

        const localPaths = entries.map((entry) => {
            const parsed = Utils.parseSavedEntry(entry);
            return parsed.localPath;
        }).filter((path) => {
            return path !== "";
        });
        if (localPaths.length === 0)
            return ;

        const escapedPaths = localPaths.map((path) => {
            return path.replace(/"/g, "\\\"");
        });
        const cmd = `rm -f ${escapedPaths.map((path) => `"${path}"`).join(" ")}`;
        execHelper.connectSource(cmd);
    }

    implicitWidth: parent.width
    implicitHeight: parent.height
    Component.onCompleted: {
        if (!wallpaperConfiguration) {
            if (configDialog && configDialog.configuration)
                wallpaperConfiguration = configDialog.configuration;
            else if (typeof wallpaper !== "undefined" && wallpaper && wallpaper.configuration)
                wallpaperConfiguration = wallpaper.configuration;
        }
        // Detect System Settings context: wallpaper global is not available
        systemSettingsContext = (typeof wallpaper === "undefined" || !wallpaper);
    }
    onConfigDialogChanged: {
        if (!wallpaperConfiguration && configDialog && configDialog.configuration)
            wallpaperConfiguration = configDialog.configuration;

    }

    Kirigami.InlineMessage {
        id: systemSettingsWarning

        visible: systemSettingsContext
        type: Kirigami.MessageType.Warning
        text: i18n("You are configuring this plugin from System Settings. Some features may be unstable here. For the best experience, right-click your desktop and select <b>Configure Desktop and Wallpaper\u2026</b> instead.")
        showCloseButton: false

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: Kirigami.Units.mediumSpacing
        }

    }

    ScrollView {
        id: scrollView

        clip: true
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded

        // Basic layout setup
        anchors {
            top: systemSettingsContext ? systemSettingsWarning.bottom : parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: Kirigami.Units.smallSpacing
            leftMargin: Kirigami.Units.smallSpacing
            rightMargin: Kirigami.Units.smallSpacing
        }

        Kirigami.FormLayout {
            id: formLayout

            // Fix binding loop by using a fixed width calculation
            width: scrollView.width - (scrollView.ScrollBar.vertical.visible ? scrollView.ScrollBar.vertical.width + Kirigami.Units.smallSpacing : 0) - Kirigami.Units.largeSpacing

            Item {
                Kirigami.FormData.label: i18n("Current Wallpaper:")
                implicitHeight: 200
                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.largeSpacing
                Layout.bottomMargin: Kirigami.Units.largeSpacing
                visible: currentThumbnailSource !== ""

                Kirigami.ShadowedRectangle {
                    id: imageContainer

                    anchors.centerIn: parent
                    height: 160
                    width: 250
                    radius: 8
                    shadow.size: 15
                    shadow.color: Qt.rgba(0, 0, 0, 0.2)
                    shadow.yOffset: 2
                    Kirigami.Theme.colorSet: Kirigami.Theme.View
                    Kirigami.Theme.inherit: false
                    color: Kirigami.Theme.alternateBackgroundColor

                    Image {
                        id: currentWallpaper

                        anchors.fill: parent
                        anchors.margins: 5
                        fillMode: Image.PreserveAspectCrop
                        source: currentThumbnailSource
                        asynchronous: true
                        cache: true
                        smooth: true
                    }

                }

            }

            // Display and Positioning section
            ComboBox {
                id: resizeComboBox

                function setMethod() {
                    for (var i = 0; i < model.length; i++) {
                        const fillModeValue = wallpaperConfiguration ? wallpaperConfiguration.FillMode : cfg_FillMode;
                        if (model[i]["fillMode"] === fillModeValue) {
                            resizeComboBox.currentIndex = i;
                            var tl = model[i]["label"].length;
                        }
                    }
                }

                Kirigami.FormData.label: i18nd("plasma_wallpaper_org.kde.image", "Positioning:")
                model: [{
                    "label": i18nd("plasma_wallpaper_org.kde.image", "Scaled and Cropped"),
                    "fillMode": Image.PreserveAspectCrop
                }, {
                    "label": i18nd("plasma_wallpaper_org.kde.image", "Scaled"),
                    "fillMode": Image.Stretch
                }, {
                    "label": i18nd("plasma_wallpaper_org.kde.image", "Scaled, Keep Proportions"),
                    "fillMode": Image.PreserveAspectFit
                }, {
                    "label": i18nd("plasma_wallpaper_org.kde.image", "Centered"),
                    "fillMode": Image.Pad
                }, {
                    "label": i18nd("plasma_wallpaper_org.kde.image", "Tiled"),
                    "fillMode": Image.Tile
                }]
                textRole: "label"
                onCurrentIndexChanged: cfg_FillMode = model[currentIndex]["fillMode"]
                Component.onCompleted: setMethod()
            }

            // Background options
            ButtonGroup {
                id: backgroundGroup
            }

            RadioButton {
                id: blurRadioButton

                visible: cfg_FillMode === Image.PreserveAspectFit || cfg_FillMode === Image.Pad
                Kirigami.FormData.label: i18nd("plasma_wallpaper_org.kde.image", "Background:")
                text: i18nd("plasma_wallpaper_org.kde.image", "Blur")
                ButtonGroup.group: backgroundGroup
            }

            RowLayout {
                id: colorRow

                visible: cfg_FillMode === Image.PreserveAspectFit || cfg_FillMode === Image.Pad

                RadioButton {
                    id: colorRadioButton

                    text: i18nd("plasma_wallpaper_org.kde.image", "Solid color")
                    checked: !cfg_Blur
                    ButtonGroup.group: backgroundGroup
                }

                KQuickControls.ColorButton {
                    id: colorButton

                    dialogTitle: i18nd("plasma_wallpaper_org.kde.image", "Select Background Color")
                }

            }

            // Saved Wallpapers Section
            Item {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Saved Wallpapers")
            }

            GroupBox {
                Layout.fillWidth: true
                padding: Kirigami.Units.smallSpacing

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Kirigami.Units.smallSpacing

                    CheckBox {
                        id: useSavedWallpapersCheckbox

                        text: i18n("Use saved wallpapers only")
                        checked: cfg_UseSavedWallpapers
                        onToggled: cfg_UseSavedWallpapers = checked
                        ToolTip.text: i18n("When enabled, only cycle through your saved wallpapers instead of fetching from Wallhaven")
                        ToolTip.visible: hovered
                    }

                    CheckBox {
                        id: cycleSavedWallpapersCheckbox

                        text: i18n("Loop through saved wallpapers")
                        checked: cfg_CycleSavedWallpapers
                        enabled: cfg_UseSavedWallpapers
                        onToggled: cfg_CycleSavedWallpapers = checked
                        ToolTip.text: i18n("When all saved wallpapers have been shown, restart from the beginning. If disabled, fetch new wallpapers from Wallhaven instead.")
                        ToolTip.visible: hovered
                    }

                    CheckBox {
                        id: shuffleSavedWallpapersCheckbox

                        text: i18n("Shuffle saved wallpapers")
                        checked: cfg_ShuffleSavedWallpapers
                        enabled: cfg_UseSavedWallpapers
                        onToggled: cfg_ShuffleSavedWallpapers = checked
                        ToolTip.text: i18n("Show saved wallpapers in random order. If disabled, they will display in the order they were saved.")
                        ToolTip.visible: hovered
                    }

                    Label {
                        text: {
                            const count = cfg_SavedWallpapers ? cfg_SavedWallpapers.length : 0;
                            return i18n("Saved wallpapers: %1", count);
                        }
                        color: Kirigami.Theme.textColor
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                    }

                    Label {
                        text: i18n("Right-click desktop → 'Save Wallpaper' to add to collection")
                        color: Kirigami.Theme.disabledTextColor
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        font.italic: true
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        Layout.topMargin: Kirigami.Units.smallSpacing
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.smallSpacing
                        Layout.topMargin: Kirigami.Units.smallSpacing

                        Button {
                            text: i18n("Open Folder")
                            icon.name: "folder-open"
                            enabled: savedWallpapersDir !== ""
                            onClicked: openSavedWallpapersFolder()
                            ToolTip.text: i18n("Open saved wallpapers folder in the file manager")
                            ToolTip.visible: hovered
                        }

                        Button {
                            text: i18n("Clear All")
                            icon.name: "edit-clear-all"
                            enabled: !!(cfg_SavedWallpapers && cfg_SavedWallpapers.length > 0)
                            onClicked: {
                                deleteSavedFiles(cfg_SavedWallpapers || []);
                                cfg_SavedWallpapers = [];
                            }
                            ToolTip.text: i18n("Remove all saved wallpapers")
                            ToolTip.visible: hovered
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                    }

                }

                background: Rectangle {
                    color: "transparent"
                    border.width: 0
                }

            }

            // Wallhaven API Settings
            Item {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Search Settings")
            }

            TextField {
                id: apiKeyInput

                text: root.cfg_APIKey
                placeholderText: i18n("Optional API Key to access NSFW content")
                Kirigami.FormData.label: i18n("API Key:")
                leftPadding: 12
                onTextChanged: cfg_APIKey = text
            }

            RowLayout {
                id: queryRow

                width: parent.width
                Layout.fillWidth: true
                Kirigami.FormData.label: i18n("Query:")

                TextField {
                    id: queryInput

                    Layout.fillWidth: true
                    text: root.cfg_Query
                    placeholderText: i18n("nature, landscape, @username, id:123456")
                    ToolTip.text: "Search terms separated by comma"
                    ToolTip.visible: queryInput.activeFocus
                    leftPadding: 12
                }

                Button {
                    icon.name: "dialog-information-symbolic"
                    ToolTip.text: i18n("<b>Supported Query Formats:</b><ul><li>tag name (fuzzy): <code>nature</code>, <code>landscape</code></li><li>exact tag by numeric ID: <code>id:1</code> (cannot be combined)</li><li>wallhaven username: <code>@username</code></li><li>similar wallpapers: <code>like:abc123z</code> (wallpaper ID from URL)</li><li>comma-separated list: <code>nature,@username,like:abc123z</code></li></ul>Each comma-separated entry is picked randomly and must be a valid standalone query. Tag names must be real wallhaven tags, not arbitrary words or numbers.")
                    highlighted: true
                    hoverEnabled: true
                    ToolTip.visible: hovered
                    Kirigami.Theme.inherit: false
                    flat: true
                    Layout.alignment: Qt.AlignRight
                    Layout.fillWidth: false
                }

            }

            GroupBox {
                Kirigami.FormData.label: i18n("Color Scheme:")
                Layout.fillWidth: true

                CheckBox {
                    text: i18n("Follow system color scheme")
                    checked: cfg_FollowSystemTheme
                    onToggled: cfg_FollowSystemTheme = checked
                    ToolTip.text: i18n("Automatically add 'dark' tag and dark colors when system is in Dark Mode")
                    ToolTip.visible: hovered
                }

            }

            // Categories section
            GroupBox {
                Kirigami.FormData.label: i18n("Categories:")
                Layout.fillWidth: true
                padding: Kirigami.Units.smallSpacing

                RowLayout {
                    anchors.fill: parent
                    spacing: Kirigami.Units.largeSpacing

                    CheckBox {
                        text: i18n("General")
                        checked: cfg_CategoryGeneral
                        onToggled: cfg_CategoryGeneral = checked
                    }

                    CheckBox {
                        text: i18n("Anime")
                        checked: cfg_CategoryAnime
                        onToggled: cfg_CategoryAnime = checked
                    }

                    CheckBox {
                        text: i18n("People")
                        checked: cfg_CategoryPeople
                        onToggled: cfg_CategoryPeople = checked
                    }

                }

                background: Rectangle {
                    color: "transparent"
                    border.width: 0
                }

            }

            GroupBox {
                Kirigami.FormData.label: i18n("Purity:")
                Layout.fillWidth: true
                padding: Kirigami.Units.smallSpacing

                RowLayout {
                    anchors.fill: parent
                    spacing: Kirigami.Units.largeSpacing

                    CheckBox {
                        text: i18n("SFW")
                        checked: cfg_PuritySFW
                        onToggled: cfg_PuritySFW = checked
                    }

                    CheckBox {
                        text: i18n("Sketchy")
                        checked: cfg_PuritySketchy
                        onToggled: cfg_PuritySketchy = checked
                    }

                    CheckBox {
                        text: i18n("NSFW")
                        checked: cfg_PurityNSFW
                        onToggled: cfg_PurityNSFW = checked
                    }

                }

                background: Rectangle {
                    color: "transparent"
                    border.width: 0
                }

            }

            GroupBox {
                id: aspectRatioGroupBox

                Kirigami.FormData.label: i18n("Aspect ratio:")
                Layout.fillWidth: true
                padding: Kirigami.Units.smallSpacing

                ColumnLayout {
                    anchors.fill: parent
                    spacing: Kirigami.Units.largeSpacing

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: Kirigami.Units.largeSpacing

                        CheckBox {
                            text: i18n("Any")
                            checked: cfg_RatioAny
                            onToggled: cfg_RatioAny = checked
                        }

                        CheckBox {
                            text: "16x9"
                            checked: cfg_Ratio169
                            enabled: !cfg_RatioAny
                            onToggled: cfg_Ratio169 = checked
                        }

                        CheckBox {
                            text: "16x10"
                            checked: cfg_Ratio1610
                            enabled: !cfg_RatioAny
                            onToggled: cfg_Ratio1610 = checked
                        }

                        CheckBox {
                            text: i18n("Custom")
                            checked: cfg_RatioCustom
                            enabled: !cfg_RatioAny
                            onToggled: cfg_RatioCustom = checked
                        }

                    }

                    TextField {
                        id: customRatioInput

                        Layout.fillWidth: true
                        visible: cfg_RatioCustom
                        enabled: !cfg_RatioAny
                        text: cfg_RatioCustomValue
                        onTextChanged: cfg_RatioCustomValue = text
                        ToolTip.text: i18n("Custom aspect ratios separated by comma (e.g. 16x9,16x10)")
                        ToolTip.visible: customRatioInput.activeFocus
                    }

                }

                background: Rectangle {
                    color: "transparent"
                    border.width: 0
                }

            }

            // Resolution controls
            RowLayout {
                id: resolutionRow

                Kirigami.FormData.label: i18n("Resolution:")

                SpinBox {
                    id: resXInput

                    value: cfg_ResolutionX
                    onValueChanged: cfg_ResolutionX = value
                    stepSize: 1
                    from: 1
                    to: 15360
                    editable: true
                    textFromValue: function(value, locale) {
                        return " " + value + "px";
                    }
                    valueFromText: function(text, locale) {
                        return text.replace(/px/, '');
                    }
                }

                SpinBox {
                    id: resYInput

                    value: cfg_ResolutionY
                    onValueChanged: cfg_ResolutionY = value
                    stepSize: 1
                    from: 1
                    to: 15360
                    editable: true
                    textFromValue: function(value, locale) {
                        return " " + value + "px";
                    }
                    valueFromText: function(text, locale) {
                        return text.replace(/px/, '');
                    }
                }

            }

            // Sorting controls
            ComboBox {
                id: sortingInput

                Kirigami.FormData.label: i18n("Sorting:")
                textRole: "text"
                valueRole: "value"
                model: [{
                    "text": i18n("Date Added"),
                    "value": "date_added"
                }, {
                    "text": i18n("Relevance"),
                    "value": "relevance"
                }, {
                    "text": i18n("Random"),
                    "value": "random"
                }, {
                    "text": i18n("Views"),
                    "value": "views"
                }, {
                    "text": i18n("Favorites"),
                    "value": "favorites"
                }, {
                    "text": i18n("Top List"),
                    "value": "toplist"
                }]
                Component.onCompleted: currentIndex = indexOfValue(cfg_Sorting)
                onActivated: cfg_Sorting = currentValue
            }

            ComboBox {
                id: topRangeInput

                Kirigami.FormData.label: i18n("Top List Range:")
                visible: cfg_Sorting === "toplist"
                textRole: "text"
                valueRole: "value"
                model: [{
                    "text": i18n("One day"),
                    "value": "1d"
                }, {
                    "text": i18n("Three days"),
                    "value": "3d"
                }, {
                    "text": i18n("One week"),
                    "value": "1w"
                }, {
                    "text": i18n("One month"),
                    "value": "1M"
                }, {
                    "text": i18n("Three months"),
                    "value": "3M"
                }, {
                    "text": i18n("Six months"),
                    "value": "6M"
                }, {
                    "text": i18n("One year"),
                    "value": "1y"
                }]
                Component.onCompleted: currentIndex = indexOfValue(cfg_TopRange)
                onActivated: cfg_TopRange = currentValue
            }

            Item {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Timer Settings")
            }

            // Timer settings
            RowLayout {
                Kirigami.FormData.label: i18n("Change every:")
                Layout.bottomMargin: Kirigami.Units.largeSpacing

                SpinBox {
                    id: delaySpinBox

                    value: cfg_WallpaperDelay
                    onValueChanged: cfg_WallpaperDelay = value
                    stepSize: 1
                    from: 1
                    to: 50000
                    editable: true
                    textFromValue: function(value, locale) {
                        return " " + value + " minutes";
                    }
                    valueFromText: function(text, locale) {
                        return text.replace(/ minutes/, '');
                    }
                }

                Button {
                    icon.name: "view-refresh"
                    ToolTip.text: "Refresh Wallpaper"
                    ToolTip.visible: hovered
                    onClicked: {
                        focus = false;
                        refreshImage();
                    }
                }

            }

            RowLayout {
                Kirigami.FormData.label: i18n("Retry Failed request every:")
                Layout.bottomMargin: Kirigami.Units.largeSpacing

                SpinBox {
                    id: retryDelaySpinBox

                    value: cfg_RetryRequestDelay
                    onValueChanged: cfg_RetryRequestDelay = value
                    stepSize: 1
                    from: 1
                    to: 60
                    editable: true
                    textFromValue: function(value, locale) {
                        return " " + value + " seconds";
                    }
                    valueFromText: function(text, locale) {
                        return text.replace(/ seconds/, '');
                    }
                }

                SpinBox {
                    id: retryCountSpinBox

                    value: cfg_RetryRequestCount
                    onValueChanged: cfg_RetryRequestCount = value
                    stepSize: 1
                    from: 1
                    to: 10
                    editable: true
                    ToolTip.text: "max number of retries"
                    ToolTip.visible: hovered
                    textFromValue: function(value, locale) {
                        return " " + value + " times";
                    }
                    valueFromText: function(text, locale) {
                        return text.replace(/ times/, '');
                    }
                }

            }

            // Notification controls using GroupBox
            GroupBox {
                Kirigami.FormData.label: i18n("Show Notification:")
                Layout.fillWidth: true
                padding: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.gridUnit

                RowLayout {
                    anchors.fill: parent
                    spacing: Kirigami.Units.largeSpacing * 2

                    CheckBox {
                        text: i18n("Refresh")
                        checked: cfg_RefreshNotification
                        ToolTip.text: i18n("Show a notification when the wallpaper is refreshed")
                        ToolTip.visible: hovered
                        onToggled: {
                            cfg_RefreshNotification = checked;
                            if (wallpaperConfiguration)
                                wallpaperConfiguration.refreshNotification = checked;

                        }
                    }

                    CheckBox {
                        text: i18n("Error")
                        checked: cfg_ErrorNotification
                        ToolTip.text: i18n("Show a notification when an error occurs")
                        ToolTip.visible: hovered
                        onToggled: {
                            cfg_ErrorNotification = checked;
                            if (wallpaperConfiguration)
                                wallpaperConfiguration.errorNotification = checked;

                        }
                    }

                }

                background: Rectangle {
                    color: "transparent"
                    border.width: 0
                }

            }

            // Add extra space at the bottom to ensure everything is visible when scrolling
            Item {
                implicitHeight: Kirigami.Units.gridUnit
            }

        }

    }

    Plasma5Support.DataSource {
        id: execHelper

        engine: "executable"
        connectedSources: []
        onNewData: function(sourceName, data) {
            disconnectSource(sourceName);
        }
    }

}
