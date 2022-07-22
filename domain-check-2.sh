#!/usr/bin/env bash

#
# Program: Domain Expiration Check <domain-check>
#
# Author: Matty < matty91 at gmail dot com >
#
# Current Version: 2.58
# Last Updated: 21-Jul-2022
#
# Revision History:
#
#  Version 2.58
#   Fixed support for .com.ar/.ar domains -- Axel Vasquez <github.com/axelvf>
#
#  Version 2.57
#   Fixed partial support for .md domain -- Vladislav V. Prodan <github.com/click0>
#   Fixed typos.
#
#  Version 2.56
#   Added data output in CSV format -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.55
#   Fixed support for .md/.id/.kz/.uk domains -- Vladislav V. Prodan <github.com/click0>
#   Fixed typos.
#
#  Version 2.54
#   Fixed checking on the existence of binary files of the necessary programs for the script to work.
#
#  Version 2.53
#   Added support for .kr/.hk/.pt/.sg domains -- @copenhaus
#
#  Version 2.52
#   Added work with specific whois servers.
#   Fixed display of the registrar name in the .uk domain zone.
#   Partially added .gg domain zone, but it does not display the year.
#   Fixed typos.
#
#  Version 2.51
#   Added support for .rs/.am/.xin/ domains -- Vladislav V. Prodan <github.com/click0>
#   Fixed typos.
#
#  Version 2.50
#   Added support for .tg/.co.il/.net.il/.org.il domains -- Vladislav V. Prodan <github.com/click0>
#   Added an additional function to change to the desired date format.
#   Fixed display of the registrar in the .cn/.edu domains.
#
#  Version 2.49
#   Added support for .com.br domain -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.48
#   Added support for .team/.app/.host/.website domains -- Vladislav V. Prodan <github.com/click0>
#   Fixed length of registrar name for .edu domain
#   Merged some checks
#
#  Version 2.47
#   Added support for .do domain -- rk00t <github.com/rk00t>
#
#  Version 2.46
#   Spaces, tabs and blank lines in the domain list file are now ignored -- Vladislav V. Prodan <github.com/click0>
#   Commenting on domains with the # symbol also began to work -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.45
#   Added support for .game domain -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.44
#   Fixed status when expiration date is wrongly detected (sometimes can be described as not defined) -- https://github.com/hawkeye116477
#   Added support for .today domain -- https://github.com/hawkeye116477
#
#  Version 2.43
#   Added support for .id domain -- Menthol Date <github.com/menthoolll>
#
#  Version 2.42
#   Fixed support for .jp domain -- Tozapid <github.com/Tozapid>
#   Added support for .xxx domain -- Tozapid <github.com/Tozapid>
#
#  Version 2.41
#   Added support for .stream domain -- https://github.com/hawkeye116477
#   Fixed condition with whois -- https://github.com/hawkeye116477
#
#  Version 2.40
#   Partial syntax fixes in the script -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.39
#   Added support for .club domain -- https://github.com/hawkeye116477
#
#  Version 2.38
#   Added support for .sk domain -- https://github.com/hawkeye116477
#   Fixed displaying of some long registrars -- https://github.com/hawkeye116477
#   Fixed support for .jp domain -- https://github.com/hawkeye116477
#
#  Version 2.37
#   Added support for .live domain -- https://github.com/hawkeye116477
#
#  Version 2.36
#   Added support for .museum domain -- Bryan Clay <github.com/watermark>
#
#  Version 2.35
#   Added support for .fun domain -- https://github.com/hawkeye116477
#
#  Version 2.34
#   Added support for .укр domain -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.33
#   Added support for .co.pl domain -- https://github.com/hawkeye116477
#   Fixed version variable -- https://github.com/hawkeye116477
#
#  Version 2.32
#   Fixed support for .ca domain -- https://github.com/hawkeye116477
#   Added support for .space domain -- https://github.com/hawkeye116477
#
#  Version 2.31
#   Added support for .expert/.express domains -- https://github.com/hawkeye116477
#
#  Version 2.30
#   Added option to display the version of the script -- Vladislav V. Prodan <github.com/click0>
#   Added option to show debug information when running script -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.29
#   Partial syntax fixes in the script -- Vladislav V. Prodan <github.com/click0>
#   Partially removed extra disk read operations --Vladislav V. Prodan <github.com/click0>
#
#  Version 2.28
#   Added support for .systems domain and fixed status when expiration date isn't detected -- https://github.com/hawkeye116477
#   Fixed status when expiration date isn't detected -- https://github.com/hawkeye116477
#
#  Version 2.27
#   Added support for .is/.cloud domains -- https://github.com/hawkeye116477
#
#  Version 2.26
#   Added support for .icu domain -- https://github.com/hawkeye116477
#
#  Version 2.25
#   Added support for .bid/.ng/.site domains -- https://github.com/hawkeye116477
#
#  Version 2.24
#   Added support for .app/.top domains -- Vladislav V. Prodan <github.com/click0>
#   Fixed support for .io/.xyz/.me/.pl/.ro domains -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.23
#   Added support for .online domain -- https://github.com/hawkeye116477
#
#  Version 2.22
#   Added support for .kz domains -- Vladislav V. Prodan <github.com/click0>
#   Many thanks to the service that provided the API for the .KZ zone - https://www.ps.kz/
#
#  Version 2.21
#   Fixed support for .pl domain -- https://github.com/hawkeye116477
#
#  Version 2.20
#   Fixed support for .jp/.aero/.cn/.pl/.md/.tr/.it/.mx domains -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.19
#   Added support for .ua/.cn/.io domains -- Vladislav V. Prodan <github.com/click0>
#   Fixed support for .pl domain -- Vladislav V. Prodan <github.com/click0>
#
#  Version 2.18
#   Added support for .pro/.mx/.ro/.aero/.asia/.cc/.college domain -- Vivek Gite <github.com/nixcraft>
#   Added support for .it domain -- https://github.com/pelligrag
#   Fixed support for .in/.md/.cafe/.fr/.re/.tf/.yt/.pm/.wf/.cat domain -- Vivek Gite <github.com/nixcraft>
#
#  Version 2.17
#   Fixed suport for .co domain -- Vivek Gite <github.com/nixcraft>
#
#  Version 2.16
#   Added suport for .tr domain -- https://github.com/eaydin
#
#  Version 2.15
#   Fixed suport for .jp domain -- Vivek Gite <github.com/nixcraft>
#
#  Version 2.14
#   Added support for .se/.nu/.dk/.xyz and bug fix by -- https://github.com/happyoccasion
#
#  Version 2.13
#   Fiexed suport for .biz/.us/.mobi/.tv domains -- Vivek Gite <github.com/nixcraft>
#
#  Version 2.12
#   Added suport for Czechia (.cz) domains -- Minitram <github.com/Minitram>
#
#  Version 2.11
#    Added support for .cafe/.blog/.link domain -- <github.com/kode29>
#
#  Version 2.10
#   Bug fix for .com, net, org, jp, and edu  -- Vivek Gite <vivek@nixcraft.com>
#
#  Version 2.9
#   Bug fix for .ru -- Mikhail Grigorev <sleuthound@gmail.com>
#
#  Version 2.8
#   Use 'which' to autodetect awk, whois, date and other utils -- Mikhail Grigorev <sleuthound@gmail.com>
#
#  Version 2.7
#   Bug fix for .md and .co -- Bill Bell <billnbell@gmail.com>
#
#  Version 2.6
#   Bug fix for .mobi -- Bill Bell <billnbell@gmail.com>
#
#  Version 2.5
#   Bug fix for .me -- Mikhail Grigorev <sleuthound@gmail.com>
#
#  Version 2.4
#   Bug fix for .com, .net, .us, .org, .in -- Mikhail Grigorev <sleuthound@gmail.com>
#
#  Version 2.3
#   Bug fix for .info -- Mikhail Grigorev <sleuthound@gmail.com>
#
#  Version 2.2
#   Bug fix that adds support for .ru and .su domains -- Jim McNamara
#
#  Version 2.1
#   Bug fix for .mobi and .us -- Jim McNamara
#   Added a variable for the location of tr, and made all calls to cut and tr use the variable
#   instead of the command without path
#
#  Version 2.0
#   Bug fix for .org, .biz, info, and .ca -- Cameron and Jim
#
#  Version 1.9
#    Bug fix and enhancement for .uk and .co.uk -- Vivek Gite <vivek@nixcraft.com>
#
#  Version 1.8
#    Bug fix added $MAIL -- Vivek Gite <vivek@nixcraft.com>
#
#  Version 1.7
#    Added support for .jp domain names  -- Vivek Gite <vivek@nixcraft.com>
#
#  Version 1.6
#    Added support for .uk domain names; fixed a bug detecting tldtype  -- Vivek Gite <vivek@nixcraft.com>
#
#  Version 1.5
#    Added support for .org, .in, .biz and .info domain names -- Vivek Gite <vivek@nixcraft.com>
#
#  Version 1.4
#    Updated the documentation.
#
#  Version 1.3
#    Gracefully Handle the case where the expiration data is unavailable
#
#  Version 1.2
#    Added "-s" option to allow arbitrary registrars
#
#  Version 1.1
#    Fixed issue with 'e' getopt string -- Pedro Alves
#
#  Version 1.0
#    Initial Release
#
#
# Purpose:
#  domain-check checks to see if a domain has expired. domain-check
#  can be run in interactive and batch mode, and provides faciltities
#  to alarm if a domain is about to expire.
#
# License:
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
# Notes:
#   Since each registrar provides expiration data in a unique format (if
#   they provide it at all), domain-check is currently only able to
#   processess expiration information for a subset of the available
#   registrars.
#
# Requirements:
#   Requires whois, curl (for domains in the .kz zone)
#
# Installation:
#   Copy the shell script to a suitable location
#
# Tested platforms:
#  -- Solaris 9 using /bin/bash
#  -- Solaris 10 using /bin/bash
#  -- OS X 10.4.2 using /bin/sh
#  -- OpenBSD using /bin/sh
#  -- FreeBSD using /bin/sh
#  -- Redhat advanced server 3.0MU3 using /bin/sh
#
# Usage:
#  Refer to the usage() sub-routine, or invoke domain-check
#  with the "-h" option.
#
# Example:
#
#  The first example will print the expiration date and registrar for prefetch.net:
#
#  $ domain-check.sh -d prefetch.net
#
#  Domain                              Registrar         Status   Expires     Days Left
#  ----------------------------------- ----------------- -------- ----------- ---------
#  prefetch.net                        INTERCOSMOS MEDIA Valid    13-feb-2006   64
#
#  The second example prints the expiration date and registrar for the domains
#  listed in the file "domains":
#
#  $ domain-check.sh -f domains
#
#  Domain                              Registrar         Status   Expires     Days Left
#  ----------------------------------- ----------------- -------- ----------- ---------
#  sun.com                             NETWORK SOLUTIONS Valid    20-mar-2010   1560
#  google.com                          EMARKMONITOR INC. Valid    14-sep-2011   2103
#  ack.com                             NETWORK SOLUTIONS Valid    09-may-2008   880
#  prefetch.net                        INTERCOSMOS MEDIA Valid    13-feb-2006   64
#  spotch.com                          GANDI             Valid    03-dec-2006   357
#
#  The third example will e-mail the address admin@prefetch.net with the domains that
#  will expire in 60-days or less:
#
#  $ domain-check -a -f domains -q -x 60 -e admin@prefetch.net
#

