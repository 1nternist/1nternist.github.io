#!/bin/sh

#############################################################
# Hosts Cleaner Script: 				    #
# Say goodbye to ads, spies, tracking and untrusted hosts.  #
#							    #
#***********************************************************#
# ----------------- Updated: May-05-2015 ------------------ #
#***********************************************************#
#							    #
# Thanks winhelp2002 & 0th3lo for their work. I also added  #
# some hosts from my personnal iOS and MacOS experience.    #
#							    #
# This MVPS HOSTS file is a free download from: 	    #
# http://winhelp2002.mvps.org/hosts.htm 		    #
#							    #
# Notes: The Operating System does not read the "#" symbol  #
# You can create your own notes, after the # symbol	    #
# This *must* be the first line: 127.0.0.1     localhost    #
#							    #
#***********************************************************#
#							    #
# Disclaimer: this file is free to use for personal use     #
# only. Furthermore it is NOT permitted to copy any of the  #
# contents or host on any other site without permission or  #
# meeting the full criteria of the below license terms.     #
#							    #
# This work is licensed under the Creative Commons	    #
# Attribution-NonCommercial-ShareAlike License. 	    #
# http://creativecommons.org/licenses/by-nc-sa/4.0/	    #
#							    #
# Entries with comments are all searchable via Google.	    #
#							    #
# http://repo.thireus.com				    #
# © 2014 Thireus Repository. All Rights Reserved.	    #
#############################################################

#####################
##### root test #####
#####################

[ `id -u` != 0 ] && exec echo "Oops, you need to be root to run this script"

#####################
### begin script  ###
#####################

MD5SUM=$(md5sum /etc/hosts | cut -d' ' -f 1)

if [ ! -e /etc/hosts ]
then
	echo 'WARNING NO HOSTS FILE FOUND'
	echo
echo 'RESTORING THE DEFAULT /etc/hosts'
echo '##' > /etc/hosts
echo '# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1	 localhost
255.255.255.255  broadcasthost
::1		 localhost
fe80::1%lo0	 localhost

########################
## Personal Redirects ##
########################

127.0.0.1 cydia.mirepo.com

' >> /etc/hosts
else
	echo 'HOSTS FILE FOUND'
	if [ -e /etc/hosts.reset.md5 ] && [[ "$(cat /etc/hosts.reset.md5)" == "$MD5SUM" ]] && [ -e /etc/hosts.reset.bak ]; then
		echo 'NO CHANGES DETECTED SINCE LAST INSTALLATION' && \
		rm -rf /etc/hosts && \
		mv -f /etc/hosts.reset.bak /etc/hosts && \
		echo 'BACKUP FILE RESTORED'
	else
		echo 'PLEASE WAIT!!!!! (removal can take up to 3 minutes)' && \
		sed -n -e '/## START_UTHB_HOSTS ##/{' -e 'p' -e ':a' -e 'N' -e '/## END_UTHB_HOSTS ##/!ba' -e 's/.*\n//' -e '}' -e 'p' /etc/hosts | grep -v '## START_UTHB_HOSTS ##' | grep -v '## END_UTHB_HOSTS ##' > /etc/hosts.reset.tmp && \
		mv -f /etc/hosts.reset.tmp /etc/hosts
	fi
	if [ -e /etc/hosts.uthb.md5 ] && [[ "$(cat /etc/hosts.uthb.md5)" == "$MD5SUM" ]] && [ -e /etc/hosts.uthb.bak ]; then
		echo 'NO CHANGES DETECTED SINCE LAST INSTALLATION' && \
		rm -rf /etc/hosts && \
		mv -f /etc/hosts.uthb.bak /etc/hosts && \
		echo 'BACKUP FILE RESTORED'
	else
		echo 'PLEASE WAIT!!!!! (removal can take up to 3 minutes)' && \
		sed -n -e '/## START_UTHB_HOSTS ##/{' -e 'p' -e ':a' -e 'N' -e '/## END_UTHB_HOSTS ##/!ba' -e 's/.*\n//' -e '}' -e 'p' /etc/hosts | grep -v '## START_UTHB_HOSTS ##' | grep -v '## END_UTHB_HOSTS ##' > /etc/hosts.uthb.tmp && \
		mv -f /etc/hosts.uthb.tmp /etc/hosts
	fi
	if [ -e /etc/hosts.uthblt.md5 ] && [[ "$(cat /etc/hosts.uthblt.md5)" == "$MD5SUM" ]] && [ -e /etc/hosts.uthblt.bak ]; then
		echo 'NO CHANGES DETECTED SINCE LAST INSTALLATION' && \
		rm -rf /etc/hosts && \
		mv -f /etc/hosts.uthblt.bak /etc/hosts && \
		echo 'BACKUP FILE RESTORED'
	else
		echo 'PLEASE WAIT!!!!! (removal can take up to 3 minutes)' && \
		sed -n -e '/## START_UTHB_HOSTS ##/{' -e 'p' -e ':a' -e 'N' -e '/## END_UTHB_HOSTS ##/!ba' -e 's/.*\n//' -e '}' -e 'p' /etc/hosts | grep -v '## START_UTHB_HOSTS ##' | grep -v '## END_UTHB_HOSTS ##' > /etc/hosts.uthblt.tmp && \
		mv -f /etc/hosts.uthblt.tmp /etc/hosts
	fi
fi

echo 'FYI YOU NOW BLOCK '$(cat /etc/hosts | grep ^"0.0.0.0" | wc -l | sed 's/ *//')' HOSTS' && \
ls -l /etc/hosts

echo 'RESTORE COMPLETE'
