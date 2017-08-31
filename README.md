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
google.com                          MarkMonitor Inc.                               Valid    14-sep-2020   1110 
google.org                          MarkMonitor Inc.                               Valid    20-oct-2017   50   
google.net                          MarkMonitor Inc.                               Valid    15-mar-2018   196  
google.info                         MarkMonitor Inc.                               Valid    31-jul-2018   334  
cyberciti.biz                       GODADDY.COM, INC.                              Valid    30-Jun-2019   668  
google.in                           MarkMonitor Inc. (R84-AFIN)                    Valid    14-Feb-2018   167  
google.co.in                        MarkMonitor Inc. (R84-AFIN)                    Valid    23-Jun-2018   296  
google.us                           MARKMONITOR, INC.                              Valid    18-apr-2018   230  
google.uk                                  Markmonito                              Valid    11-Jun-2018   284  
google.co.uk                               Markmonito                              Valid    14-Feb-2018   167  
google.jp                           Google                                         Valid    31-may-2018   273  
google.cz                           REG-MARKMONITOR                                Valid    22-07-2018   113  
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