PATH=/bin:/usr/bin:/usr/local/bin:/usr/local/ssl/bin:/usr/sfw/bin
export PATH

# Who to page when an expired domain is detected (cmdline: -e)
ADMIN="sysadmin@mydomain.com"

# Number of days in the warning threshhold  (cmdline: -x)
WARNDAYS=30

# If QUIET is set to TRUE, don't print anything on the console (cmdline: -q)
QUIET="FALSE"

# Don't send emails by default (cmdline: -a)
ALARM="FALSE"

# Output the result in formatted (by default) or CSV format (csv) (cmdline: -o)
OUTPUT_FORMAT="format"
CSV_DELIMITER=","

# Don't show the version of the script by default (cmdline: -V)
VERSIONENABLE="FALSE"

# Don't show debug information by default (cmdline: -vv)
VERBOSE="FALSE"

# Whois server to use (cmdline: -s)
WHOIS_SERVER="whois.iana.org"

# Location of system binaries
for BINARY in whois date mail curl ; do
    if [ ! -x "$(command -v $BINARY)" ]; then
        echo "ERROR: The $BINARY binary does not exist in \$$BINARY."
        echo "  FIX: Please modify the \$$BINARY variable in the program header."
        exit 1
    fi
done

AWK=$(command -v awk)
WHOIS=$(command -v whois)
DATE=$(command -v date)
CUT=$(command -v cut)
GREP=$(command -v grep)
TR=$(command -v tr)
MAIL=$(command -v mail)
CURL=$(command -v curl)
ECHO=$(command -v echo)
HEAD=$(command -v head)
SED=$(command -v sed)
TAIL=$(command -v tail)

