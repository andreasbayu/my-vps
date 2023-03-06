#!/usr/bin/env bash

path="$(pwd)"
source ${path}/utils/color.sh

echo -e "${Green}
╔════════════════════════════════╗
║                                ║
║             Menu               ║
║                                ║
╚════════════════════════════════╝
╔════════════════════════════════╗
║   1. SSH & OpenVPN             ║
║   2. VMESS                     ║
║   3. VLESS                     ║
╚════════════════════════════════╝
$Reset"
read -p "[*] Select menu > " menu

case $menu in
    1)
        clear
        sshovpn
        ;;
    2)
        clear
        vmess
        ;;
    *)
        echo -e "${On_Red}[!] Error: Invalid input${Reset}"
        read -p "[?] Back to menu ? [y/N] > " answ
        echo $answ

        if [[ "$answ" == "y" ]] || [[ "$answ" == "Y" ]]; then
            clear
            bash $path/menu.sh
        fi
        echo -e "${Cyan}[*] Bye${Reset}"
        ;;
esac