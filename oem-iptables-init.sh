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

# default policy
$IPTABLES $IPTABLES_OPTS -P INPUT DROP
$IPTABLES $IPTABLES_OPTS -P OUTPUT DROP
$IPTABLES $IPTABLES_OPTS -P FORWARD DROP
$IP6TABLES $IPTABLES_OPTS -P INPUT DROP
$IP6TABLES $IPTABLES_OPTS -P OUTPUT DROP
$IP6TABLES $IPTABLES_OPTS -P FORWARD DROP
$IP6TABLES $IPTABLES_OPTS -I INPUT -j REJECT
$IP6TABLES $IPTABLES_OPTS -I OUTPUT -j REJECT
$IP6TABLES $IPTABLES_OPTS -I FORWARD -j REJECT

## FIXME: tor, i2pd, privoxy, sshd is running under root
## SntpClient, DhcpClient
##
ROOT=0
SYS_UID=1000
MMS_UID=1001
MMS_HOSTS=192.168.192.192/32,10.10.30.60/32

# iptables tables creation, cleaning if re-run, etc...
$IPTABLES $IPTABLES_OPTS -D INPUT  -j XX_INPUT
$IPTABLES $IPTABLES_OPTS -D OUTPUT -j XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -N XX_INPUT
$IPTABLES $IPTABLES_OPTS -N XX_OUTPUT 
$IPTABLES $IPTABLES_OPTS -F XX_INPUT
$IPTABLES $IPTABLES_OPTS -F XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -I INPUT  -j XX_INPUT
$IPTABLES $IPTABLES_OPTS -I OUTPUT -j XX_OUTPUT
$IPTABLES $IPTABLES_OPTS -t mangle -D FORWARD -j XX_mangle_FORWARD
$IPTABLES $IPTABLES_OPTS -t mangle -N XX_mangle_FORWARD 
$IPTABLES $IPTABLES_OPTS -t mangle -F XX_mangle_FORWARD 
$IPTABLES $IPTABLES_OPTS -t mangle -I FORWARD -j XX_mangle_FORWARD
$IPTABLES $IPTABLES_OPTS -t nat -D OUTPUT -j XX_nat_OUTPUT
$IPTABLES $IPTABLES_OPTS -t nat -N XX_nat_OUTPUT 
$IPTABLES $IPTABLES_OPTS -t nat -F XX_nat_OUTPUT 
$IPTABLES $IPTABLES_OPTS -t nat -I OUTPUT -j XX_nat_OUTPUT
$IPTABLES $IPTABLES_OPTS -D FORWARD -j XX_tether_FORWARD
$IPTABLES $IPTABLES_OPTS -N XX_tether_FORWARD
$IPTABLES $IPTABLES_OPTS -F XX_tether_FORWARD
$IPTABLES $IPTABLES_OPTS -I FORWARD -j XX_tether_FORWARD
# Now rules..
# I/O base rules
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -i lo -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -o lo -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED     -j ACCEPT
# FORBID privoxy and ssh port from GSM network
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -i rmnet_data0 -p tcp --syn -m tcp --dport 8118 -j DROP
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -i rmnet_data0 -p tcp --syn -m tcp --dport 8228 -j DROP
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -i rmnet_data0 -p tcp --syn -m tcp --dport 8022 -j DROP
# PERMIT new DHCP
$IPTABLES $IPTABLES_OPTS -A XX_INPUT  -p udp -m udp --sport 67 --dport 68 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -p udp -m udp --sport 68 --dport 67 -j ACCEPT
# FIXME: i2pd, tor, privoxy, sshd - all root procs can send out. Not yet found the way to su to given user
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $ROOT    -m conntrack --ctstate NEW,RELATED,ESTABLISHED -j ACCEPT
# SNTP sync
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $SYS_UID -m conntrack --ctstate NEW,RELATED,ESTABLISHED -p udp -m udp --dport 123  -j ACCEPT
# FETCH MMS
$IPTABLES $IPTABLES_OPTS -A XX_OUTPUT -m owner --uid-owner $MMS_UID -m conntrack --ctstate NEW,RELATED,ESTABLISHED -p tcp -m tcp --dport 8080 -d $MMS_HOSTS -j ACCEPT
# tethering USB/WIFI mode
$IPTABLES $IPTABLES_OPTS -A XX_tether_FORWARD -i rndis0 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_tether_FORWARD -o rndis0 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_tether_FORWARD -i wlan0 -j ACCEPT
$IPTABLES $IPTABLES_OPTS -A XX_tether_FORWARD -o wlan0 -j ACCEPT
# REDIRECT all DNS to TOR
$IPTABLES $IPTABLES_OPTS -t nat -A XX_nat_OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5400
# CLAMP MSS to PMTU
$IPTABLES $IPTABLES_OPTS -t mangle -A XX_mangle_FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
$IPTABLES $IPTABLES_OPTS -t mangle -A XX_mangle_FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

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
