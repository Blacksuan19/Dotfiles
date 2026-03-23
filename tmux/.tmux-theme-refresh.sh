#!/usr/bin/env sh

set -eu

choose_text_color() {
    hex="${1#\#}"
    if [ "${#hex}" -ne 6 ]; then
        printf '%s\n' "#000000"
        return
    fi

    r="$(printf '%d' "0x${hex%????}")"
    g_pair="${hex#??}"
    g_pair="${g_pair%??}"
    g="$(printf '%d' "0x${g_pair}")"
    b="$(printf '%d' "0x${hex#????}")"
    brightness=$(( (299 * r + 587 * g + 114 * b) / 1000 ))

    if [ "$brightness" -lt 140 ]; then
        printf '%s\n' "#eff1f5"
    else
        printf '%s\n' "#11111b"
    fi
}

ghostty_config="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config.ghostty"

read_config_value() {
    file="$1"
    key="$2"
    awk -F' = ' -v key="$key" '$1 == key { print $2; exit }' "$file"
}

read_kdeglobals_value() {
    section="$1"
    key="$2"
    file="${XDG_CONFIG_HOME:-$HOME/.config}/kdeglobals"

    [ -f "$file" ] || return 1

    awk -F= -v section="$section" -v key="$key" '
        $0 == "[" section "]" { in_section = 1; next }
        /^\[/ { in_section = 0 }
        in_section && $1 == key { print $2; exit }
    ' "$file"
}

mode_from_value() {
    value="$1"
    case "$value" in
        *dark*)
            printf '%s\n' dark
            return
            ;;
        *light*)
            printf '%s\n' light
            return
            ;;
    esac
    return 1
}

current_mode() {
    mode_from_value "$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || true)" && return

    mode_from_value "$(read_kdeglobals_value "General" "ColorScheme" || true)" && return

    portal_value="$(gdbus call --session \
        --dest org.freedesktop.portal.Desktop \
        --object-path /org/freedesktop/portal/desktop \
        --method org.freedesktop.portal.Settings.Read \
        org.freedesktop.appearance color-scheme 2>/dev/null || true)"

    case "$portal_value" in
        *"uint32 1"*)
            printf '%s\n' dark
            return
            ;;
        *"uint32 2"*)
            printf '%s\n' light
            return
            ;;
    esac

    printf '%s\n' light
}

configured_theme_name() {
    mode="$1"
    [ -f "$ghostty_config" ] || return 1

    theme_line="$(read_config_value "$ghostty_config" "theme")"
    [ -n "$theme_line" ] || return 1

    printf '%s\n' "$theme_line" | awk -F',' -v mode="$mode" '
        {
            for (i = 1; i <= NF; i++) {
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i)
                if ($i ~ ("^" mode ":")) {
                    sub("^" mode ":", "", $i)
                    print $i
                    exit
                }
            }
        }
    '
}

theme_file_path() {
    theme_name="$1"
    for path in \
        "${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/themes/$theme_name" \
        "$HOME/.local/share/ghostty/themes/$theme_name" \
        "/usr/share/ghostty/themes/$theme_name"
    do
        if [ -f "$path" ]; then
            printf '%s\n' "$path"
            return
        fi
    done

    return 1
}

read_theme_value() {
    theme_file="$1"
    key="$2"
    read_config_value "$theme_file" "$key"
}

read_theme_palette() {
    theme_file="$1"
    slot="$2"
    awk -F'[= ]+' -v slot="$slot" '$1 == "palette" && $2 == slot { print $3; exit }' "$theme_file"
}

if ! command -v tmux >/dev/null 2>&1; then
    exit 0
fi

mode="$(current_mode)"
theme_name="$(configured_theme_name "$mode" || true)"
theme_file="$(theme_file_path "$theme_name" || true)"

if [ -z "$theme_file" ]; then
    exit 0
fi

bg="$(read_theme_value "$theme_file" "background" || true)"
fg="$(read_theme_value "$theme_file" "foreground" || true)"
muted="$(read_theme_palette "$theme_file" "8" || true)"
accent="$(read_theme_palette "$theme_file" "12" || true)"

if [ -z "$bg" ] || [ -z "$fg" ] || [ -z "$muted" ] || [ -z "$accent" ]; then
    exit 0
fi

muted_fg="$(choose_text_color "$muted")"
accent_fg="$(choose_text_color "$accent")"
current_sig="$bg|$fg|$muted|$muted_fg|$accent|$accent_fg"
last_sig="$(tmux show-option -gqv "@ghostty_theme_signature" 2>/dev/null || true)"

if [ "$current_sig" = "$last_sig" ]; then
    exit 0
fi

tmux set-option -gq "@ghostty_theme_signature" "$current_sig"
tmux set-option -gq status-style "fg=$fg,bg=$bg"
tmux set-option -gq message-style "fg=$accent_fg,bg=$accent"
tmux set-option -gq mode-style "fg=$accent_fg,bg=$accent"
tmux set-option -gq pane-border-style "fg=$muted"
tmux set-option -gq pane-active-border-style "fg=$accent"
tmux setw -gq window-status-format "#[bg=$bg,fg=$muted,noreverse]#[bg=$muted,fg=$muted_fg,noreverse] #W #[bg=$bg,fg=$muted,noreverse]"
tmux setw -gq window-status-current-format "#[bg=$bg,fg=$accent,noreverse]#[bg=$accent,fg=$accent_fg,bold,noreverse] #W #[bg=$bg,fg=$accent,noreverse]"
tmux refresh-client -S 2>/dev/null || true
