import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils

KCMUtils.SimpleKCM {
    id: root

    property alias cfg_focus_time: focus_time.value
    property alias cfg_short_break_time: short_break_time.value
    property alias cfg_long_break_time: long_break_time.value
    property alias cfg_ticking_time: ticking_time.value
    property alias cfg_number_of_sessions: number_of_sessions.value
    property alias cfg_flow_divisor: flow_divisor.value

    Kirigami.FormLayout {
        anchors.fill: parent

        RowLayout {
            Kirigami.FormData.label: i18n("Number of sessions:")

            QQC2.SpinBox {
                id: number_of_sessions

                to: 10
                from: 1
                enabled: !plasmoid.configuration.flowmodoro_mode_enabled
            }

        }

        RowLayout {
            Kirigami.FormData.label: i18n("Focus:")

            QQC2.SpinBox {
                id: focus_time
                enabled: !plasmoid.configuration.flowmodoro_mode_enabled

                to: 9999
                from: 1
                textFromValue: function(value, locale) {
                    return qsTr("%1 min").arg(value);
                }

                valueFromText: function(text, locale) {
                    return parseInt(text) || from
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Short break:")

            QQC2.SpinBox {
                id: short_break_time
                enabled: !plasmoid.configuration.flowmodoro_mode_enabled
                
                to: 9999
                textFromValue: function(value, locale) {
                    return qsTr("%1 min").arg(value);
                }

                valueFromText: function(text, locale) {
                    return parseInt(text) || from
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Long break:")

            QQC2.SpinBox {
                id: long_break_time
                enabled: !plasmoid.configuration.flowmodoro_mode_enabled

                to: 9999
                textFromValue: function(value, locale) {
                    return qsTr("%1 min").arg(value);
                }

                valueFromText: function(text, locale) {
                    return parseInt(text) || from
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Ticking time:")

            QQC2.SpinBox {
                id: ticking_time

                to: 60
                textFromValue: function(value, locale) {
                    return qsTr("%1 s").arg(value);
                }
                valueFromText: function(text, locale) {
                    return parseInt(text) || from
                }
            }
        }
        RowLayout {
            Kirigami.FormData.label: i18n("Flow divisor: ")

            QQC2.SpinBox {
                id: flow_divisor

                from: 1
                to: 9999
                textFromValue: function(value, locale) {
                    return qsTr("%1 m").arg(value);
                }
                enabled: plasmoid.configuration.flowmodoro_mode_enabled
            }
        }

    }

}
