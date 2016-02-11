#!/bin/bash

#############################################################
# Hosts Cleaner Script:                                     #
# Say goodbye to ads, spies, tracking and untrusted hosts.  #
#                                                           #
#***********************************************************#
# ----------------- Updated: May-05-2015 ------------------ #
#***********************************************************#
#                                                           #
# Thanks winhelp2002 & 0th3lo for their work. I also added  #
# some hosts from my personnal iOS and MacOS experience.    #
#                                                           #
# This MVPS HOSTS file is a free download from:             #
# http://winhelp2002.mvps.org/hosts.htm                     #
#                                                           #
# Notes: The Operating System does not read the "#" symbol  #
# You can create your own notes, after the # symbol         #
# This *must* be the first line: 127.0.0.1     localhost    #
#                                                           #
#***********************************************************#
#                                                           #
# Disclaimer: this file is free to use for personal use     #
# only. Furthermore it is NOT permitted to copy any of the  #
# contents or host on any other site without permission or  #
# meeting the full criteria of the below license terms.     #
#                                                           #
# This work is licensed under the Creative Commons          #
# Attribution-NonCommercial-ShareAlike License.             #
# http://creativecommons.org/licenses/by-nc-sa/4.0/         #
#                                                           #
# Entries with comments are all searchable via Google.      #
#                                                           #
# http://repo.thireus.com                                   #
# © 2014 Thireus Repository. All Rights Reserved.           #
#############################################################

#####################
##### root test #####
#####################

[ `id -u` != 0 ] && exec echo "Oops, you need to be root to run this script"

#####################
### begin script  ###
#####################

echo 'REMOVING BACKUP FILE' && \
if [ ! -e /etc/hosts.reset.bak ]
then
        echo 'WARNING NO RESET BACKUP HOSTS FILE FOUND (/etc/hosts.reset.bak)'
else
        rm -f /etc/hosts.reset.bak && \
        echo 'BACKUP FILE REMOVED'
fi
if [ ! -e /etc/hosts.uthb.bak ]
then
        echo 'WARNING NO UTHB BACKUP HOSTS FILE FOUND (/etc/hosts.uthb.bak)'
else
        rm -f /etc/hosts.uthb.bak && \
        echo 'BACKUP FILE REMOVED'
fi
if [ ! -e /etc/hosts.uthblt.bak ]
then
        echo 'WARNING NO UTHBLT BACKUP HOSTS FILE FOUND (/etc/hosts.uthblt.bak)'
else
        rm -f /etc/hosts.uthblt.bak && \
        echo 'BACKUP FILE REMOVED'
fi

echo 'UNINSTALLED'