# Version of the script
VERSION=$(${AWK} -F': ' '/^# Current Version:/ { print $2; exit}' $0)

# User-Agent
VARUSERAGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.2 Safari/605.1.15"

# Place to stash temporary files
WHOIS_TMP="/var/tmp/whois.$$"
WHOIS_2_TMP="/var/tmp/whois_2.$$"

#############################################################################
# Purpose: Convert a date from MONTH-DAY-YEAR to Julian format
# Acknowledgements: Code was adapted from examples in the book
#                   "Shell Scripting Recipes: A Problem-Solution Approach"
#                   ( ISBN 1590594711 )
# Arguments:
#   $1 -> Month (e.g., 06)
#   $2 -> Day   (e.g., 08)
#   $3 -> Year  (e.g., 2006)
#############################################################################
date2julian()
{
    if [ "${1} != "" ] && [ "${2} != ""  ] && [ "${3}" != "" ]
    then
         ## Since leap years add aday at the end of February,
         ## calculations are done from 1 March 0000 (a fictional year)
         d2j_tmpmonth=$((12 * ${3} + ${1} - 3))

         ## If it is not yet March, the year is changed to the previous year
         d2j_tmpyear=$(( ${d2j_tmpmonth} / 12))

         ## The number of days from 1 March 0000 is calculated
         ## and the number of days from 1 Jan. 4713BC is added
         echo $(( (734 * ${d2j_tmpmonth} + 15) / 24 -  2 * ${d2j_tmpyear} + ${d2j_tmpyear}/4 \
            - ${d2j_tmpyear}/100 + ${d2j_tmpyear}/400 + $2 + 1721119 ))
    else
         echo 0
    fi
}

#############################################################################
# Purpose: Convert a string month into an integer representation
# Arguments:
#   $1 -> Month name (e.g., Sep)
#############################################################################
getmonth()
{
    LOWER=`tolower $1`

    case ${LOWER} in
          jan) echo 1 ;;
          feb) echo 2 ;;
          mar) echo 3 ;;
          apr) echo 4 ;;
          may) echo 5 ;;
          jun) echo 6 ;;
          jul) echo 7 ;;
          aug) echo 8 ;;
          sep) echo 9 ;;
          oct) echo 10 ;;
          nov) echo 11 ;;
          dec) echo 12 ;;
            *) echo  0 ;;
    esac
}

#############################################################################
# Purpose: Convert the month number into a short form for writing the month name
# Arguments:
#   $1 -> Month number (e.g., 08)
#############################################################################
getmonth_number()
{
    case ${1} in
          1|01) echo jan ;;
          2|02) echo feb ;;
          3|03) echo mar ;;
          4|04) echo apr ;;
          5|05) echo may ;;
          6|06) echo jun ;;
          7|07) echo jul ;;
          8|08) echo aug ;;
          9|09) echo sep ;;
          10) echo oct ;;
          11) echo nov ;;
          12) echo dec ;;
          *) echo 0 ;;
    esac
}

#############################################################################
# Purpose: Calculate the number of seconds between two dates
# Arguments:
#   $1 -> Date #1
#   $2 -> Date #2
#############################################################################
date_diff()
{
    if [ "${1}" != "" ] && [ "${2}" != "" ]
    then
        echo $(expr ${2} - ${1})
    else
        echo 0
    fi
}

##################################################################
# Purpose: Converts a string to lower case
# Arguments:
#   $1 -> String to convert to lower case
##################################################################
tolower()
{
    LOWER=`echo ${1} | ${AWK} '{print tolower($0);}'`
    echo $LOWER
}

