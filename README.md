# files

* firefox-quantum-tor-browser-how-to (works for Linux and Android, i think Windows too)
  * user.js - firefox quantum hardering. Thanks to https://github.com/pyllyukko/user.js !
  * ua-for-ua-switcher.txt - data for Firefox plugin - https://gitlab.com/ntninja/user-agent-switcher
  * Requied addons:
    * CanvasBlocker -> block everything
    * noScript
    * https-everywhere
    * user-agent-switcher
    * (nice to have) lumerias-clear-storage
  * go and check your ident bits at https://panopticlick.eff.org/

* Flashable zips:

  * this does not need to be modified:
    * system-oem-iptables-network-location-gps.zip
    * data-local-tools.zip

  * unpack this and put your configs for i2pd(add your keys, certs, family) 
    and torrc(add Bridges...) and your ssh public into ssh-authorized.zip:
    * my-tor-i2pd-data.zip
    * ssh-authorized.zip

* For init.d(userinit.d) support use https://f-droid.org/en/packages/de.lisas.alex.runuserinit/
    - this is the best

* Crypto containers opensource https://f-droid.org/en/packages/com.sovworks.edslite/

* lacells.db.bz2 for https://f-droid.org/en/packages/org.fitchfamily.android.gsmlocation/


* build:
  * libpurple-lurch-git - Arch PKGBUILD for libpurple-lurch-git, omemo in pidgin
  * pidgin - Arch PKGBUILD pidgin, libpurle, finch with minimal possible dependancies

* pre-built packages:
  * libpurple-2.13.0-5-x86_64.pkg.tar.xz
  * libpurple-lurch-git-r94.3156e14-1-x86_64.pkg.tar.xz
  * pidgin-2.13.0-5-x86_64.pkg.tar.xz

