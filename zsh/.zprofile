# automatically run startx when logging in on tty1

# qt themeing
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=

if [ -z "$DISPLAY" ] && [ "$(fgconsole)" -eq 1 ]; then
   startx
fi
