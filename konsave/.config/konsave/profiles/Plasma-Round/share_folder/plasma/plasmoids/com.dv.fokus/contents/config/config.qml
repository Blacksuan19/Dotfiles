import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: "General"
        icon: "preferences-system"
        source: "configGeneral.qml"
    }

    ConfigCategory {
        name: "Timer"
        icon: "preferences-system-time"
        source: "configTimer.qml"
    }

    ConfigCategory {
        name: "Notifications"
        icon: "preferences-desktop-notifications"
        source: "configNotifications.qml"
    }

    ConfigCategory {
        name: "Scripts"
        icon: "preferences-plugin"
        source: "configScripts.qml"
    }

}
