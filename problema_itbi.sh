F=$1
 
if [ ! -f "$F" ]; then
    echo "Fisier lipsa: $F"
    exit 1
fi
 
check_ip() {
    n="$2"
    ipf="$3"
    r=$(nslookup "$n" 2>/dev/null | awk '/^Address:/{x=$2} END{if(x!="")print x}')
    if [ -z "$r" ]; then
        return 2
    fi
    if [ "$r" != "$ipf" ]; then
        echo "Bogus IP for $n in \$HOME/etc/hosts !"
        return 1
    fi
    return 0
}
 
while IFS= read -r L; do
    x="${L%%#*}"
    set -- $x
    if [ $# -lt 2 ]; then
        continue
    fi
    a="$1"
    b="$2"
    check_ip "$b" "$a"
done < "$F"