##################################################################
# Purpose: Access whois data to grab the registrar and expiration date
# Arguments:
#   $1 -> Domain to check
##################################################################
check_domain_status()
{
    local REGISTRAR=""
    # Avoid WHOIS LIMIT EXCEEDED - slowdown our whois client by adding 1 sec
    sleep 1
    # Save the domain since set will trip up the ordering
    local DOMAIN=${1}
    local TLDTYPE=$(echo ${DOMAIN} | ${AWK} -F. '{print tolower($NF);}')
    if [ "x${TLDTYPE}"  == "x" ];
    then
        TLDTYPE=$(echo ${DOMAIN} | ${AWK} -F. '{print tolower($(NF-1));}')
    fi
    if [ "${TLDTYPE}"  == "ua" -o "${TLDTYPE}"  == "pl" -o "${TLDTYPE}"  == "br" ];
    then
        local SUBTLDTYPE=$(echo ${DOMAIN} | ${AWK} -F. '{print tolower($(NF-1)"."$(NF));}')
    fi

    # Invoke whois to find the domain registrar and expiration date
    #${WHOIS} -h ${WHOIS_SERVER} "=${1}" > ${WHOIS_TMP}
    # Let whois select server

    if [ -n "${WHOIS_SERVER}" ] && [ "${WHOIS_SERVER}" == "whois.iana.org" ]; then
        local WHS="$(${WHOIS} -h "${WHOIS_SERVER}" "${TLDTYPE}" | ${AWK} '/whois:/ {print $2}')"
    else
        local WHS="${WHOIS_SERVER}"
    fi

    [ "${SUBTLDTYPE}" == "co.pl" ] && local WHS="whois.co.pl"; 	# added by @hawkeye116477 20190514

    ${WHOIS} -h ${WHS} "${1}" | env LC_CTYPE=C LC_ALL=C ${TR} -d "\r" > ${WHOIS_TMP}

    if [ "${TLDTYPE}" == "kz" ];
    then
       ${CURL} -s -A "$VARUSERAGENT" "https://hoster.kz/whois/?d=${1}" \
        | env LC_CTYPE=C LC_ALL=C ${TR} -d "\r" > ${WHOIS_2_TMP}
    fi

    # Parse out the expiration date and registrar -- uses the last registrar it finds
    REGISTRAR=`${AWK} -F: '/Registrar:/ && $2 != "" { REGISTRAR=substr($2,2,40) } END { print REGISTRAR }' ${WHOIS_TMP}\
        | env LC_CTYPE=C LC_ALL=C ${TR} -d "\r" | ${SED} -e 's/[[:space:]\t]*// ;'`

    if [ "${TLDTYPE}" == "uk" ]; # for .uk domain
    then
        REGISTRAR=`${AWK} -F: '/Registrar:/ && $0 != "" { getline; sub(/^[ \t]+/,"",$0); print $0; }' ${WHOIS_TMP} \
        	| ${AWK} -F'[' '{ print $1 }'`
    elif [ "${TLDTYPE}" == "me" ];
    then
        REGISTRAR=`${AWK} -F: '/Registrar:/ && $2 != "" { REGISTRAR=substr($2,2,23) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "jp" ];
    then
        REGISTRAR=`${AWK} -F\] '/\[Registrant\]/ && $2 != "" { REGISTRAR=substr($2,21,40) } END { print REGISTRAR }' ${WHOIS_TMP} | ${TR} -d "\r"`
    # no longer shows Registrar name, so will use Status #
    elif [ "${TLDTYPE}" == "md" ];
    then
        #REGISTRAR=`${AWK} -F: '/Status:/ && $2 != "" { REGISTRAR=substr($2,2,27) } END { print REGISTRAR }' ${WHOIS_TMP} | ${TR} -d "\r "`
        REGISTRAR="Unknown"
    elif [ "${TLDTYPE}" == "info" ];
    then
        REGISTRAR=`${AWK} -F: '/Registrar:/ && $2 != "" { REGISTRAR=substr($2,2,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    if [ "${REGISTRAR}" = "" ]
    then
        REGISTRAR=`${AWK} -F: '/Sponsoring Registrar:/ && $2 != "" { REGISTRAR=substr($2,1,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    fi
    elif [ "${TLDTYPE}" == "edu" ]; # added by nixCraft 26-aug-2017
    then
        REGISTRAR=`${AWK} -F: '/Registrant:/ && $0 != "" { getline;REGISTRAR=substr($0,2,30) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "cafe" ]; # added by @kode29 26-aug-2017
    then
        REGISTRAR=`${AWK} -F: '/Registrar:/ && $0 != "" { REGISTRAR=substr($0,12,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "link" ]; # added by @kode29 26-aug-2017
    then
        REGISTRAR=`${AWK} -F: '/Registrar:/ && $0 != "" { REGISTRAR=substr($0,12,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "blog" ]; # added by @kode29 26-aug-2017
    then
        REGISTRAR=`${AWK} -F: '/Registrar:/ && $0 != "" { REGISTRAR=substr($0,12,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "ru" -o "${TLDTYPE}" == "su" ]; # added 20141113
    then
        REGISTRAR=`${AWK} -F: '/registrar:/ && $2 != "" { REGISTRAR=substr($2,6,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "ua" -a "${SUBTLDTYPE}" == "od.ua" ]; # added by @click0 20190212
    then
        REGISTRAR=`${AWK} -F: '/registrar:/ && $2 != "" { REGISTRAR=substr($2,11,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "ua" ]; # added by @click0 20190212
    then
        REGISTRAR=`${AWK} -F: '/registrar:/ && $2 != "" { REGISTRAR=substr($2,9,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "укр" ]; # added by @click0 20190515
    then
        REGISTRAR=`${AWK} -F: '/Registrar:/ && $2 != "" { REGISTRAR=substr($2,2,65) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "kz" ]; # added by @click0 20190223
    then
        REGISTRAR=`${AWK} -F": " '/Current Registar:/ && $0 != "" { print $2 }' ${WHOIS_TMP} | ${TR} -d " \r"`
    elif [ "${TLDTYPE}" == "cz" ]; # added by Minitram 20170830
    then
        REGISTRAR=`${AWK} -F: '/registrar:/ && $2 != "" { REGISTRAR=substr($2,5,17) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "pl" ] && [ "${SUBTLDTYPE}" != "co.pl" ];
    then
        REGISTRAR=`${AWK} -F: '/REGISTRAR:/ && $0 != "" { getline; REGISTRAR=substr($0,0,35) } END { print REGISTRAR }' ${WHOIS_TMP} | ${TR} -d " \r"`
    elif [ "${SUBTLDTYPE}" == "co.pl" ] # added by @hawkeye116477 20190514;
    then
        REGISTRAR=`${GREP} -A1 'Holder data:' ${WHOIS_TMP} | ${AWK} -F': ' '/Name...:/ { print $2 }'`
    elif [ "${TLDTYPE}" == "xyz" ];
    then
        REGISTRAR=`${GREP} Registrar: ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $0 != "" { getline; REGISTRAR=substr($0,12,35) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "se" -o "${TLDTYPE}" == "nu" ];
    then
        REGISTRAR=`${AWK} -F: '/registrar:/ && $2 != "" { getline; REGISTRAR=substr($2,9,20) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "fi" ];
    then
        REGISTRAR=`${GREP} 'registrar' ${WHOIS_TMP} | ${AWK} -F: '/registrar/ && $2 != "" { getline; REGISTRAR=substr($2,2,20) } END { print  REGISTRAR }'`
    elif [ "${TLDTYPE}" == "fr" -o "${TLDTYPE}" == "re" -o "${TLDTYPE}" == "tf" -o "${TLDTYPE}" == "yt" -o "${TLDTYPE}" == "pm" -o "${TLDTYPE}" == "wf" ];
    then
        REGISTRAR=`${GREP} "registrar:" ${WHOIS_TMP} | ${AWK} -F: '/registrar:/ && $2 != "" { getline; REGISTRAR=substr($2,4,20) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "dk" ];
    then
        REGISTRAR=`${GREP} Copyright ${WHOIS_TMP} | ${AWK}  '{ print $8, $9, $10 }'`
    elif [ "${TLDTYPE}" == "tr" ];
    then
        REGISTRAR=`${GREP} "Organization Name" -m 1 ${WHOIS_TMP} | ${AWK} -F': ' '{ print $2 }'`
    elif [ "${TLDTYPE}" == "it" ];
    then
        REGISTRAR=`${AWK} -F':' '/Registrar/ && $0 != "" { getline;REGISTRAR=substr($0,21,40) } END { print REGISTRAR }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "cn" ];
    then
        REGISTRAR=$(${AWK} -F': ' '/Registrant\ ID:|Registrant:/ && $0 != "" { print $2 }' ${WHOIS_TMP})
    elif [ "${TLDTYPE}" == "io" ];
    then
        REGISTRAR=$(${AWK} -F: '/Registrar:/ && $0 != "" { print $2 }' ${WHOIS_TMP} | ${TR} -d " \r")
    elif [ "${TLDTYPE}" == "mx" ];
    then
        REGISTRAR=$(${AWK} '/Registrar:/ && $0 != "" { print $2 }' ${WHOIS_TMP})
    elif [ "${TLDTYPE}" == "is" ]; # added by @hawkeye116477 20190408
    then
        REGISTRAR=$(${AWK} '/registrant:/ && $0 != "" { print $2 }' ${WHOIS_TMP})
    elif [ "${TLDTYPE}" == "sk" ]; # added by @hawkeye116477 20190603
    then
        REGISTRAR=$(${AWK} '/Registrar:/ && $0 != "" { print $2; exit }' ${WHOIS_TMP})
    elif [ "${SUBTLDTYPE}" == "com.br" ];
    then
        REGISTRAR=$(${AWK} -F':' '/owner:/ && $0 != "" { print $2 }' ${WHOIS_TMP} | ${SED} -e 's/[[:space:]\t]*// ;')
    elif [ "${TLDTYPE}" == "il" ];
    then
        REGISTRAR=$(${AWK} -F':' '/registrar name:/ && $0 != "" { print $2 }' ${WHOIS_TMP} | ${SED} -e 's/[[:space:]\t]*// ;')
    elif [ "${TLDTYPE}" == "id" ];
    then
        REGISTRAR=$(${AWK} -F: '/Registrar Organization:/ && $2 != ""  { REGISTRAR=substr($2,1,40) } END { print REGISTRAR }' ${WHOIS_TMP} | ${SED} -e 's/[[:space:]\t]*// ;')
    elif [ "${TLDTYPE}" == "tg" ];
    then
        REGISTRAR=`${ECHO} ${REGISTRAR} | ${TR} -d "."`
    elif [ "${TLDTYPE}" == "hr" ];
    then
        REGISTRAR=$(${AWK} -F': ' '/Registrant Name:/ && $2 != "" { print $2 }' ${WHOIS_TMP})
    elif [ "${TLDTYPE}" == "gg" ];
    then
        REGISTRAR=`${AWK} -F'(' '/Registrar:/ && $0 != "" { getline; sub(/^[ \t]+/,"",$0); print $1; }' ${WHOIS_TMP}`
    elif [ "${TLDTYPE}" == "kr" ];
    then
        REGISTRAR=`${AWK} -F: '/Registrant   / && $2 != "" { REGISTRAR=substr($2,2,30) } END { print REGISTRAR }' ${WHOIS_TMP}`

    elif [ "${TLDTYPE}" == "hk" ];
    then
        REGISTRAR=`${AWK} -F: '/Registrar Name:/ && $2 != "" { REGISTRAR=substr($2,2,38) } END { print REGISTRAR }' ${WHOIS_TMP}`

    elif [ "${TLDTYPE}" == "pt" ];
    then
       REGISTRAR=`${AWK} -F: '/Admin Name:/ && $2 != "" { REGISTRAR=substr($2,2,30) } END { print REGISTRAR }' ${WHOIS_TMP}`

    elif [ "${TLDTYPE}" == "ar" ] && [ "${SUBTLDTYPE}" != "com.ar" ];
    then
        REGISTRAR=`${AWK} -F: '/name:/ && $2 != "" { REGISTRAR=substr($2,2,30) } END { print REGISTRAR }' ${WHOIS_TMP}`
    fi

    # If the Registrar is NULL, then we didn't get any data
    if [ "x${REGISTRAR}" = "x" ]
    then
        prints "${DOMAIN}" "Unknown" "Unknown" "Unknown" "Unknown"
        return
    fi

    # The whois Expiration data should resemble the following: "Expiration Date: 09-may-2008"

    if [ "${TLDTYPE}" == "uk" ]; # for .uk domain
    then
        DOMAINDATE=`${AWK} '/Renewal date:/ || /Expiry date:/ { print $3 }' ${WHOIS_TMP}`

    elif [ "${TLDTYPE}" == "jp" ]; # for .jp fixed @click0 2019/06/26
    then
        tdomdate=`${AWK} -F] '/\[有効期限\]|\[Expires on\]/ { print $2 }' ${WHOIS_TMP} | ${TR} -d " \r"`
        tyear=`echo ${tdomdate} | ${CUT} -d'/' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'/' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'/' -f3`
        DOMAINDATE=`echo $tday-$tmonth-$tyear`

    elif [ "${TLDTYPE}" == "ru" -o "${TLDTYPE}" == "su" ]; # for .ru and .su 2014/11/13
    then
        tdomdate=`${AWK} '/paid-till:/ { print $2 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} |${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f3 | ${CUT} -d'T' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "ua" ]; # for .ua @click0 2019/02/12
    then
        tdomdate=`${AWK} '/expires:/ { print $2 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f3 | ${CUT} -d'T' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "укр" ]; # for .укр @click0 2019/05/15
    then
        tdomdate=`${AWK} '/Expiration Date:/ { print $3 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f3`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(getmonth ${tmon})
        tmonth=$(getmonth_number ${tmonth})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "is" ]; # for .is @hawkeye116477 2019/04/08
    then
        tdomdate=`${AWK} '/expires:/ { print $2 " " $3 " " $4}' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d' ' -f3`
        tmon=`echo ${tdomdate} | ${CUT} -d' ' -f1`
        case ${tmon} in
             January) tmonth=jan ;;
             February) tmonth=feb ;;
             March) tmonth=mar ;;
             April) tmonth=apr ;;
             May) tmonth=may ;;
             June) tmonth=jun ;;
             July) tmonth=jul ;;
             August) tmonth=aug ;;
             September) tmonth=sep ;;
             October) tmonth=oct ;;
             November) tmonth=nov ;;
             December) tmonth=dec ;;
             *) tmonth=0 ;;
        esac
        tday=`echo ${tdomdate} | ${CUT} -d' ' -f2`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "kz" ]; # for .kz @click0 2019/02/23
    then
        tdomdate=$(${GREP} -A 6 'Домен оплачен до' ${WHOIS_2_TMP} | ${TAIL} -n 1 | ${AWK} -F'</p>' '{ print $(NF-1) }' \
        	| ${AWK} '{ print $1 }' | env LC_CTYPE=C LC_ALL=C ${TR} -d "\r<p>")
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f3 | ${CUT} -d'T' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "com" -o "${TLDTYPE}" == "net" -o "${TLDTYPE}" == "org"  -o "${TLDTYPE}" == "link" -o \
        "${TLDTYPE}" == "blog" -o "${TLDTYPE}" == "cafe" -o "${TLDTYPE}" == "biz" -o "${TLDTYPE}" == "us" -o \
        "${TLDTYPE}" == "mobi" -o "${TLDTYPE}" == "tv" -o "${TLDTYPE}" == "co" -o "${TLDTYPE}" == "pro" -o \
        "${TLDTYPE}" == "cafe" -o "${TLDTYPE}" == "in" -o "${TLDTYPE}" == "cat" -o "${TLDTYPE}" == "asia" -o \
        "${TLDTYPE}" == "cc" -o "${TLDTYPE}" == "college" -o "${TLDTYPE}" == "aero" -o "${TLDTYPE}" == "online" -o \
        "${TLDTYPE}" == "app" -o "${TLDTYPE}" == "io" -o "${TLDTYPE}" == "me" -o "${TLDTYPE}" == "xyz" -o \
        "${TLDTYPE}" == "top" -o "${TLDTYPE}" == "bid" -o "${TLDTYPE}" == "ng" -o "${TLDTYPE}" == "site" -o \
        "${TLDTYPE}" == "icu"  -o "${TLDTYPE}" == "cloud" -o "${TLDTYPE}" == "systems" -o \
        "${TLDTYPE}" == "expert" -o "${TLDTYPE}" == "express" -o "${TLDTYPE}" == "ca" -o "${TLDTYPE}" == "space" -o \
        "${TLDTYPE}" == "fun" -o "${TLDTYPE}" == "museum" -o "${TLDTYPE}" == "live" -o "${TLDTYPE}" == "club" -o \
        "${TLDTYPE}" == "stream" -o "${TLDTYPE}" == "today" -o "${TLDTYPE}" == "website" -o "${TLDTYPE}" == "host" -o \
        "${TLDTYPE}" == "team" -o "${TLDTYPE}" == "info" -o "${TLDTYPE}" == "xxx" -o "${TLDTYPE}" == "md" -o \
        "${TLDTYPE}" == "se" -o "${TLDTYPE}" == "nu" -o "${TLDTYPE}" == "dk" -o "${TLDTYPE}" == "it" -o \
        "${TLDTYPE}" == "do" -o "${TLDTYPE}" == "ro" -o "${TLDTYPE}" == "game" ];
    then
        tdomdate=`${AWK} '/Registrar Registration Expiration [Dd]ate:|Registry Expiry Date:|Expiration [Dd]ate:|\
          Renewal date:|Expir[ey] [Dd]ate:|Expires [Oo]n:|Expires    [Oo]n:|[Ee]xpires:/ \
           { print $NF }' ${WHOIS_TMP} | ${AWK} -FT '{ print $1 }' | ${HEAD} -1`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} |${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f3 | ${CUT} -d'T' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "edu" ] # added on 26-aug-2017 by nixCraft
    then
        tdomdate=`${AWK} '/Domain expires:/ { print $NF }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f3`
        tmon=`echo ${tdomdate} |${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        DOMAINDATE=`echo "${tday}-${tmon}-${tyear}"`

     elif [ "${TLDTYPE}" == "cz" ] # added on 20170830 by Minitram
     then
        tdomdate=`${AWK} '/expire:/ { print $NF }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'.' -f3`
        tmon=`echo ${tdomdate} |${CUT} -d'.' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'.' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "pl" ] &&  [ "${SUBTLDTYPE}" != "co.pl" ] # NASK
    then
        tdomdate=`${AWK} -F: '/^expiration\ date:/ || /renewal\ date:/ { print $2; }' ${WHOIS_TMP} | ${AWK} -F" " '{ print $1; }'`
        tyear=`echo ${tdomdate} | ${CUT} -d'.' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'.' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'.' -f3`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif  [ "${SUBTLDTYPE}" == "co.pl" ]; # for .co.pl @hawkeye116477 2019/05/14
    then
        tdomdate=`${AWK} '/Expires:/ { print $2 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'.' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'.' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'.' -f3`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "fi" ];
    then
        tdomdate=`${AWK} '/expires/ { print $2 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'.' -f3`
        tmon=`echo ${tdomdate} | ${CUT} -d'.' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'.' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "fr" -o "${TLDTYPE}" == "re" -o "${TLDTYPE}" == "tf" -o "${TLDTYPE}" == "yt" -o \
      "${TLDTYPE}" == "pm" -o "${TLDTYPE}" == "wf" -o "${TLDTYPE}" == "mx" -o "${TLDTYPE}" == "sk"  ];
    then
        tdomdate=`${AWK} '/Expiry\ Date:|Expiration\ Date:|Valid\ Until:/ { print $3 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f3 | ${CUT} -d'T' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "tr" ];
    then
        tdomdate=`${AWK} '/Expires/ { print substr($3, 1, length($3)-1) }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f3`
        DOMAINDATE=`echo "${tday}-${tmon}-${tyear}"`

    elif [ "${TLDTYPE}" == "cn" ];	# for .cn @click0 2019/02/12
    then
        tdomdate=`${AWK} -F':' '/Expiration Time:/ { print $2 }' ${WHOIS_TMP} | ${AWK} '{ print $1; }'`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f3`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "id" ]; # for .id @Minitram 2019/07/01
    then
        tdomdate=`${AWK} '/Expiration Date:/ { print $3 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f3`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(tolower ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${SUBTLDTYPE}" == "com.br" ];
    then
        tdomdate=`${AWK} '/expires:/ { print $2 }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -c 1-4`
        tmon=`echo ${tdomdate} | ${CUT} -c 5-6`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -c 7-8`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "il" ]
    then
        tdomdate=`${AWK} '/validity:/ { print $NF }' ${WHOIS_TMP}`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f3`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "tg" ]
    then
        tdomdate=`${AWK} -F: '/Expiration:/ { print $2 }' ${WHOIS_TMP} | ${HEAD} -1 | ${TR} -d "."`
        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d '-' -f3`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "rs" ]
    then
        tdomdate=`${AWK} '/Expiration\ date:/ { print $3 }' ${WHOIS_TMP} `
        tyear=`echo ${tdomdate} | ${CUT} -d'.' -f3`
        tmon=`echo ${tdomdate} | ${CUT} -d'.' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'.' -f1`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "gg" ]
    then
        tdomdate=`${AWK} -F' ' '/Registry fee due on/ && $0 != "" { print $5" "$6 }' ${WHOIS_TMP}`
        tyear=$(( ${YEAR} + 1 ))
        tmon=`echo ${tdomdate} | ${CUT} -d' ' -f2`
        case ${tmon} in
             January) tmonth=jan ;;
             February) tmonth=feb ;;
             March) tmonth=mar ;;
             April) tmonth=apr ;;
             May) tmonth=may ;;
             June) tmonth=jun ;;
             July) tmonth=jul ;;
             August) tmonth=aug ;;
             September) tmonth=sep ;;
             October) tmonth=oct ;;
             November) tmonth=nov ;;
             December) tmonth=dec ;;
             *) tmonth=0 ;;
        esac
        tday=`echo ${tdomdate} | ${AWK} -F'th|st' '{ print $1 }'`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    elif [ "${TLDTYPE}" == "kr" ]; # for .kr added @copenhaus 2021/02/18
    then
        tdomdate=`${AWK} -F\: '/Expiration/ { print $2 }' ${WHOIS_TMP} | ${TR} -d " \r"`
        tyear=`echo ${tdomdate} | ${CUT} -d'.' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'.' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'.' -f3`
        DOMAINDATE=`echo $tday-$tmonth-$tyear`

    elif [ "${TLDTYPE}" == "hk" ]; # for .hk added @copenhaus 2021/02/18
    then
       tdomdate=`${AWK} '/Expiry Date:/ { print $3 }' ${WHOIS_TMP} | ${TR} -d " \r"`
       tyear=$(echo $tdomdate| ${CUT} -c7-10)
       tmonth=$(echo $tdomdate| ${CUT} -c4-5)
       tmonth=$(getmonth_number ${tmonth})
       tday=$(echo $tdomdate| ${CUT} -c-2)
       DOMAINDATE=`echo $tday-$tmonth-$tyear`

    elif [ "${TLDTYPE}" == "pt" ]; # for .pt added @copenhaus 2021/03/02
    then
       tdomdate=`${AWK} '/Expiration Date:/ { print $3 }' ${WHOIS_TMP} | ${TR} -d " \r"`
       tyear=$(echo $tdomdate| ${CUT} -c7-10)
       tmonth=$(echo $tdomdate| ${CUT} -c4-5)
       tmonth=$(getmonth_number ${tmonth})
       tday=$(echo $tdomdate| ${CUT} -c-2)
       DOMAINDATE=`echo $tday-$tmonth-$tyear`

    elif [ "${TLDTYPE}" == "sg" ]; # for .sg added @copenhaus 2021/03/02
    then
       tdomdate=`${AWK} '/Expiration Date:/ { print $3 }' ${WHOIS_TMP} | ${TR} -d " \r"`
       tyear=$(echo $tdomdate| ${CUT} -c8-11)
       tmonth=$(echo $tdomdate| ${CUT} -c4-6)
       tday=$(echo $tdomdate| ${CUT} -c-2)
       DOMAINDATE=`echo $tday-$tmonth-$tyear`

    elif [ "${TLDTYPE}" == "ar" ] &&  [ "${SUBTLDTYPE}" != "com.ar" ] # for .ar added @axelvf 2022/07/21
    then
        tdomdate=`${AWK} '/expire:/ { print $2 }' ${WHOIS_TMP} | ${TR} -d " \r"`
        tyear=`echo ${tdomdate} | ${CUT} -d'.' -f1`
        tmon=`echo ${tdomdate} | ${CUT} -d'.' -f2`
        tmonth=$(getmonth_number ${tmon})
        tday=`echo ${tdomdate} | ${CUT} -d'.' -f3`
        DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`

    # may work with others	 ??? ;)
    else
        DOMAINDATE=`${AWK} '/Expiration:|[Ee]xpires:|Registry\ Expiry\ Date:|Registrar\ Registration\ Expiration\ Date:/ \
        { print $NF }' ${WHOIS_TMP} | ${AWK} -FT '{ print $1 }' | ${HEAD} -1`
    fi

    #echo $DOMAINDATE # debug
    # Whois data should be in the following format: "13-feb-2006"
    IFS="-"
    set -- ${DOMAINDATE}
    MONTH=$(getmonth ${2})
    # We change the date format here as we need ("13-feb-2006")
    if [ "$MONTH" == "0" ]; then
        MONTH=${2#0}
        MONTH_IN_WORDS=$(getmonth_number ${2#0})
        DOMAINDATE=${3}-${MONTH_IN_WORDS}-${1}
        set -- ${DOMAINDATE}
    fi
    IFS=""

    # Convert the date to seconds, and get the diff between NOW and the expiration date
    DOMAINJULIAN=$(date2julian ${MONTH} ${1#0} ${3#0})
    DOMAINDIFF=$(date_diff ${NOWJULIAN} ${DOMAINJULIAN})

    if [ ${DOMAINDIFF} -lt 0 ] && [ ${DOMAINJULIAN} -gt 0 ] && \
       [ ${MONTH} -gt 0 ] && [ ${DAY} -gt 0 ] && [ ${YEAR} -gt 0 ]
    then
        if [ "${ALARM}" == "TRUE" ]
        then
            echo "The domain ${DOMAIN} has expired!" \
                | ${MAIL} -s "Domain ${DOMAIN} has expired!" ${ADMIN}
        fi
        prints "${DOMAIN}" "Expired" "${DOMAINDATE}" "${DOMAINDIFF}" "${REGISTRAR}"

    elif [ ${DOMAINDIFF} -lt ${WARNDAYS} ] && [ ${DOMAINJULIAN} -gt 0 ] && \
         [ ${MONTH} -gt 0 ] && [ ${DAY} -gt 0 ] && [ ${YEAR} -gt 0 ]
    then
        if [ "${ALARM}" == "TRUE" ]
        then
            echo "The domain ${DOMAIN} will expire on ${DOMAINDATE}" \
                | ${MAIL} -s "Domain ${DOMAIN} will expire in ${WARNDAYS}-days or less" ${ADMIN}
        fi
        prints "${DOMAIN}" "Expiring" "${DOMAINDATE}" "${DOMAINDIFF}" "${REGISTRAR}"
    elif [ ${DOMAINJULIAN} -eq 0 ] || [ ${MONTH} -le 0 ] || [ ${DAY} -le 0 ] || \
         [ ${YEAR} -le 0 ]
    then
        prints "${DOMAIN}" "Unknown" "Unknown" "Unknown" "${REGISTRAR}"
    else
        prints "${DOMAIN}" "Valid" "${DOMAINDATE}"  "${DOMAINDIFF}" "${REGISTRAR}"
    fi
}

####################################################
# Purpose: Print a heading with the relevant columns
# Arguments:
#   None
####################################################
print_heading()
{
    if [ "${QUIET}" != "TRUE" ]
    then
        if [ "${OUTPUT_FORMAT}" == "format" ]; then
            printf "\n%-35s %-46s %-8s %-11s %-5s\n" "Domain" "Registrar" "Status" "Expires" "Days Left"
            echo "----------------------------------- ---------------------------------------------- -------- ----------- ---------"
        fi
        if [ "${OUTPUT_FORMAT}" == "csv" ]; then
            printf "%s${CSV_DELIMITER}" "Domain" "Registrar" "Status" "Expires" "\"Days Left\"" | ${SED} "s/${CSV_DELIMITER}$//"
            printf '\n'
        fi
    fi
}

#####################################################################
# Purpose: Print a line with the expiraton interval
# Arguments:
#   $1 -> Domain
#   $2 -> Status of domain (e.g., expired or valid)
#   $3 -> Date when domain will expire
#   $4 -> Days left until the domain will expire
#   $5 -> Domain registrar
#####################################################################
prints()
{
    if [ "${QUIET}" != "TRUE" ]
    then
        local MIN_DATE=$(${ECHO} $3 | ${AWK} '{ print $1, $2, $4 }' | ${TR} -d " " )
        if [ "${OUTPUT_FORMAT}" == "format" ]; then
            printf "%-35s %-46s %-8s %-11s %-5s\n" "$1" "$5" "$2" "${MIN_DATE}" "$4"
        fi
        if [ "${OUTPUT_FORMAT}" == "csv" ]; then
            printf "%s${CSV_DELIMITER}" "$1" "\"$5\"" "$2" "${MIN_DATE}" "$4" | ${SED} "s/${CSV_DELIMITER}$//"
            printf '\n'
        fi

    fi
}

##########################################
# Purpose: Describe how the script works
# Arguments:
#   None
##########################################
usage()
{
    echo "Usage: $0 [ -e email ] [ -x expir_days ] [ -s whois server ] [ -o output format ] [ -q ] [ -a ] [ -h ] [ -v ] [ -V ]"
    echo "	 [ -s shois_server ] {[ -d domain_name ]} || {[ -f domain_file ]}"
    echo ""
    echo "  -a               : Send a warning message through email"
    echo "  -d domain_name   : Domain to analyze (interactive mode)"
    echo "  -e email address : Email address to send expiration notices"
    echo "  -f domain_file   : File with a list of domains"
    echo "  -h               : Print this screen"
    echo "  -s whois server  : Whois server to query for information"
    echo "  -o output format : Output the result in formatted (format) [by default] or CSV format (csv)"
    echo "  -q               : Don't print anything on the console"
    echo "  -x days          : Domain expiration interval (eg. if domain_date < days)"
    echo "  -v               : Show debug information when running script"
    echo "  -V               : Print version of the script"
    echo ""
}

### Evaluate the options passed on the command line
while getopts ad:e:f:hs:o:qx:vV option
do
    case "${option}"
    in
        a) ALARM="TRUE";;
        d) DOMAIN=${OPTARG};;
        e) ADMIN=${OPTARG};;
        f) SERVERFILE=$OPTARG;;
        s) WHOIS_SERVER=$OPTARG;;
        o) OUTPUT_FORMAT=$OPTARG;;
        q) QUIET="TRUE";;
        x) WARNDAYS=$OPTARG;;
        v) VERBOSE="TRUE";;
        V) VERSIONENABLE="TRUE";;
        \?) usage
        exit 1;;
    esac
