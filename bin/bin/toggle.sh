#!/usr/bin/env bash

NAME=$(basename "$0")
VER="0.4"

usage()
{
    cat <<- EOF

 USAGE:  $NAME [OPTIONS [ADDITIONAL]]

 OPTIONS:

     -h,--help         Display this message

     -v,--version      Display script version

     -p,--polybar      Toggle the configured polybar session, NO additional options

     -c,--compton      Toggle compton or daemon monitoring icon, can use toggle option

     -r,--redshift     Toggle redshift or daemon monitoring icon, can use toggle option

     -f,--caffeine     Toggle caffeine or daemon monitoring icon, can use toggle option

 ADDITIONAL:

     -t,--toggle       Toggle the program off/on, without this flag a monitor process will be started

EOF
}

toggle_polybar()
{
    if [[ $(pidof polybar) ]]; then
        pkill polybar
    else
        al-polybar-session
    fi
}

toggle_compton()
{
    if (( opt == 1 )); then
        if [[ $(pidof compton) ]]; then
            al-compositor --stop
        else
            al-compositor --start
        fi
        exit 0
    fi
    on=""
    off=""
    while true; do
        if [[ $(pidof compton) ]]; then
            echo "$on"
        else
            echo "%{F#888888}$off"
        fi
        sleep 2
    done
}

toggle_redshift()
{
    if (( opt == 1 )); then
        if [[ $(pidof redshift) ]]; then
            pkill redshift
        else
            redshift &
        fi
        exit 0
    fi
    icon=""
    while true; do
        if [[ $(pidof redshift) ]]; then
            temp=$(sed 's/K//g' <<< "$(grep -o '[0-9].*K' <<< "$(redshift -p 2>/dev/null)")")
        fi
        if [[ -z $temp ]]; then
            echo " $icon "                # Greyed out (not running)
        elif [[ $temp -ge 5000 ]]; then
            echo "%{F#8039A0} $icon "     # Blue
        elif [[ $temp -ge 4000 ]]; then
            echo "%{F#F203F0} $icon "     # Yellow
        else
            echo "%{F#FF5B6C} $icon "     # Orange
        fi
        sleep 2
    done
}

toggle_caffeine()
{
    if (( opt == 1 )); then
        if [[ $(pidof caffeine) ]]; then
            killall caffeine
        else
            caffeine &
        fi
        exit 0
    fi
    on=""
    off=""
    while true; do
        [[ $(pidof caffeine) ]] && echo "%{F#0000FF}$on" || echo "%{F#FF0000}$off"
        sleep 2
    done
}

# Catch command line options
case $1 in
    -h|--help) usage ;;
    -v|--version) echo -e "$NAME -- Version $VER" ;;
    -p|--polybar) toggle_polybar ;;
    -c|--compton)
        [[ $2 =~ (-t|--toggle) ]] && opt=1
        toggle_compton
        ;;
    -r|--redshift)
        [[ $2 =~ (-t|--toggle) ]] && opt=1
        toggle_redshift
        ;;
    -f|--caffeine)
        [[ $2 =~ (-t|--toggle) ]] && opt=1
        toggle_caffeine
        ;;
    *) echo -e "Option does not exist: $1" && usage && exit 1
esac

