#!/bin/bash

source ${path}/utils/color.sh

domain=$(cat /etc/xray/domain)
cdn_domain=$(cat /root/awscdndomain)
sl_key=$(cat /etc/slowdns/server.pub)
sl_domain=$(cat /root/nsdomain)

echo -e "${GREEN}
╔════════════════════════════════╗
║            Add SSH             ║
╚════════════════════════════════╝
$Reset"

read -p "[>] Username   > " username
read -p "[>] Password   > " password
read -p "[>] Epx        > " exp

ip_add=$(wget -qO- ipinfo.io/ip)
ws_tls="$(cat ~/log-install.txt | grep -w "Websocket TLS" | cut -d: -f2|sed 's/ //g')"
ws="$(cat ~/log-install.txt | grep -w "Websocket None TLS" | cut -d: -f2|sed 's/ //g')"


ssl="$(cat ~/log-install.txt | grep -w "Stunnel5" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn_tcp="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn_udp="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"

clear

systemctl stop client-sldns
systemctl stop server-sldns
pkill sldns-server
pkill sldns-client
systemctl enable client-sldns
systemctl enable server-sldns
systemctl start client-sldns
systemctl start server-sldns
systemctl restart client-sldns
systemctl restart server-sldns
systemctl restart ws-tls
systemctl restart ws-nontls
systemctl restart ssh-ohp
systemctl restart dropbear-ohp
systemctl restart openvpn-ohp

useradd -e `date -d "$exp days" +"%Y-%m-%d"` -s /bin/false -M $username
exp_date="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"

echo -e "$password\n$password\n"|passwd $username &> /dev/null

now=`date -d "$masaaktif days" +"%Y-%m-%d"`

echo -e "
══════════════════════════
        SSH Accout
══════════════════════════
Username    : $username
Password    : $password
Created     : $now
Exp         : $exp
══════════════════════════
        SSH
══════════════════════════
IP Add      : $ip_add
Domain SSH  : $domain
Domain CFL  : $domain
Domain CF   : $cdn_domain
══════════════════════════
        SlowDNS
══════════════════════════
Name Server : $sl_domain
DNS Pub key : $sl_key
Domain SDNS : $sl_domain
══════════════════════════
        Ports
══════════════════════════
SlowDNS: 443,22,109,143
OpenSSH: 22
Dropbear: 443, 109, 143
SSL/TLS: 443
SSH Websocket SSL/TLS: 443
SSH Websocket HTTP: 8880
BadVPN UDPGW: 7100,7200,7300
Proxy CloudFront: [OFF]
Proxy Squid: [OFF]
OHP SSH: 8181
OHP Dropbear: 8282
OHP OpenVPN: 8383
OVPN Websocket: 2086
OVPN Port TCP: $ovpn_tcp
OVPN Port UDP: $ovpn_udp
OVPN Port SSL: 990
OVPN TCP: http://$ip_add:89/tcp.ovpn
OVPN UDP: http://$ip_add:89/udp.ovpn
OVPN SSL: http://$ip_add:89/ssl.ovpn
══════════════════════════
"