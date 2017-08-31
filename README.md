Domain Expiration Check Shell Script
====================================
A simple shell script to display or notify user via an email about domain status and expiery date.

Installation:
-------------
Use the curl or wget command to grab script as follows:

```
wget https://raw.githubusercontent.com/nixcraft/domain-check-2/master/domain-check-2.sh

sudo cp domain-check-2.sh /usr/local/bin/

sudo chmod +x domain-check-2.sh
```

Usage:
------
Run it as follows:
```
domain-check-2 -d google.com
domain-check-2 -d cyberciti.biz
/domain-check-2 -f domain-list.txt 
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

Author:
------

Origianl Author: Matty < matty91 at gmail dot com > https://github.com/Matty9191

Forked and maitained by nixCraft https://www.cyberciti.biz/tips/domain-check-script.html 

I added support and fixed for various C/TLDS.
