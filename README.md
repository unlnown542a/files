# files

* Recommended https://f-droid.org/en/packages/com.sovworks.edslite/

* Added fresh (2018-08-19) gsmlocation/lacells.db.bz2 for https://f-droid.org/en/packages/org.fitchfamily.android.gsmlocation/

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

* Add missing init.d support. Take here https://f-droid.org/packages/x1125io.initdlight.
  Put symlinks to scripts into /data/data/x1125io.initdlight/files/ ...

* android_manual_addon - ROM and data addon files which must be placed manually:
    * some more handy binaries:
      * /system/xbin/obfs4proxy
      * /system/xbin/tor
      * /system/xbin/cryptsetup
      * /system/xbin/truecrypt
      * /system/xbin/privoxy
      * /system/xbin/encfs
      * /system/xbin/pdnsd
      * /system/xbin/i2pd
    
    * finetuned gps. Well, on my HTC m9 (hima) works awesome:
      * /system/etc/gps.conf

    * initial firewall hook, carefully look throu it for your needs:
      * /system/bin/oem-iptables-init.sh

    * micro G GSM,UMTS,LTE,WiFi NetworkLocation Center only must be installed as per author's docs, 
      plugins like GSMLocation, WiFi.., DejaVu.. - must be installed as usual
      * /system/priv-app/Networklocation/NetworkLocation.apk

    * "User-Space" configs moved to "data" space /data/etc
      ./system/xbin/obfs4proxy
      ./system/xbin/tor
      ./system/xbin/cryptsetup
      ./system/xbin/truecrypt
      ./system/xbin/privoxy
      ./system/xbin/encfs
      ./system/xbin/pdnsd
      ./system/xbin/i2pd
      ./system/bin/oem-iptables-init.sh
      ./system/priv-app
      ./system/priv-app/Networklocation
      ./system/priv-app/Networklocation/NetworkLocation.apk
      ./system/etc/gps.conf
      ./data/tor/data
      ./data/data/x1125io.initdlight/files/01setting
      ./data/data/x1125io.initdlight/files/11privoxy
      ./data/data/x1125io.initdlight/files/12sshd
      ./data/data/x1125io.initdlight/files/00sysctl
      ./data/data/x1125io.initdlight/files/10tor
      ./data/bin/01setting
      ./data/bin/11privoxy
      ./data/bin/tdisablenetwork
      ./data/bin/20i2pd
      ./data/bin/tnewnym
      ./data/bin/XTRA_STATUS
      ./data/bin/tenablenetwork
      ./data/bin/12sshd
      ./data/bin/tflipflop
      ./data/bin/00sysctl
      ./data/bin/10tor
      ./data/bin/XTRA_REFRESH
      ./data/i2pd/netDb
      ./data/i2pd/addressbook
      ./data/i2pd/tags
      ./data/i2pd/certificates
      ./data/i2pd/certificates/router
      ./data/i2pd/certificates/router/orignal_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed
      ./data/i2pd/certificates/reseed/echelon_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/bugme_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/zmx_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/lazygravy_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/r4sas-reseed_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/meeh_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/creativecowpat_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/backup_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/atomike_at_mail.i2p.crt
      ./data/i2pd/certificates/reseed/igor_at_novg.net.crt
      ./data/i2pd/certificates/family
      ./data/i2pd/certificates/family/gostcoin.crt
      ./data/i2pd/certificates/family/mca2-i2p.crt
      ./data/i2pd/certificates/family/aloneinthedark.crt
      ./data/i2pd/certificates/family/i2pd-dev.crt
      ./data/i2pd/certificates/family/i2p-dev.crt
      ./data/i2pd/certificates/family/volatile.crt
      ./data/i2pd/destinations
      ./data/i2pd/peerProfiles
      ./data/i2pd/family
      ./data/etc/torrc
      ./data/etc/sysctl.conf
      ./data/etc/geoip
      ./data/etc/geoip6
      ./data/etc/privoxy.conf
      ./data/etc/i2pd
      ./data/etc/i2pd/i2pd.conf
      ./data/etc/i2pd/tunnels.conf




