#!/bin/bash
#silly watchtree.sh demo

invs(){
    case "$2" in
        on|'') picom-trans -w "$1" -o 0;;
        off) picom-trans -w "$1" -d;;
    esac
}
invsall(){
    local w
    for w in $(bspc query -N -n .window.local.!focused.!floating); do
        invs "$w"&
    done
}
trap 'picom-trans -r' TERM INT
invsall
while read -r -a a; do
    case ${a[0]} in
        state)
            fn="$(bspc query -N -n)"
            case ${a[2]} in
                floating)
                    if [[ "${a[3]}" == "on" ]]; then
                        invs "${a[1]}" off
                        invs "$(bspc query -N -n last.local.window.!floating)" off
                    else
                        [[ "${a[1]}" == "$fn" ]] || invs "${a[1]}"
                    fi
                    ;;
                tiled|pseudo_tiled)
                    invsall
                    #[[ "${a[1]}" == "$fn" ]] || invs "${a[1]}"
                    ;;
            esac
            ;;
        focus)
            if bspc query -N -n "${a[1]}.window.!floating" &>/dev/null; then
                invsall
                invs "${a[1]}" off
            fi
            ;;
    esac
done < <(./bsps_watchtree.sh @WORK:/ state focus)
