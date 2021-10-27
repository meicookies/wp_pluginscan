#!/bin/bash
wpplu() {
    count=$(curl -m 6 -s $1 \
        | htmlq --pretty --attribute href link \
        | grep -oP "/plugins/\K.*" | awk -F/ '{print $1}' | sort -u 2>/dev/null)
    if [[ -n $count ]]; then echo "$count" > .temp
        echo -e "$1 \e[92mFound $(cat .temp | wc -l) plugins\e[0m"
        echo "$1 [$count]" | sed -z 's/\n/, /g; s/, $//; s/]/]\n/' >> plugin.txt
    else echo -e "$1 \e[91m[bukan wordpress]\e[0m"; fi
    rm .temp 2>/dev/null
}
pure() {
    url=()
    absolut=$(curl -m 2 -w "%{redirect_url}\n" -s $1 -o /dev/null)
    [[ -n "$absolut" ]] && url+=("$absolut") || url+=("$1")
    wpplu "$url"; unset url
}
[ -z $1 ] && echo "Usage: $0 [list.txt] [thread]" && exit
[[ -z $(cat $1 2>/dev/null) ]] && echo "file gada" && exit
export -f pure wpplu
[ -z $2 ] && echo "Yang bener" && exit
parallel -j $2 pure :::: $1
# coded by ./meicookies
