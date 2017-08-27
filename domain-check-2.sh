#!/usr/bin/env bash

#
# Program: Domain Expiration Check <domain-check>
#
# Author: Matty < matty91 at gmail dot com >
# 
# Current Version: 2.10 
#
# Revision History:
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
# Last Updated: 13-Apr-2016
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
#   Requires whois
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

# Whois server to use (cmdline: -s)
WHOIS_SERVER="whois.internic.org"

# Location of system binaries
AWK=`which awk`
WHOIS=`which whois`
DATE=`which date`
CUT=`which cut`
TR=`which tr`
MAIL=`which mail`

# Place to stash temporary files
WHOIS_TMP="/var/tmp/whois.$$"

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
         echo $(( (734 * ${d2j_tmpmonth} + 15) / 24 -  2 * ${d2j_tmpyear} + ${d2j_tmpyear}/4
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
# Purpose: Calculate the number of seconds between two dates
# Arguments:
#   $1 -> Date #1
#   $2 -> Date #2
#############################################################################
date_diff() 
{
        if [ "${1}" != "" ] &&  [ "${2}" != "" ]
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
     LOWER=`echo ${1} | ${TR} [A-Z] [a-z]`
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
    # Avoid WHOIS LIMIT EXCEEDED - slowdown our whois client by adding 3 sec 
    sleep 3
    # Save the domain since set will trip up the ordering
    DOMAIN=${1}
    TLDTYPE="`echo ${DOMAIN} | ${CUT} -d '.' -f3 | tr '[A-Z]' '[a-z]'`" 
    if [ "${TLDTYPE}"  == "" ];
    then
	    TLDTYPE="`echo ${DOMAIN} | ${CUT} -d '.' -f2 | tr '[A-Z]' '[a-z]'`" 
    fi

    # Invoke whois to find the domain registrar and expiration date
    #${WHOIS} -h ${WHOIS_SERVER} "=${1}" > ${WHOIS_TMP}
    # Let whois select server 
    if [ "${TLDTYPE}"  == "org" ];
    then
        ${WHOIS} -h "whois.pir.org" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "in" ]; # India
    then
        ${WHOIS} -h "whois.registry.in" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "co" ];
    then
        ${WHOIS} -h "whois.nic.co" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "md" ];
    then
        ${WHOIS} -h "whois.nic.md" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "uk" ]; # United Kingdom  
    then
        ${WHOIS} -h "whois.nic.uk" "${1}" > ${WHOIS_TMP}

    elif [ "${TLDTYPE}"  == "biz" ];
    then
        ${WHOIS} -h "whois.neulevel.biz" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "info" ];
    then
        ${WHOIS} -h "whois.afilias.info" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "tv" ];
    then
        ${WHOIS} -h "tvwhois.verisign-grs.com" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "jp" ]; # Japan
    then
        ${WHOIS} -h "whois.jprs.jp" "${1}/e" > ${WHOIS_TMP}

    elif [ "${TLDTYPE}"  == "ca" ]; # Canada
    then
        ${WHOIS} -h "whois.cira.ca" "${1}" > ${WHOIS_TMP}

    elif [ "${TLDTYPE}"  == "edu" ]; # edu added by nixCraft on 26-aug-2017
    then
        ${WHOIS} -h "whois.educause.edu" "${1}" > ${WHOIS_TMP}


    elif [ "${TLDTYPE}"  == "link" ]; # edu added by @kode29 on 26-aug-2017
    then
        ${WHOIS} -h "whois.uniregistry.net" "${1}" > ${WHOIS_TMP}
    
    elif [ "${TLDTYPE}"  == "blog" ]; # edu added by @kode29 on 26-aug-2017
    then
        ${WHOIS} -h "whois.nic.blog" "${1}" > ${WHOIS_TMP}

    elif [ "${TLDTYPE}"  == "cafe" ]; # edu added by @kode29 on 26-aug-2017
    then
        ${WHOIS} -h "whois.donuts.co" "${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}"  == "com" -o "${TLDTYPE}"  == "net" ];
    then
	${WHOIS} -h ${WHOIS_SERVER} "=${1}" > ${WHOIS_TMP}
    elif [ "${TLDTYPE}" == "ru" -o "${TLDTYPE}" == "su" ]; # Russia and Soviet Union added 20141113
    then
        ${WHOIS} -h "whois.ripn.net" "${1}" > ${WHOIS_TMP}
    else
	${WHOIS} "${1}" > ${WHOIS_TMP}
    fi

    # Parse out the expiration date and registrar -- uses the last registrar it finds
    REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $2 != ""  { REGISTRAR=substr($2,2,17) } END { print REGISTRAR }'`

    if [ "${TLDTYPE}" == "uk" ]; # for .uk domain
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $0 != ""  { getline; REGISTRAR=substr($0,2,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "me" ];
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $2 != ""  { REGISTRAR=substr($2,2,23) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "jp" ];
    then
        REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} '/Registrant/ && $2 != ""  { REGISTRAR=substr($2,1,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "in" ];
    then
        REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Sponsoring Registrar:/ && $2 != ""  { REGISTRAR=substr($2,1,47) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "md" ];
    then
        REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrant:/ && $2 != ""  { REGISTRAR=substr($2,1,47) } END { print REGISTRAR }'`
    # No longer needed for .org. Commented out by nixCraft on 26-aug-2017
    #elif [ "${TLDTYPE}" == "org" ];
    #then
    #    REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Sponsoring Registrar:/ && $2 != ""  { REGISTRAR=substr($2,2,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "info" ];
    then
        REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $2 != ""  { REGISTRAR=substr($2,2,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "biz" -o "${TLDTYPE}" == "co" ];
    then
        REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $2 != ""  { REGISTRAR=substr($2,20,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "ca" ];
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $0 != ""  { getline; REGISTRAR=substr($0,24,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "mobi" ];
    then
        REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Updated by Registrar:/ && $2 != "" { REGISTRAR=substr($2,1,17) } END { print REGISTRAR }'`
	if [ "${REGISTRAR}" = "" ]
	then
        	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Sponsoring Registrar:/ && $2 != "" { REGISTRAR=substr($2,1,17) } END { print REGISTRAR }'`
	fi
    elif [ "${TLDTYPE}" == "us" ];
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Sponsoring Registrar:/ && $2 != ""  { REGISTRAR=substr($2,25,17) } END { print REGISTRAR }'`

    elif [ "${TLDTYPE}" == "edu" ]; # added by nixCraft 26-aug-2017
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrant:/ && $0 != ""  { getline;REGISTRAR=substr($0,1,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "cafe" ]; # added by @kode29 26-aug-2017
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $0 != "" { REGISTRAR=substr($0,12,17) } END { print REGISTRAR }'`

    elif [ "${TLDTYPE}" == "link" ]; # added by @kode29 26-aug-2017
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $0 != "" {  REGISTRAR=substr($0,12,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "blog" ]; # added by @kode29 26-aug-2017
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/Registrar:/ && $0 != "" {  REGISTRAR=substr($0,12,17) } END { print REGISTRAR }'`
    elif [ "${TLDTYPE}" == "ru" -o "${TLDTYPE}" == "su" ]; # added 20141113
    then
	REGISTRAR=`cat ${WHOIS_TMP} | ${AWK} -F: '/registrar:/ && $2 != "" { REGISTRAR=substr($2,6,17) } END { print REGISTRAR }'`
    fi

    # If the Registrar is NULL, then we didn't get any data
    if [ "${REGISTRAR}" = "" ]
    then
        prints "$DOMAIN" "Unknown" "Unknown" "Unknown" "Unknown"
        return
    fi

    # The whois Expiration data should resemble the following: "Expiration Date: 09-may-2008"

    if [ "${TLDTYPE}" == "in" ];
    then
	DOMAINDATE=`cat ${WHOIS_TMP} | ${AWK} '/Expiration Date:/ { print $2 }' | ${CUT} -d ':' -f2`
    elif [ "${TLDTYPE}" == "info" -o "${TLDTYPE}" == "org" ];
    then
	    tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Expiry Date:/ { print $4 }'`
            tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
            tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
	       case ${tmon} in
	             1|01) tmonth=jan ;;
	             2|02) tmonth=feb ;;
	             3|03) tmonth=mar ;;
	             4|04) tmonth=apr ;;
	             5|05) tmonth=may ;;
	             6|06) tmonth=jun ;;
	             7|07) tmonth=jul ;;
	             8|08) tmonth=aug ;;
	             9|09) tmonth=sep ;;
	             10) tmonth=oct ;;
	             11) tmonth=nov ;;
	             12) tmonth=dec ;;
               	      *) tmonth=0 ;;
		esac
            tday=`echo ${tdomdate} | ${CUT} -d'-' -f3 | ${CUT} -d'T' -f1`
	    DOMAINDATE=`echo $tday-$tmonth-$tyear`
    elif [ "${TLDTYPE}" == "biz" -o "${TLDTYPE}" == "co" ]; # for .biz and .co domain
    then
            DOMAINDATE=`cat ${WHOIS_TMP} | ${AWK} '/Domain Expiration Date:/ { print $6"-"$5"-"$9 }'`
    elif [ "${TLDTYPE}" == "md" ]; # for .md domain
    then
            tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Expiration date:/ { print $3 }'`
            tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
            tmon=`echo ${tdomdate} | ${CUT} -d'-' -f2`
	       case ${tmon} in
	             1|01) tmonth=jan ;;
	             2|02) tmonth=feb ;;
	             3|03) tmonth=mar ;;
	             4|04) tmonth=apr ;;
	             5|05) tmonth=may ;;
	             6|06) tmonth=jun ;;
	             7|07) tmonth=jul ;;
	             8|08) tmonth=aug ;;
	             9|09) tmonth=sep ;;
	             10) tmonth=oct ;;
	             11) tmonth=nov ;;
	             12) tmonth=dec ;;
              	      *) tmonth=0 ;;
		esac
            tday=`echo ${tdomdate} | ${CUT} -d'-' -f3`
	    DOMAINDATE=`echo $tday-$tmonth-$tyear`
    elif [ "${TLDTYPE}" == "uk" ]; # for .uk domain
    then
            DOMAINDATE=`cat ${WHOIS_TMP} | ${AWK} '/Renewal date:/ || /Expiry date:/ { print $3 }'`
    elif [ "${TLDTYPE}" == "jp" ]; # for .jp 2010/04/30
    then
	    tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Expires on/ { print $3 }'`
            tyear=`echo ${tdomdate} | ${CUT} -d'/' -f1`
            tmon=`echo ${tdomdate} | ${CUT} -d'/' -f2`
	       case ${tmon} in
	             1|01) tmonth=jan ;;
	             2|02) tmonth=feb ;;
	             3|03) tmonth=mar ;;
	             4|04) tmonth=apr ;;
	             5|05) tmonth=may ;;
	             6|06) tmonth=jun ;;
	             7|07) tmonth=jul ;;
	             8|08) tmonth=aug ;;
	             9|09) tmonth=sep ;;
	             10) tmonth=oct ;;
	             11) tmonth=nov ;;
	             12) tmonth=dec ;;
               	      *) tmonth=0 ;;
		esac
            tday=`echo ${tdomdate} | ${CUT} -d'/' -f3`
	    DOMAINDATE=`echo $tday-$tmonth-$tyear`
    elif [ "${TLDTYPE}" == "ca" ]; # for .ca 2010/04/30
    then
	    tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Expiry date/ { print $3 }'`
            tyear=`echo ${tdomdate} | ${CUT} -d'/' -f1`
            tmon=`echo ${tdomdate} | ${CUT} -d'/' -f2`
	       case ${tmon} in
	             1|01) tmonth=jan ;;
	             2|02) tmonth=feb ;;
	             3|03) tmonth=mar ;;
	             4|04) tmonth=apr ;;
	             5|05) tmonth=may ;;
	             6|06) tmonth=jun ;;
	             7|07) tmonth=jul ;;
	             8|08) tmonth=aug ;;
	             9|09) tmonth=sep ;;
	             10) tmonth=oct ;;
	             11) tmonth=nov ;;
	             12) tmonth=dec ;;
               	      *) tmonth=0 ;;
		esac
            tday=`echo ${tdomdate} | ${CUT} -d'/' -f3`
	    DOMAINDATE=`echo $tday-$tmonth-$tyear`
    elif [ "${TLDTYPE}" == "mobi" -o "${TLDTYPE}" == "tv" ]; # for .mobi and .tv
    then
	    if [ "${tdomdate}" = "" ]
	    then
		tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Registry Expiry Date:/ { print $4 }'`
		tyear=`echo ${tdomdate} | ${CUT} -d "-" -f 1`
        	tmon=`echo ${tdomdate} | ${CUT} -d "-" -f 2`
               	  case ${tmon} in
                     1|01) tmonth=jan ;;
                     2|02) tmonth=feb ;;
                     3|03) tmonth=mar ;;
                     4|04) tmonth=apr ;;
                     5|05) tmonth=may ;;
                     6|06) tmonth=jun ;;
                     7|07) tmonth=jul ;;
                     8|08) tmonth=aug ;;
                     9|09) tmonth=sep ;;
                     10) tmonth=oct ;;
                     11) tmonth=nov ;;
                     12) tmonth=dec ;;
                     *) tmonth=0 ;;
                 esac
        	tday=`echo ${tdomdate} | ${CUT} -d "-" -f 3 | ${CUT} -d "T" -f 1`
        	DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`
	    else
	        tyear=`echo ${tdomdate} | ${CUT} -d'-' -f3`
	    	tmon=`echo ${tdomdate} |${CUT} -d'-' -f2`
	    	tmonth=`tolower ${tmon}`
	    	tday=`echo ${tdomdate} | ${CUT} -d'-' -f1`
	    	DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`
	    fi
    elif [ "${TLDTYPE}" == "us" ]; # for .us 2014/08/11
    then
	    tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Expiration Date:/' |${CUT} -d ' ' -f26-`
	    tyear=`echo ${tdomdate} | ${CUT} -d' ' -f5`
	    tmon=`echo ${tdomdate} |${CUT} -d' ' -f1`
	    tmonth=`tolower ${tmon}`
	    tday=`echo ${tdomdate} | ${CUT} -d' ' -f2`
	    DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`
    elif [ "${TLDTYPE}" == "me" ]; # for .me domain
    then
	tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Registry Expiry Date:/ { print $4 }'`
	tyear=`echo ${tdomdate} | ${CUT} -d "-" -f 1`
	tmon=`echo ${tdomdate} | ${CUT} -d "-" -f 2`
               case ${tmon} in
                     1|01) tmonth=jan ;;
                     2|02) tmonth=feb ;;
                     3|03) tmonth=mar ;;
                     4|04) tmonth=apr ;;
                     5|05) tmonth=may ;;
                     6|06) tmonth=jun ;;
                     7|07) tmonth=jul ;;
                     8|08) tmonth=aug ;;
                     9|09) tmonth=sep ;;
                     10) tmonth=oct ;;
                     11) tmonth=nov ;;
                     12) tmonth=dec ;;
                     *) tmonth=0 ;;
               esac
	tday=`echo ${tdomdate} | ${CUT} -d "-" -f 3 | ${CUT} -d "T" -f 1`
	DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`
    elif [ "${TLDTYPE}" == "ru" -o "${TLDTYPE}" == "su" ]; # for .ru and .su 2014/11/13
    then
           tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/paid-till:/ { print $2 }'`
           tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
           tmon=`echo ${tdomdate} |${CUT} -d'-' -f2`
	       case ${tmon} in
	             1|01) tmonth=jan ;;
	             2|02) tmonth=feb ;;
	             3|03) tmonth=mar ;;
	             4|04) tmonth=apr ;;
	             5|05) tmonth=may ;;
	             6|06) tmonth=jun ;;
	             7|07) tmonth=jul ;;
	             8|08) tmonth=aug ;;
	             9|09) tmonth=sep ;;
	             10) tmonth=oct ;;
	             11) tmonth=nov ;;
	             12) tmonth=dec ;;
	             *) tmonth=0 ;;
	       esac
	   tday=`echo ${tdomdate} | ${CUT} -d "-" -f 3 | ${CUT} -d "T" -f 1`
           DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`
    elif [ "${TLDTYPE}" == "com" -o "${TLDTYPE}" == "net" -o "${TLDTYPE}" == "org"  -o "${TLDTYPE}" == "link" -o "${TLDTYPE}" == "blog" -o "${TLDTYPE}" == "cafe" ]; # added on 26-aug-2017 by nixCraft {https://www.cyberciti.biz/}
    then
           tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Registry Expiry Date:/ { print $NF }'`
           tyear=`echo ${tdomdate} | ${CUT} -d'-' -f1`
           tmon=`echo ${tdomdate} |${CUT} -d'-' -f2`
	       case ${tmon} in
	             1|01) tmonth=jan ;;
	             2|02) tmonth=feb ;;
	             3|03) tmonth=mar ;;
	             4|04) tmonth=apr ;;
	             5|05) tmonth=may ;;
	             6|06) tmonth=jun ;;
	             7|07) tmonth=jul ;;
	             8|08) tmonth=aug ;;
	             9|09) tmonth=sep ;;
	             10) tmonth=oct ;;
	             11) tmonth=nov ;;
	             12) tmonth=dec ;;
	             *) tmonth=0 ;;
	       esac
	   tday=`echo ${tdomdate} | ${CUT} -d "-" -f 3 | ${CUT} -d "T" -f 1`
           DOMAINDATE=`echo "${tday}-${tmonth}-${tyear}"`
    elif [ "${TLDTYPE}" == "edu" ] # added on 26-aug-2017 by nixCraft
    then
           tdomdate=`cat ${WHOIS_TMP} | ${AWK} '/Domain expires:/ { print $NF }'`
	   echo $tomdate
           tyear=`echo ${tdomdate} | ${CUT} -d'-' -f3`
           tmon=`echo ${tdomdate} |${CUT} -d'-' -f2`
	       case ${tmon} in
	             1|01) tmonth=jan ;;
	             2|02) tmonth=feb ;;
	             3|03) tmonth=mar ;;
	             4|04) tmonth=apr ;;
	             5|05) tmonth=may ;;
	             6|06) tmonth=jun ;;
	             7|07) tmonth=jul ;;
	             8|08) tmonth=aug ;;
	             9|09) tmonth=sep ;;
	             10) tmonth=oct ;;
	             11) tmonth=nov ;;
	             12) tmonth=dec ;;
	             *) tmonth=0 ;;
	       esac
	   tday=`echo ${tdomdate} | ${CUT} -d "-" -f 1`
           DOMAINDATE=`echo "${tday}-${tmon}-${tyear}"`
    else # may work with others	 ??? ;)  
 	   DOMAINDATE=`cat ${WHOIS_TMP} | ${AWK} '/Expiration/ { print $NF }'`	
    fi

    #echo $DOMAINDATE # debug 
    # Whois data should be in the following format: "13-feb-2006"
    IFS="-"
    set -- ${DOMAINDATE}
    MONTH=$(getmonth ${2})
    IFS=""

    # Convert the date to seconds, and get the diff between NOW and the expiration date
    DOMAINJULIAN=$(date2julian ${MONTH} ${1#0} ${3})
    DOMAINDIFF=$(date_diff ${NOWJULIAN} ${DOMAINJULIAN})

    if [ ${DOMAINDIFF} -lt 0 ]
    then
          if [ "${ALARM}" == "TRUE" ]
          then
                echo "The domain ${DOMAIN} has expired!" \
                | ${MAIL} -s "Domain ${DOMAIN} has expired!" ${ADMIN}
           fi

           prints "${DOMAIN}" "Expired" "${DOMAINDATE}" "${DOMAINDIFF}" "${REGISTRAR}"

    elif [ ${DOMAINDIFF} -lt ${WARNDAYS} ]
    then
           if [ "${ALARM}" == "TRUE" ]
           then
                    echo "The domain ${DOMAIN} will expire on ${DOMAINDATE}" \
                    | ${MAIL} -s "Domain ${DOMAIN} will expire in ${WARNDAYS}-days or less" ${ADMIN}
            fi
            prints "${DOMAIN}" "Expiring" "${DOMAINDATE}" "${DOMAINDIFF}" "${REGISTRAR}"
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
                printf "\n%-35s %-46s %-8s %-11s %-5s\n" "Domain" "Registrar" "Status" "Expires" "Days Left"
                echo "----------------------------------- ---------------------------------------------- -------- ----------- ---------"
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
            MIN_DATE=$(echo $3 | ${AWK} '{ print $1, $2, $4 }')
            printf "%-35s %-46s %-8s %-11s %-5s\n" "$1" "$5" "$2" "$MIN_DATE" "$4"
    fi
}

##########################################
# Purpose: Describe how the script works
# Arguments:
#   None
##########################################
usage()
{
        echo "Usage: $0 [ -e email ] [ -x expir_days ] [ -q ] [ -a ] [ -h ]"
        echo "          {[ -d domain_namee ]} || { -f domainfile}"
        echo ""
        echo "  -a               : Send a warning message through email "
        echo "  -d domain        : Domain to analyze (interactive mode)"
        echo "  -e email address : Email address to send expiration notices"
        echo "  -f domain file   : File with a list of domains"
        echo "  -h               : Print this screen"
        echo "  -s whois server  : Whois sever to query for information"
        echo "  -q               : Don't print anything on the console"
        echo "  -x days          : Domain expiration interval (eg. if domain_date < days)"
        echo ""
}

### Evaluate the options passed on the command line
while getopts ae:f:hd:s:qx: option
do
        case "${option}"
        in
                a) ALARM="TRUE";;
                e) ADMIN=${OPTARG};;
                d) DOMAIN=${OPTARG};;
                f) SERVERFILE=$OPTARG;;
                s) WHOIS_SERVER=$OPTARG;;
                q) QUIET="TRUE";;
                x) WARNDAYS=$OPTARG;;
                \?) usage
                    exit 1;;
        esac
done

### Check to see if the whois binary exists
if [ ! -f ${WHOIS} ]
then
        echo "ERROR: The whois binary does not exist in ${WHOIS} ."
        echo "  FIX: Please modify the \$WHOIS variable in the program header."
        exit 1
fi

### Check to make sure a date utility is available
if [ ! -f ${DATE} ]
then
        echo "ERROR: The date binary does not exist in ${DATE} ."
        echo "  FIX: Please modify the \$DATE variable in the program header."
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
        while read DOMAIN
        do
                check_domain_status "${DOMAIN}"

        done < ${SERVERFILE}

### There was an error, so print a detailed usage message and exit
else
        usage
        exit 1
fi

# Add an extra newline
echo

### Remove the temporary files
rm -f ${WHOIS_TMP}

### Exit with a success indicator
exit 0

