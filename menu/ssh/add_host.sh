#!/bin/bash
echo -e "${GREEN}
╔════════════════════════════════╗
║            Add SSH             ║
╚════════════════════════════════╝
$Reset"
read -rp "[>] Domain/Host   : " -e domain
echo "IP=$domain" >>/var/lib/crot/ipvps.conf
rm -rf /etc/xray/domain
echo $domain > /etc/xray/domain
certv2ray