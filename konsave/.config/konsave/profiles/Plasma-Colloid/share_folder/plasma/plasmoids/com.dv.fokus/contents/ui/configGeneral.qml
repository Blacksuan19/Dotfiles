import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils

KCMUtils.SimpleKCM {
    id: root

    property string cfg_clock_fontfamily: ""
    property alias cfg_show_time_in_compact_mode: show_time_in_compact_mode.checked
    property alias cfg_show_icon_in_compact_mode: show_icon_in_compact_mode.checked
    property alias cfg_show_fullscreen_break: show_fullscreen_break.checked
    property alias cfg_fullscreen_buttons_postpone: fullscreen_buttons_postpone.checked
    property alias cfg_fullscreen_buttons_skip: fullscreen_buttons_skip.checked
    property alias cfg_fullscreen_buttons_close: fullscreen_buttons_close.checked
    property alias cfg_timer_auto_pause_enabled: timer_auto_pause_enabled.checked
    property alias cfg_timer_auto_focus_enabled: timer_auto_focus_enabled.checked
    property alias cfg_autostart: autostart.checked
    property alias cfg_do_not_disturb_enabled: do_not_disturb_enabled.checked
    property alias cfg_show_buttons_on_hover: show_buttons_on_hover.checked
    property alias cfg_flowmodoro_mode_enabled: flowmodoro_mode_enabled.checked

    onCfg_clock_fontfamilyChanged: {
        if (cfg_clock_fontfamily) {
            for (var i = 0, j = clock_fontfamilyComboBox.model.length; i < j; ++i) {
                if (clock_fontfamilyComboBox.model[i].value == cfg_clock_fontfamily) {
                    clock_fontfamilyComboBox.currentIndex = i;
                    break;
                }
            }
        }
    }
    onCfg_flowmodoro_mode_enabledChanged: {
        cfg_fullscreen_buttons_postpone = !cfg_flowmodoro_mode_enabled
    }

    Kirigami.FormLayout {
        anchors.fill: parent

        QQC2.ComboBox {
            id: clock_fontfamilyComboBox

            Kirigami.FormData.label: i18n("Timer font:")
            textRole: "text"
            Component.onCompleted: {
                var arr = [];
                arr.push({
                    "text": i18n("Default"),
                    "value": ""
                });
                var fonts = Qt.fontFamilies();
                var foundIndex = 0;
                for (var i = 0, j = fonts.length; i < j; ++i) {
                    arr.push({
                        "text": fonts[i],
                        "value": fonts[i]
                    });
                }
                model = arr;
            }
            onCurrentIndexChanged: {
                var current = model[currentIndex];
                if (current)
                    cfg_clock_fontfamily = current.value;
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }


        QQC2.CheckBox {
            id: show_icon_in_compact_mode

            Kirigami.FormData.label: i18n("Show icon in compact view:")
        }

        QQC2.CheckBox {
            id: show_time_in_compact_mode

            Kirigami.FormData.label: i18n("Show time in compact view:")
        }

        QQC2.CheckBox {
            id: autostart

            Kirigami.FormData.label: i18n("Autostart after system boot:")
        }

        QQC2.CheckBox {
            id: do_not_disturb_enabled

            Kirigami.FormData.label: i18n("Enable Do Not Disturb mode during focus session:")
        }

        RowLayout {
            spacing: Kirigami.Units.smallSpacing

            Kirigami.FormData.label: i18n("Automatically start timer for:")

            QQC2.CheckBox {
                id: timer_auto_focus_enabled

                text: i18n("Fokus")
            }

            QQC2.CheckBox {
                id: timer_auto_pause_enabled

                text: i18n("Break")
            }
        }

        QQC2.CheckBox {
            id: show_fullscreen_break

            Kirigami.FormData.label: i18n("Show fullscreen overlay on break:")
        }

        RowLayout {
            spacing: Kirigami.Units.smallSpacing

            Kirigami.FormData.label: i18n("Fullscreen overlay buttons visibility:")

            QQC2.CheckBox {
                id: fullscreen_buttons_postpone
                text: i18n("Postpone")
                enabled: !flowmodoro_mode_enabled.checked
            }
            QQC2.CheckBox {
                id: fullscreen_buttons_skip
                text: i18n("Skip")
            }
            QQC2.CheckBox {
                id: fullscreen_buttons_close
                text: i18n("Close")
            }
        }
        QQC2.CheckBox {
            id: show_buttons_on_hover

            Kirigami.FormData.label: i18n("Show buttons only on hover:")
        }
        QQC2.CheckBox {
            id: flowmodoro_mode_enabled

            Kirigami.FormData.label: i18n("Turn on flowmodoro mode:")
        }
    }
}
