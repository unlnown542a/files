#!/system/bin/sh

##
## Install:
##  mount -o remount,rw /system
##  install -m750 -oroot -groot -p oem-iptables-init.sh /system/bin/oem-iptables-init.sh
##  mount -o remount,ro /system
##  reboot
##

IPTABLES=/system/bin/iptables
IP6TABLES=/system/bin/ip6tables
IPTABLES_OPTS='--wait'
IP6TABLES_OPTS='--wait'

# default policy
$IPTABLES $IPTABLES_OPTS -P INPUT DROP
$IPTABLES $IPTABLES_OPTS -P OUTPUT DROP
$IPTABLES $IPTABLES_OPTS -P FORWARD DROP
$IP6TABLES $IPTABLES_OPTS -P INPUT DROP
$IP6TABLES $IPTABLES_OPTS -P OUTPUT DROP
$IP6TABLES $IPTABLES_OPTS -P FORWARD DROP
$IP6TABLES $IPTABLES_OPTS -I INPUT -j REJECT
$IP6TABLES $IPTABLES_OPTS -I OUTPUT -j REJECT

## FIXME: tor, i2pd, privoxy, sshd is running under root
## SntpClient, DhcpClient

ROOT=0
WIREGUARD=10085
SYSTEM=1000
LINPHONE=10339
MMSSRV=1001

# mms proxy port can be found in sim card APN settings, usually 8080
MMSPROXY=192.168.192.192/32,10.10.30.60/32

# port is 80, since those are http servers
XTRAHOST=13.33.0.0/16,54.192.0.0/16,52.85.0.0/16,13.32.0.0/16,54.230.0.0/16,52.222.0.0/16


# iptables tables creation, cleaning if re-run, etc...
$IPTABLES $IPTABLES_OPTS -D INPUT  -j XX_INPUT
$IPTABLES $IPTABLES_OPTS -D OUTPUT -j XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -D FORWARD -j XX_TETHER_FORWARD
$IPTABLES $IPTABLES_OPTS -N XX_INPUT
$IPTABLES $IPTABLES_OPTS -N XX_OUTPUT 
$IPTABLES $IPTABLES_OPTS -N XX_TETHER_FORWARD
$IPTABLES $IPTABLES_OPTS -F XX_INPUT
$IPTABLES $IPTABLES_OPTS -F XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -F XX_TETHER_FORWARD
$IPTABLES $IPTABLES_OPTS -I INPUT  -j XX_INPUT
$IPTABLES $IPTABLES_OPTS -I OUTPUT -j XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -I FORWARD -j XX_TETHER_FORWARD
$IPTABLES $IPTABLES_OPTS -t nat -D OUTPUT -j XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -t nat -N XX_OUTPUT 
$IPTABLES $IPTABLES_OPTS -t nat -F XX_OUTPUT 
$IPTABLES $IPTABLES_OPTS -t nat -I OUTPUT -j XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -t mangle -D FORWARD -j XX_MANGLE_FORWARD
$IPTABLES $IPTABLES_OPTS -t mangle -N XX_MANGLE_FORWARD 
$IPTABLES $IPTABLES_OPTS -t mangle -F XX_MANGLE_FORWARD 
$IPTABLES $IPTABLES_OPTS -t mangle -I FORWARD -j XX_MANGLE_FORWARD

# INPUT BASE RULES
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -i rmnet_data+ -p tcp --syn -m tcp --dport 8022 -j DROP
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
# OUTPUT BASE RULES
#$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# USB/WIFI TETHER mode
$IPTABLES $IPTABLES_OPTS -A XX_TETHER_FORWARD -i rndis0 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_TETHER_FORWARD -o rndis0 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_TETHER_FORWARD -i wlan0 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_TETHER_FORWARD -o wlan0 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -o wlan0  -p udp -m udp --sport 53 -d 192.168.0.0/16 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -o rndis0 -p udp -m udp --sport 53 -d 192.168.0.0/16 -j ACCEPT

# nat TETHER - RETURN source port reply 53
$IPTABLES $IPTABLES_OPTS -t nat -A XX_OUTPUT -p udp -m udp --sport 53 -j RETURN
$IPTABLES $IPTABLES_OPTS -t nat -A XX_OUTPUT -p udp -m udp --sport 53 -j RETURN

# I2PD and TOR
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -m owner --uid-owner $ROOT -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $ROOT -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT

# WIREGUARD
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -m owner --uid-owner $WIREGUARD -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $WIREGUARD -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT

# SIP: linphone
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -d 127.0.0.1/32 -m owner --uid-owner $LINPHONE -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -p udp          -m owner --uid-owner $LINPHONE -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
$IPTABLES $IPTABLES_OPTS -t nat  -A XX_OUTPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m owner --uid-owner $LINPHONE -m comment --comment "Force Linphone through TransPort" -j REDIRECT --to-ports 9040

# DHCP
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -p udp -m udp --sport 67:68 --dport 67:68 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -p udp -m udp --sport 67:68 --dport 67:68 -j ACCEPT

# NTP(SNTP), MMS, XTRA(GPS)
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $SYSTEM -m conntrack --ctstate NEW,ESTABLISHED -p udp -m udp --dport 123  -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $SYSTEM -m conntrack --ctstate NEW,ESTABLISHED -p tcp -m tcp --dport 80   -d $XTRAHOST -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $MMSSRV -m conntrack --ctstate NEW,ESTABLISHED -p tcp -m tcp --dport 8080 -d $MMSPROXY -j ACCEPT

# REDIRECT to TOR
$IPTABLES $IPTABLES_OPTS -t nat -A XX_OUTPUT -p udp -m udp --dport 53 -j REDIRECT --to-ports 5400

# CLAMP MSS to PMTU
$IPTABLES $IPTABLES_OPTS -t mangle -A XX_MANGLE_FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

## OrWall Init stub
##
# check if orwall iptables already initialized, do nothing
if $IPTABLES $IPTABLES_OPTS -C ow_OUTPUT_LOCK -j DROP 2>/dev/null 
then
  exit 0
else
  #Create
  $IPTABLES $IPTABLES_OPTS -N ow_OUTPUT_LOCK
  $IPTABLES $IPTABLES_OPTS -N ow_INPUT_LOCK
  $IPTABLES $IPTABLES_OPTS -A ow_OUTPUT_LOCK -j DROP
  $IPTABLES $IPTABLES_OPTS -A ow_INPUT_LOCK  -j DROP
fi
## EOF
