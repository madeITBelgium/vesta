[Vesta Control Panel Fork (CentOS 7)](http://vestacp.com/)
==================================================

[![Build Status](https://travis-ci.org/madeITBelgium/vesta.svg?branch=master)](https://travis-ci.org/madeITBelgium/vesta)
[![GitHub version](https://badge.fury.io/gh/madeITBelgium%2Fvesta.svg)](https://badge.fury.io/gh/madeITBelgium%2Fvesta)
[![codecov](https://codecov.io/gh/madeITBelgium/vesta/branch/master/graph/badge.svg)](https://codecov.io/gh/madeITBelgium/vesta)

* Vesta is an open source hosting control panel.
* Vesta has a clean and focused interface without the clutter.
* Vesta has the latest of very innovative technologies.

How to install (2 step)
----------------------------
Connect to your server as root via SSH
```bash
ssh root@your.server
```

Download the installation script, and run it:
```bash
curl http://cp.madeit.be/vst-install.sh | bash
```

How to install (3 step)
----------------------------
If the above example does not work, try this 3 step method:
Connect to your server as root via SSH
```bash
ssh root@your.server
```

Download the installation script:
```bash
curl -O http://cp.madeit.be/vst-install.sh
```
Then run it:
```bash
bash vst-install.sh
```

License
----------------------------
Vesta is licensed under  [GPL v3 ](https://github.com/madeITBelgium/vesta/blob/master/LICENSE) license



Extra features
----------------------------
- IPv6 Support
- Plugin support
- Letsencrypt on maildomains
- Letsencrypt on vesta CP


## Upgrade Mysql to 10.4
Since version 0.0.19 we added a script to upgrade your MySQL Server to MariaDB Version 10.4

```
bash /usr/local/vesta/upd/upgrade_mysql.sh
```

## Upgrade PHP to 7.4
Since version 0.0.21 we added a script to upgrade your PHP version to PHP 7.4

```
bash /usr/local/vesta/upd/upgrade_php.sh
```