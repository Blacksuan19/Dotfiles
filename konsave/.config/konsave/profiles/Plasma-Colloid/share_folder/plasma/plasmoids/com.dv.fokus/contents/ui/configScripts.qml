import QtMultimedia
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils

KCMUtils.SimpleKCM {
    id: root

    property alias cfg_start_focus_script_filepath: start_focus_script_filepath.text
    property alias cfg_start_focus_script_enabled: start_focus_script_enabled.checked
    property alias cfg_start_break_script_filepath: start_break_script_filepath.text
    property alias cfg_start_break_script_enabled: start_break_script_enabled.checked
    property alias cfg_end_focus_script_filepath: end_focus_script_filepath.text
    property alias cfg_end_focus_script_enabled: end_focus_script_enabled.checked
    property alias cfg_end_break_script_filepath: end_break_script_filepath.text
    property alias cfg_end_break_script_enabled: end_break_script_enabled.checked
    property alias cfg_stop_script_filepath: stop_script_filepath.text
    property alias cfg_stop_script_enabled: stop_script_enabled.checked

    function getPath(fileUrl) {
        // remove prefixed "file://"
        return fileUrl.toString().replace(/^file:\/\//, "");
    }

    Kirigami.FormLayout {
        anchors.fill: parent

        RowLayout {
            Kirigami.FormData.label: i18n("Start focus:")

            QQC2.CheckBox {
                id: start_focus_script_enabled
            }

            QQC2.TextField {
                id: start_focus_script_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                Layout.fillWidth: true
                enabled: cfg_start_focus_script_enabled
                placeholderText: ""
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: start_focus_script_filepathDialog.visible = true
                enabled: cfg_start_focus_script_enabled
            }

        }

        RowLayout {
            Kirigami.FormData.label: i18n("Start break:")

            QQC2.CheckBox {
                id: start_break_script_enabled
            }

            QQC2.TextField {
                id: start_break_script_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                Layout.fillWidth: true
                enabled: cfg_start_break_script_enabled
                placeholderText: ""
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: start_break_script_filepathDialog.visible = true
                enabled: cfg_start_break_script_enabled
            }

        }

        RowLayout {
            Kirigami.FormData.label: i18n("End focus:")

            QQC2.CheckBox {
                id: end_focus_script_enabled
            }

            QQC2.TextField {
                id: end_focus_script_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                Layout.fillWidth: true
                enabled: cfg_end_focus_script_enabled
                placeholderText: ""
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: end_focus_script_filepathDialog.visible = true
                enabled: cfg_end_focus_script_enabled
            }

        }

        RowLayout {
            Kirigami.FormData.label: i18n("End break:")

            QQC2.CheckBox {
                id: end_break_script_enabled
            }

            QQC2.TextField {
                id: end_break_script_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                Layout.fillWidth: true
                enabled: cfg_end_break_script_enabled
                placeholderText: ""
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: end_break_script_filepathDialog.visible = true
                enabled: cfg_end_break_script_enabled
            }

        }

        RowLayout {
            Kirigami.FormData.label: i18n("Stop:")

            QQC2.CheckBox {
                id: stop_script_enabled
            }

            QQC2.TextField {
                id: stop_script_filepath

                Layout.maximumWidth: Kirigami.Units.gridUnit * 15
                Layout.fillWidth: true
                enabled: cfg_stop_script_enabled
                placeholderText: ""
            }

            QQC2.Button {
                icon.name: "quickopen-file"
                onClicked: stop_script_filepathDialog.visible = true
                enabled: cfg_stop_script_enabled
            }

        }

    }

    FileDialog {
        id: stop_script_filepathDialog

        title: i18n("Choose stop action script")
        currentFolder: '~/'
        nameFilters: ["Script file (*.sh)", "All files (*)"]
        onAccepted: {
            cfg_stop_script_filepath = getPath(stop_script_filepathDialog.currentFile);
        }
    }

    FileDialog {
        id: start_focus_script_filepathDialog

        title: i18n("Choose start focus action script")
        currentFolder: '~/'
        nameFilters: ["Script file (*.sh)", "All files (*)"]
        onAccepted: {
            cfg_start_focus_script_filepath = getPath(start_focus_script_filepathDialog.currentFile);
        }
    }

    FileDialog {
        id: start_break_script_filepathDialog

        title: i18n("Choose start break action script")
        currentFolder: '~/'
        nameFilters: ["Script file (*.sh)", "All files (*)"]
        onAccepted: {
            cfg_start_break_script_filepath = getPath(start_break_script_filepathDialog.currentFile);
        }
    }

    FileDialog {
        id: end_focus_script_filepathDialog

        title: i18n("Choose end focus action script")
        currentFolder: '~/'
        nameFilters: ["Script file (*.sh)", "All files (*)"]
        onAccepted: {
            cfg_end_focus_script_filepath = getPath(end_focus_script_filepathDialog.currentFile);
        }
    }

    FileDialog {
        id: end_break_script_filepathDialog

        title: i18n("Choose end break action script")
        currentFolder: '~/'
        nameFilters: ["Script file (*.sh)", "All files (*)"]
        onAccepted: {
            cfg_end_break_script_filepath = getPath(end_break_script_filepathDialog.currentFile);
        }
    }

}
