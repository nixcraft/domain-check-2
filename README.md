Domain Expiration Check Shell Script
====================================
A simple shell script to display or notify the user via email about domain status and expiry date. 

Installation:
-------------
Use the curl or wget command to grab script as follows:

```
$ wget https://raw.githubusercontent.com/nixcraft/domain-check-2/master/domain-check-2.sh
## [ sample domain list for testing purpose ] ##
$ wget https://raw.githubusercontent.com/nixcraft/domain-check-2/master/domain-list.txt 
## [ install it in /usr/local/bin dir ] ##
$ sudo cp -vf domain-check-2.sh /usr/local/bin/
$ sudo chmod +x /usr/local/bin/domain-check-2.sh
```

Usage:
------
Run it as follows:
```
$ domain-check-2 -d google.com
$ domain-check-2 -d cyberciti.biz
$ domain-check-2 -f domain-list.txt 
```
Sample outputs:
```
Domain                              Registrar                                      Status   Expires     Days Left
----------------------------------- ---------------------------------------------- -------- ----------- ---------
nixcraft.com                        GoDaddy.com, LLC                               Valid    10-may-2023   2022 
google.org                          MarkMonitor Inc.                               Valid    20-oct-2018   359  
google.net                          MarkMonitor Inc.                               Valid    15-mar-2018   140  
google.info                         MarkMonitor Inc.                               Valid    31-jul-2018   278  
cyberciti.biz                       GoDaddy.com, Inc.                              Valid    30-jun-2024   2439 
google.in                           MarkMonitor Inc. (R84-AFIN)                    Valid    14-Feb-2018   111  
google.co.in                        MarkMonitor Inc. (R84-AFIN)                    Valid    23-Jun-2018   240  
google.us                           MarkMonitor, Inc.                              Valid    18-apr-2018   174  
google.uk                           Markmonitor Inc.                               Valid    11-Jun-2018   228  
google.co.uk                        Markmonitor Inc.                               Valid    14-Feb-2018   111  
google.jp                           Google                                         Valid    31-may-2018   217  

google.cz                           REG-MARKMONITOR                                Valid    22-jul-2018   269  
google.pl                           Markmonitor, Inc.                              Valid    18-sep-2018   327  
google.co                           MARKMONITOR, INC.                              Valid    24-Feb-2018   121  
google.ru                           RU-CENTER-RU                                   Valid    04-mar-2018   129  
google.blog                         MarkMonitor Inc                                Valid    19-aug-2018   297  
linux.cafe                          OVH SAS                                        Valid    14-nov-2018   384  
google.md                           Google Inc.                                    Valid    02-may-2018   188  
google.co                           MARKMONITOR, INC.                              Valid    24-Feb-2018   121  
dotmobi.mobi                        CSC Corporate Dom                              Valid    11-may-2018   197  
google.me                           MarkMonitor Inc.                               Valid    13-jun-2018   230  
google.us                           MarkMonitor, Inc.                              Valid    18-apr-2018   174  
google.su                           RUCENTER-SU                                    Valid    15-oct-2018   354  
youtube.tv                          MARKMONITOR INC.                               Valid    14-aug-2018   292  
abc.xyz                             MarkMonitor, Inc (TLDs)                        Valid    20-mar-2025   2702 
google.se                           MarkMonitor Inc                                Valid    20-oct-2018   359  
google.dk                           DK Hostmaster A/S                              Valid    31-mar-2018   156
```
[Setup Unix/Linux cron job](https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/)  as follows to get email notification to send expiration notices:

```
@daily /path/to/domain-check-2.sh -f /path/to/your-domains.txt -e you@example.com
```
Getting help
------------
```
$ domain-check-2.sh -h
Usage: domain-check-2.sh [ -e email ] [ -x expir_days ] [ -q ] [ -a ] [ -h ]
          {[ -d domain_namee ]} || { -f domainfile}

  -a               : Send a warning message through email 
  -d domain        : Domain to analyze (interactive mode)
  -e email address : Email address to send expiration notices
  -f domain file   : File with a list of domains
  -h               : Print this screen
  -s whois server  : Whois sever to query for information
  -q               : Don't print anything on the console
  -x days          : Domain expiration interval (eg. if domain_date < days)
```

Authors:
--------
* Origianl Author: Matty < matty91 at gmail dot com > https://github.com/Matty9191
* Forked and maitained by nixCraft https://www.cyberciti.biz/tips/domain-check-script.html 
* I added support and fixed for various C/TLDS.