done

### Show debug information when running script
if [ "${VERBOSE}" == "TRUE" ]
then
    set -x
fi

### Print version of the script
if [ "${VERSIONENABLE}" == "TRUE" ]
then
    printf "%-15s %-10s\n" "Script version: " "${VERSION}"
    exit 1
fi

### Baseline the dates so we have something to compare to
MONTH=$(${DATE} "+%m")
DAY=$(${DATE} "+%d")
YEAR=$(${DATE} "+%Y")
NOWJULIAN=$(date2julian ${MONTH#0} ${DAY#0} ${YEAR})

### Touch the files prior to using them
touch ${WHOIS_TMP}

### If a HOST and PORT were passed on the cmdline, use those values
if [ "${DOMAIN}" != "" ]
then
    print_heading
    check_domain_status "${DOMAIN}"
### If a file and a "-a" are passed on the command line, check all
### of the domains in the file to see if they are about to expire
elif [ -f "${SERVERFILE}" ]
then
    print_heading
    ${SED} -e 's/[[:space:]]*#.*// ; /^[[:space:]]*$/d' ${SERVERFILE} | tr -d '[:blank:]' | \
    while read DOMAIN
    do
        check_domain_status "${DOMAIN}"
    done

### There was an error, so print a detailed usage message and exit
else
    usage
    exit 1
fi

# Add an extra newline
echo

### Remove the temporary files
[ -f "${WHOIS_TMP}" ] && rm -f ${WHOIS_TMP};
[ -f "${WHOIS_2_TMP}" ] && rm -f ${WHOIS_2_TMP};

### Exit with a success indicator
exit 0
