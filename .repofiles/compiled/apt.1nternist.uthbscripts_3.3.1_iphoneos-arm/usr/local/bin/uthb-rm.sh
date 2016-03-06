#!/bin/sh

#############################################################
# Untrusted Hosts Blocker removal script:		    #
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
###### Colors #######
#####################

R=$(tput bold; tput setaf 1)
G=$(tput bold; tput setaf 2)
Y=$(tput bold; tput setaf 3)
Pl=$(tput bold; tput setaf 4)
Pk=$(tput bold; tput setaf 5)
Cn=$(tput bold; tput setaf 6)
r=$(tput setaf 1)
g=$(tput setaf 2)
y=$(tput setaf 3)
pl=$(tput setaf 4)
pk=$(tput setaf 5)
cn=$(tput setaf 6)
bld=$(tput bold)
b=$(tput sgr0)

#####################
### begin script  ###
#####################

echo 'FYI: YOU CURRENTLY BLOCK '$(cat /etc/hosts | grep ^"0.0.0.0" | wc -l | sed 's/ *//')' HOSTS'

MD5SUM=$(md5sum /etc/hosts | cut -d' ' -f 1)

echo 'REMOVING UTHB HOSTS ENTRIES' && \
if [ -e /etc/hosts.uthb.md5 ] && [[ "$(cat /etc/hosts.uthb.md5)" == "$MD5SUM" ]] && [ -e /etc/hosts.uthb.bak ]; then
	echo 'NO CHANGES DETECTED SINCE LAST INSTALLATION' && \
	mv -f /etc/hosts.uthb.bak /etc/hosts && \
	echo 'BACKUP FILE RESTORED'
else
	echo 'PLEASE WAIT!!!!! (removal can take up to 3 minutes)' && \
	sed -n -e '/## START_UTHB_HOSTS ##/{' -e 'p' -e ':a' -e 'N' -e '/## END_UTHB_HOSTS ##/!ba' -e 's/.*\n//' -e '}' -e 'p' /etc/hosts | grep -v '## START_UTHB_HOSTS ##' | grep -v '## END_UTHB_HOSTS ##' > /etc/hosts.uthb.tmp && \
	mv -f /etc/hosts.uthb.tmp /etc/hosts
	
	echo 'REMOVING BACKUP FILE' && \
	if [ ! -e /etc/hosts.uthb.bak ]
	then
		echo 'WARNING NO BACKUP HOSTS FILE FOUND (/etc/hosts.uthb.bak)'
	else
		rm -f /etc/hosts.uthb.bak && \
		echo 'BACKUP FILE REMOVED'
	fi
fi

echo 'FYI YOU NOW BLOCK '$(cat /etc/hosts | grep ^"0.0.0.0" | wc -l | sed 's/ *//')' HOSTS' && \
ls -l /etc/hosts

echo 'REMOVING MD5SUM FILE' && \
rm -f /etc/hosts.uthb.md5

if [[ -n $(ps aux | grep 'discoveryd' | grep ^_mdnsresponder) ]]
then
	echo 'RESTARTING discoveryd'
	# FIX CPU 100% AFTER THE INSTALL
	killall discoveryd && echo 'discoveryd RESTARTED'
fi

echo 'UTHB ENTRIES REMOVED SUCCESSFULLY.'
