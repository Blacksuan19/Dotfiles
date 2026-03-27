import QtMultimedia
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils

KCMUtils.SimpleKCM {
    id: root

    property alias cfg_timer_start_notification_enabled: timer_start_notification_enabled.checked
    property alias cfg_timer_end_notification_enabled: timer_end_notification_enabled.checked
    property alias cfg_timer_start_sfx_enabled: timer_start_sfx_enabled.checked
    property alias cfg_timer_start_sfx_filepath: timer_start_sfx_filepath.text
    property alias cfg_timer_stop_sfx_enabled: timer_stop_sfx_enabled.checked
    property alias cfg_timer_stop_sfx_filepath: timer_stop_sfx_filepath.text
    property alias cfg_timer_tick_sfx_enabled: timer_tick_sfx_enabled.checked
    property alias cfg_timer_tick_sfx_filepath: timer_tick_sfx_filepath.text

    function getPath(fileUrl) {
        // remove prefixed "file://"
        return fileUrl.toString().replace(/^file:\/\//, "");
    }

    MediaPlayer {
        id: sfx

        audioOutput: AudioOutput {
        }

    }

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: timer_start_notification_enabled

            Kirigami.FormData.label: i18n("Start notification:")
            text: i18n("show")
        }

        RowLayout {
            QQC2.CheckBox {
                id: timer_start_sfx_enabled

                text: i18n("sound")
            }

            QQC2.TextField {
                id: timer_start_sfx_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                Layout.fillWidth: true
                enabled: cfg_timer_start_sfx_enabled
                placeholderText: "/usr/share/sounds/ocean/stereo/dialog-information.oga"
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: timer_start_sfx_filepathDialog.visible = true
                enabled: cfg_timer_start_sfx_enabled
            }

            QQC2.Button {
                icon.name: "media-playback-start"
                enabled: cfg_timer_start_sfx_enabled
                onClicked: {
                    sfx.source = timer_start_sfx_filepath.text;
                    sfx.play();
                }
            }

        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.CheckBox {
            id: timer_end_notification_enabled

            Kirigami.FormData.label: i18n("End notification:")
            text: i18n("show")
        }

        RowLayout {
            QQC2.CheckBox {
                id: timer_stop_sfx_enabled

                text: i18n("sound")
            }

            QQC2.TextField {
                id: timer_stop_sfx_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                enabled: cfg_timer_stop_sfx_enabled
                placeholderText: "/usr/share/sounds/ocean/stereo/dialog-question.oga"
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: timer_stop_sfx_filepathDialog.visible = true
                enabled: cfg_timer_stop_sfx_enabled
            }

            QQC2.Button {
                enabled: cfg_timer_stop_sfx_enabled
                icon.name: "media-playback-start"
                onClicked: {
                    sfx.source = timer_stop_sfx_filepath.text;
                    sfx.play();
                }
            }

        }

        Item {
            Kirigami.FormData.isSection: true
        }

        RowLayout {
            QQC2.CheckBox {
                id: timer_tick_sfx_enabled

                Kirigami.FormData.label: i18n("Counter tick:")
                text: i18n("sound")
            }

            QQC2.TextField {
                id: timer_tick_sfx_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                Layout.fillWidth: true
                enabled: cfg_timer_tick_sfx_enabled
                placeholderText: "/usr/share/sounds/ocean/stereo/dialog-warning.oga"
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: timer_tick_sfx_filepathDialog.visible = true
                enabled: cfg_timer_tick_sfx_enabled
            }

            QQC2.Button {
                enabled: cfg_timer_tick_sfx_enabled
                icon.name: "media-playback-start"
                onClicked: {
                    sfx.source = timer_tick_sfx_filepath.text;
                    sfx.play();
                }
            }

        }

    }

    FileDialog {
        id: timer_start_sfx_filepathDialog

        title: i18n("Choose a sound effect")
        currentFolder: "file:///usr/share/sounds"
        nameFilters: ["Sound files (*.wav *.mp3 *.oga *.ogg)", "All files (*)"]
        onAccepted: {
            cfg_timer_start_sfx_filepath = getPath(timer_start_sfx_filepathDialog.currentFile);
        }
    }

    FileDialog {
        id: timer_stop_sfx_filepathDialog

        title: i18n("Choose a sound effect")
        currentFolder: "file:///usr/share/sounds"
        nameFilters: ["Sound files (*.wav *.mp3 *.oga *.ogg)", "All files (*)"]
        onAccepted: {
            cfg_timer_stop_sfx_filepath = getPath(timer_stop_sfx_filepathDialog.currentFile);
        }
    }

    FileDialog {
        id: timer_tick_sfx_filepathDialog

        title: i18n("Choose a sound effect")
        currentFolder: "file:///usr/share/sounds"
        nameFilters: ["Sound files (*.wav *.mp3 *.oga *.ogg)", "All files (*)"]
        onAccepted: {
            cfg_timer_tick_sfx_filepath = getPath(timer_tick_sfx_filepathDialog.currentFile);
        }
    }

}
