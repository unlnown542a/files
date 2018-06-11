# files

* user.js - firefox quantum hardering. Thanks to https://github.com/pyllyukko/user.js !
  * ua-for-ua-switcher.txt - data for Firefox plugin - https://gitlab.com/ntninja/user-agent-switcher

* build:
  * libpurple-lurch-git - Arch PKGBUILD for libpurple-lurch-git, omemo in pidgin
  * pidgin - Arch PKGBUILD pidgin, libpurle, finch with minimal possible dependancies

* pre-built packages:
  * finch-2.13.0-2-x86_64.pkg.tar.xz
  * libpurple-2.13.0-2-x86_64.pkg.tar.xz
  * libpurple-lurch-git-r94.3156e14-1-x86_64.pkg.tar.xz
  * pidgin-2.13.0-2-x86_64.pkg.tar.xz

* android_manual_addon - ROM and data addon files which must be placed manually:
    * some more handy binaries:
        /system/xbin/obfs4proxy
        /system/xbin/tor
        /system/xbin/cryptsetup
        /system/xbin/truecrypt
        /system/xbin/privoxy
        /system/xbin/encfs
        /system/xbin/pdnsd
        /system/xbin/i2pd
    
    * finetuned gps. Well, on my HTC m9 (hima) works awesome:
        /system/etc/gps.conf

    * initial firewall hook, carefully look throu it for your needs:
        /system/bin/oem-iptables-init.sh

    * micro G GSM,UMTS,LTE,WiFi NetworkLocation Center only must be installed as per author's docs, 
      plugins like GSMLocation, WiFi.., DejaVu.. - must be installed as usual
        /system/priv-app/Networklocation/NetworkLocation.apk

    * Encdroid - create encfs encrypted folders, i placed it in /system/ so it can create encrypted folders on ext SD cards
        /system/priv-app/Encdroid/Encdroid.apk

    /data/media/0/_ETC/tor/torrc
    /data/media/0/_ETC/tor/geoip
    /data/media/0/_ETC/tor/DataDir
    /data/media/0/_ETC/tor/geoip6
    /data/media/0/_ETC/init.d/userinit
    /data/media/0/_ETC/privoxy.conf
    /data/media/0/_ETC/i2pd/i2pd.conf
    /data/media/0/_ETC/i2pd/tunnels.conf
    /data/media/0/_ETC/i2pd/enabled

    * Add missing init.d support. Take here https://f-droid.org/packages/x1125io.initdlight.
      Basically it calls "sh /sdcard/_ETC/init.d/userinit" to be more handy
        /data/data/x1125io.initdlight/files/init_hook
