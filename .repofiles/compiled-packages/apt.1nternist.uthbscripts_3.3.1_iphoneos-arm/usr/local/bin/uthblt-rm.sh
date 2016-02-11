#!/bin/sh

#############################################################
# Untrusted Hosts Blocker Lite removal script:		    #
# Say goodbye to ads, spies, tracking and untrusted hosts.  #
#							    #
#***********************************************************#
# ----------------- Updated: Nov-04-2014 ------------------ #
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

echo 'FYI YOU CURRENTLY BLOCK '$(cat /etc/hosts | grep ^"0.0.0.0" | wc -l | sed 's/ *//')' HOSTS'

MD5SUM=$(md5sum /etc/hosts | cut -d' ' -f 1)

echo 'REMOVING UTHB HOSTS ENTRIES' && \
if [ -e /etc/hosts.uthblt.md5 ] && [[ "$(cat /etc/hosts.uthblt.md5)" == "$MD5SUM" ]] && [ -e /etc/hosts.uthblt.bak ]; then
	echo 'NO CHANGES DETECTED SINCE LAST INSTALLATION' && \
	mv -f /etc/hosts.uthblt.bak /etc/hosts && \
	echo 'BACKUP FILE RESTORED'
else
	echo 'PLEASE WAIT!!!!! (removal can take up to 3 minutes)' && \
	sed -n -e '/## START_UTHB_HOSTS ##/{' -e 'p' -e ':a' -e 'N' -e '/## END_UTHB_HOSTS ##/!ba' -e 's/.*\n//' -e '}' -e 'p' /etc/hosts | grep -v '## START_UTHB_HOSTS ##' | grep -v '## END_UTHB_HOSTS ##' > /etc/hosts.uthblt.tmp && \
	mv -f /etc/hosts.uthblt.tmp /etc/hosts
	
	echo 'REMOVING BACKUP FILE' && \
	if [ ! -e /etc/hosts.uthblt.bak ]
	then
		echo 'WARNING NO BACKUP HOSTS FILE FOUND (/etc/hosts.uthblt.bak)'
	else
		rm -f /etc/hosts.uthblt.bak && \
		echo 'BACKUP FILE REMOVED'
	fi
fi

echo 'FYI YOU NOW BLOCK '$(cat /etc/hosts | grep ^"0.0.0.0" | wc -l | sed 's/ *//')' HOSTS' && \
ls -l /etc/hosts

echo 'REMOVING MD5SUM FILE' && \
rm -f /etc/hosts.uthblt.md5

if [[ -n $(ps aux | grep 'discoveryd' | grep ^_mdnsresponder) ]]
then
	echo 'RESTARTING discoveryd'
	# FIX CPU 100% AFTER THE INSTALL
	killall discoveryd && echo 'discoveryd RESTARTED'
fi

echo 'UTHBLT ENTRIES REMOVED SUCCESSFULLY'
