Domain Expiration Check Shell Script
====================================
A simple shell script to display or notify the user via email about domain status and expiry date. 

Installation:
-------------
Use the curl or wget command to grab script as follows:

```
$ wget https://raw.githubusercontent.com/click0/domain-check-2/master/domain-check-2.sh
## [ sample domain list for testing purpose ] ##
$ wget https://raw.githubusercontent.com/click0/domain-check-2/master/domain-list.txt 
## [ install it in /usr/local/bin dir ] ##
$ sudo cp -vf domain-check-2.sh /usr/local/bin/domain-check-2
$ sudo chmod +x /usr/local/bin/domain-check-2
```

Usage:
------
Run it as follows:
```
$ domain-check-2 -d google.com
$ domain-check-2 -f domain-list.txt
$ domain-check-2 -f domain-list.txt -a -e admin@my-cool-domain.com 
```
Sample outputs:
```
Domain                              Registrar                                      Status   Expires     Days Left
----------------------------------- ---------------------------------------------- -------- ----------- ---------
nixcraft.com                        NameCheap, Inc.                                Valid    10-may-2024   756
google.org                          MarkMonitor Inc.                               Valid    20-oct-2022   188
google.net                          MarkMonitor Inc.                               Valid    15-mar-2023   334
google.info                         MarkMonitor Inc.                               Valid    31-jul-2022   107
cyberciti.biz                       NameCheap, Inc.                                Valid    30-jun-2025   1172
google.in                           MarkMonitor Inc.                               Valid    14-feb-2023   305
google.co.in                        MarkMonitor Inc.                               Valid    23-jun-2022   69
google.us                           MarkMonitor, Inc.                              Valid    18-apr-2023   368
google.uk                           Markmonitor Inc.                               Valid    11-Jun-2022   57
google.co.uk                        Markmonitor Inc.                               Valid    14-Feb-2023   305
google.jp                           Google LLC                                     Valid    31-may-2022   46
google.cz                           REG-MARKMONITOR                                Valid    22-jul-2022   98
google.pl                           Markmonitor,Inc.                               Valid    18-sep-2022   156
google.co                           MarkMonitor, Inc.                              Valid    24-feb-2023   315
google.ru                           RU-CENTER-RU                                   Valid    04-mar-2023   323
google.blog                         MarkMonitor, Inc                               Valid    19-aug-2022   126
linux.cafe                          Porkbun LLC                                    Valid    14-nov-2022   213
google.co                           MarkMonitor, Inc.                              Valid    24-feb-2023   315
dotmobi.mobi                        CSC Corporate Domains, Inc.                    Expiring 11-may-2022   26
google.me                           MarkMonitor Inc.                               Valid    13-jun-2022   59
google.us                           MarkMonitor, Inc.                              Valid    18-apr-2023   368
google.su                           RUCENTER-SU                                    Valid    15-oct-2022   183
youtube.tv                          MarkMonitor Inc.                               Valid    14-aug-2022   121
abc.xyz                             MarkMonitor, Inc (TLDs)                        Valid    20-mar-2025   1070
google.se                           MarkMonitor Inc                                Valid    20-oct-2022   188
google.dk                           DK Hostmaster A/S                              Valid    31-mar-2023   350
```
[Setup Unix/Linux cron job](https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/)  as follows to get email notification to send expiration notices:

```
@daily /path/to/domain-check-2.sh -f /path/to/your-domains.txt -a -e you@example.com
```
Getting help
------------
```
$ domain-check-2.sh -h
Usage: domain-check-2.sh [ -e email ] [ -x expir_days ] [ -q ] [ -a ] [ -h ] [ -v ] [ -V ]
         [ -s shois_server ] {[ -d domain_name ]} || { -f domainfile}

  -a               : Send a warning message through email
  -d domain        : Domain to analyze (interactive mode)
  -e email address : Email address to send expiration notices
  -f domain file   : File with a list of domains
  -h               : Print this screen
  -s whois server  : Whois sever to query for information
  -q               : Don't print anything on the console
  -x days          : Domain expiration interval (eg. if domain_date < days)
  -v               : Show debug information when running script
  -V               : Print version of the script
```

Authors:
--------
* Origianl Author: Matty < matty91 at gmail dot com > https://github.com/Matty9191
* Forked by nixCraft https://www.cyberciti.biz/tips/domain-check-script.html 
* Forked and maintained by Vladislav V. Prodan <github.com/click0>

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/click0/domain-check-2/issues). 

## Show your support

Give a ⭐ if this project helped you!

<a href="https://www.buymeacoffee.com/click0" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-orange.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
