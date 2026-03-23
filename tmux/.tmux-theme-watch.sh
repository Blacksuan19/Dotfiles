#!/usr/bin/env sh

set -eu

refresh_script="$HOME/.dotfiles/tmux/.tmux-theme-refresh.sh"
watch_pid_option="@ghostty_theme_watch_pid"

clear_watch_pid() {
    tmux set-option -gu "$watch_pid_option" 2>/dev/null || true
}

kill_watcher() {
    pid="$(tmux show-option -gqv "$watch_pid_option" 2>/dev/null || true)"
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
        kill "$pid" 2>/dev/null || true
    fi
    clear_watch_pid
}

spawn_watcher() {
    (
        trap 'kill 0 2>/dev/null || true; clear_watch_pid' EXIT INT TERM
        "$refresh_script" || true

        gsettings monitor org.gnome.desktop.interface 2>/dev/null |
        while IFS= read -r line; do
            case "$line" in
                *color-scheme*|*gtk-theme*)
                    "$refresh_script" || true
                    ;;
            esac
        done &

        gdbus monitor --session --dest org.freedesktop.portal.Desktop --object-path /org/freedesktop/portal/desktop 2>/dev/null |
        while IFS= read -r line; do
            case "$line" in
                *org.freedesktop.portal.Settings.SettingChanged*org.freedesktop.appearance*color-scheme*)
                    "$refresh_script" || true
                    ;;
            esac
        done &

        wait
    ) >/dev/null 2>&1 &

    tmux set-option -gq "$watch_pid_option" "$!"
}

case "${1:-}" in
    start)
        existing_pid="$(tmux show-option -gqv "$watch_pid_option" 2>/dev/null || true)"
        if [ -n "$existing_pid" ] && kill -0 "$existing_pid" 2>/dev/null; then
            exit 0
        fi
        spawn_watcher
        ;;
    restart)
        kill_watcher
        spawn_watcher
        ;;
    refresh)
        exec "$refresh_script"
        ;;
    *)
        exec "$refresh_script"
        ;;
esac
