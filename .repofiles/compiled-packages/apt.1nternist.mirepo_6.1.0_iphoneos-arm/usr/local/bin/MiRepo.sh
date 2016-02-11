#!/bin/bash

## MiRepo v6
## Written by Markus McCormac (Chir0student) <chir0student@me.com>
## March 1st 2014
## http://chir0student.myrepospace.com

##
## Main executable script for MiRepo
##

## Colors ##

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

## Shortcuts ##

TEMP="`mktemp -d -t mirepo-XXXX`"
REPOROOT="/var/root/Library"
MIREPO="$REPOROOT"/MiRepo
DEBDROP="$MIREPO"/debdrop
BLDDIR="$MIREPO"/build
DISTDIR="$MIREPO"/debs
NEWDEBS="$MIREPO"/imported
BACKUPDIR="$MIREPO"/backup
LOGDIR="$MIREPO"/logs
WWW="/var/www"
REPO="$WWW"/repo
CYDIA="$REPO"/debs
CMPL="$REPO"/uncompiled-packages
DPKG_INFO="/var/lib/dpkg/info"
MY_PWD="`pwd`"
SCANLOG="$TEMP"/scanlog.log
BLDLOG="$TEMP"/bldlog.log
IMLOG="$TEMP"/imlog.log
DXLOG="$TEMP"/dxlog.log
OPT1="Import debs into debdrop directory."
OPT2="Unpack debs into build directory."
OPT3="Refresh Repository."
OPT4="Import All."
OPT5="Select debs to import."
OPT6="Continue using MiRepo."
OPT7="Main Menu."
OPT8="Delete all debs."
OPT9="Select individually."
OPT10="Just list them."
IM1="com.philippe97.apptodeb"
IM2="com.philippe97.debmaker"
IM3="org.thebigboss.ideb"
IMSRC1="AppToDeb"
IMSRC2="DebMaker"
IMSRC3="iDeb"
IMSRC4="Downloads"
IMSRC5="APT Cache (Cydia downloads)"
IMSRC6="List/Delete debs in DebDrop directory"
IMPTH1="/var/root/Library/AppToDeb/repacked"
IMPTH2="/var/root/Library/DebMaker/debs"
IMPTH3="/Library/iDeb/Debs"
IMPTH4="/var/mobile/Media/Downloads"
IMPTH5="/var/cache/apt/archives"
IMPTH6="/var/mobile/Documents/repo/debdrop"
IMDLDIR=$(ls "$IMPTH4")
IMAPT=$(ls "$IMPTH5")
DASH="-------------------------------------------------"

#################################
#####	 Extra Functions    #####
#################################

function testroot () {
if [ `id -u` != 0 ]; then
	echo "Oops, you need to be root to run this script"
	sleep 1
	clear
	exit 0
fi
}


function mainmenuloop () {
	mainmenu
}


function imwelcomeloop () {
	imwelcome
}

#################################
#####	    debXpandr	    #####
#################################


function debXpandr () {
for i in `ls *.deb`; do
	WORK_DIR=`echo "${i%%/}" | sed "s/....$//"`
	if [ -d "$WORK_DIR" ]; then
		rm -rf "$WORK_DIR";
		mkdir -p "$WORK_DIR"/DEBIAN
	else
		mkdir -p "$WORK_DIR"/DEBIAN
	fi
	dpkg-deb --control "${i%%/}" "$WORK_DIR"/DEBIAN
	dpkg-deb --extract "${i%%/}" "$WORK_DIR"
done
}

function dxwelcome () {
	clear
	echo
	echo "Welcome to debXpandr."
	sleep 0.5
	echo "Processing debs, please be patient."
	echo
	clear
	cd "$DEBDROP"
	echo
	echo "Fixing any misformated package names"
	sleep 0.5
	rm -rf "$BACKUPDIR"/*.deb
	for i in `ls *.deb`; do
		dpkg-name "${i%%/}"
	done
	for i in `ls *.deb`; do
		cp "$DEBDROP"/"${i%%/}" "$BLDDIR"/"${i%%/}"
		cp "$DEBDROP"/"${i%%/}" "$BACKUPDIR"/"${i%%/}"
		wait
		rm -rf "$DEBDROP"/"${i%%/}"
	done
	clear
	cd "$BLDDIR"
	echo
	echo "Executing debXpandr"
	echo
	debXpandr
	wait
	rm -rf "$BLDDIR"/*.deb
	wait
	clear
	mainmenuloop
}


#################################
#####	 Import Function    #####
#################################


function importls () {
	dpkg --get-selections | awk '{ print $1 }' >"$TEMP"/iminstalled.mirepo
	cat "$TEMP"/iminstalled.mirepo | sort | uniq >"$TEMP"/immylist.mirepo
	ARC1=$(cat "$TEMP"/immylist.mirepo | grep -i "$IM1")
	if [ "$ARC1" == "com.philippe97.apptodeb" ]; then
		echo "$IMSRC1" >"$TEMP"/iminstalled.mirepo
	fi
	ARC2=$(cat "$TEMP"/immylist.mirepo | grep -i "$IM2")
	if [ "$ARC2" == "com.philippe97.debmaker" ]; then
		echo "$IMSRC2" >>"$TEMP"/iminstalled.mirepo
	fi
	ARC3=$(cat "$TEMP"/immylist.mirepo | grep -i "$IM3")
	if [ "$ARC3" == "org.thebigboss.ideb" ]; then
		echo "$IMSRC3" >>"$TEMP"/iminstalled.mirepo
	fi
	ls "$IMPTH4" | grep deb | cut -d '/' -f6 | sort | uniq >"$TEMP"/imdownloads.mirepo
	ARC4=$(cat "$TEMP"/imdownloads.mirepo)
	if [ -n "$ARC4" ]; then
		echo "$IMSRC4" >>"$TEMP"/iminstalled.mirepo
	fi
	ls "$IMPTH5" | grep deb | cut -d '/' -f6 | sort | uniq >"$TEMP"/imapt.mirepo
	ARC5=$(cat "$TEMP"/imapt.mirepo)
	if [ -n "$ARC5" ]; then
		echo "$IMSRC5" >>"$TEMP"/iminstalled.mirepo
	fi
	ls "$DEBDROP" | grep deb | cut -d '/' -f6 | sort | uniq >"$TEMP"/imdebdrop.mirepo
	ARC6=$(cat "$TEMP"/imdebdrop.mirepo)
	if [ -n "$ARC6" ]; then
		echo "$IMSRC6" >>"$TEMP"/iminstalled.mirepo
	fi
}


function imatd () {
	cd "$IMPTH1"
	for i in `ls *.deb`
	do
		cp "$IMPTH1"/"${i%%/}" "$DEBDROP"/"${i%%/}"
	done
	imwelcomeloop
}


function imatddebs () {
	atdlist=(`cat "$TEMP"/imatdchoice.mirepo`)
	if [ -n $(echo "$atdlist" | wc -l) ]; then
		for i in `cat "$TEMP"/imatdchoice.mirepo`
		do
			cp "$IMPTH1"/"${i%%/}" "$DEBDROP"/"${i%%/}"
		done
	fi
	imwelcomeloop
}


function imatdmenuitems () {
	atdfiles=(`ls *.deb`)
	echo "Avaliable options:"
	for i in ${!atdfiles[@]}
	do
		printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${atdfiles[i]}"
	done
	[[ "$msg" ]] && echo "$msg"; :
}


function imatdmenu () {
	atdprompt="Enter an option (enter again to uncheck, press RETURN when done): "
	while imatdmenuitems && read -rp "$atdprompt" num && [[ "$num" ]]
	do
		[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#atdfiles[@]} )) || {
			msg="Invalid option: $num"
			continue
		}
		((num--)); msg="${atdfiles[num]} was ${choices[num]:+un-}selected"
		[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
	done
	printf "\nYou selected\n\n"; msg=""
	for i in ${!atdfiles[@]}
	do
		[[ "${choices[i]}" ]] && { printf "%s\n" "${atdfiles[i]}"; msg=""; } >> "$TEMP"/imatdchoice.mirepo
	done
	if [ -e "$TEMP"/imatdchoice.mirepo ]; then
		for i in `cat "$TEMP"/imatdchoice.mirepo`
		do
			echo "${i%%/}"
		done
		imatddebs
	else
		imwelcomeloop
	fi
}


function imdm () {
	cd "$IMPTH2"
	for i in `ls *.deb`
	do
		cp "$IMPTH2"/"${i%%/}" "$DEBDROP"/"${i%%/}"
	done
	imwelcomeloop
}


function imdmimport () {
	dmlist=(`cat "$TEMP"/imdmchoice.mirepo`)
	if [ -n $(echo "$dmlist" | wc -l) ]; then
		for i in `cat "$TEMP"/imdmchoice.mirepo`; do
			cp "$IMPTH2"/"${i%%/}" "$DEBDROP"/"${i%%/}"
		done
	fi
	imwelcomeloop
}


function imdmmenuitems () {
	dmfiles=(`ls *.deb`)
	echo "Avaliable options:"
	for i in ${!dmfiles[@]}
	do
		printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${dmfiles[i]}"
	done
	[[ "$msg" ]] && echo "$msg"; :
}


function imdmmenuprompt () {
	dmprompt="Enter an option (enter again to uncheck, press RETURN when done): "
	while imdmmenuitems && read -rp "$dmprompt" num && [[ "$num" ]]
	do
		[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#dmfiles[@]} )) || {
			msg="Invalid option: $num"
			continue
		}
		((num--)); msg="${dmfiles[num]} was ${choices[num]:+un-}selected"
		[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
	done
	printf "\nYou selected\n\n"; msg=""
	for i in ${!dmfiles[@]}
	do
		[[ "${choices[i]}" ]] && { printf "%s\n" "${dmfiles[i]}"; msg=""; } >> "$TEMP"/imdmchoice.mirepo
	done
	if [ -e "$TEMP"/imdmchoice.mirepo ]; then
		for i in `cat "$TEMP"/imdmchoice.mirepo`
		do
			echo "${i%%/}"
		done
		imdmimport
	else
		imwelcomeloop
	fi
}


function imidebim () {
	cd "$IMPTH3"
	for i in `ls *.deb`
	do
		cp "$IMPTH3"/"${i%%/}" "$DEBDROP"/"${i%%/}"
	done
	imwelcomeloop
}


function imidebimdeb () {
	ideblist=(`cat "$TEMP"/imidebchoice.mirepo`)
	if [ -n $(echo "$ideblist" | wc -l) ]; then
		for i in `cat "$TEMP"/imidebchoice.mirepo`
		do
			cp "$IMPTH3"/"${i%%/}" "$DEBDROP"/"${i%%/}"
		done
	fi
	imwelcomeloop
}


function imidebmenuitems () {
	idebfiles=(`ls *.deb`)
	echo "Avaliable options:"
	for i in ${!idebfiles[@]}
	do
		printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${idebfiles[i]}"
	done
	[[ "$msg" ]] && echo "$msg"; :
}


function imidebmenuprompt () {
	idebprompt="Enter an option (enter again to uncheck, press RETURN when done): "
	while imidebmenuitems && read -rp "$idebprompt" num && [[ "$num" ]]
	do
		[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#idebfiles[@]} )) || {
			msg="Invalid option: $num"
			continue
		}
		((num--)); msg="${idebfiles[num]} was ${choices[num]:+un-}selected"
		[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
	done
	printf "\nYou selected\n\n"; msg=""
	for i in ${!idebfiles[@]}
	do
		[[ "${choices[i]}" ]] && { printf "%s\n" "${idebfiles[i]}"; msg=""; } >> "$TEMP"/imidebchoice.mirepo
	done
	if [ -e "$TEMP"/imidebchoice.mirepo ]; then
		for i in `cat "$TEMP"/imidebchoice.mirepo`
		do
			echo "${i%%/}"
		done
		imidebimdeb
	else
		imwelcomeloop
	fi
}


function imdnldim () {
	cd "$IMPTH4"
	for i in `ls *.deb`
	do
		cp "$IMPTH4"/"${i%%/}" "$DEBDROP"/"${i%%/}"
	done
	imwelcomeloop
}


function imdnlddebim () {
	dnldlist=(`cat "$TEMP"/imdnldchoice.mirepo`)
	if [ -n $(echo "$dnldlist" | wc -l) ]; then
		for i in `cat "$TEMP"/imdnldchoice.mirepo`
		do
			cp "$IMPTH4"/"${i%%/}" "$DEBDROP"/"${i%%/}"
		done
	fi
	imwelcomeloop
}


function imdnldmenuitems () {
	dnldfiles=(`ls *.deb`)
	echo "Avaliable options: "
	for i in ${!dnldfiles[@]}
	do
		printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${dnldfiles[i]}"
	done
	[[ "$msg" ]] && echo "$msg"; :
}


function imdnldmenuprompt () {
	dnldprompt="Enter an option (enter again to uncheck, press RETURN when done): "
	while imdnldmenuitems && read -rp "$dnldprompt" num && [[ "$num" ]]
	do
		[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#dnldfiles[@]} )) || {
			msg="Invalid option: $num"
			continue
		}
		((num--)); msg="${dnldfiles[num]} was ${choices[num]:+un-}selected"
		[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
	done
	printf "\nYou selected\n\n"; msg=""
	for i in ${!dnldfiles[@]}
	do
		[[ "${choices[i]}" ]] && { printf "%s\n" "${dnldfiles[i]}"; msg=""; } >> "$TEMP"/imdnldchoice.mirepo
	done
	if [ -e "$TEMP"/imdnldchoice.mirepo ]; then
		for i in `cat "$TEMP"/imdnldchoice.mirepo`
		do
			echo "${i%%/}"
		done
		imdnlddebim
	else
		imwelcomeloop
	fi
}


function imaptim () {
	cd "$IMPTH5"
	for i in `ls *.deb`
	do
		cp "$IMPTH5"/"${i%%/}" "$DEBDROP"/"${i%%/}"
	done
	echo
	imwelcomeloop
}


function imaptdebim () {
	aptlist=(`cat "$TEMP"/imaptchoice.mirepo`)
	if [ -n $(echo "$aptlist" | wc -l) ]; then
		for i in `cat "$TEMP"/imaptchoice.mirepo`
		do
			cp "$IMPTH5"/"${i%%/}" "$DEBDROP"/"${i%%/}"
		done
	fi
	imwelcomeloop
}


function imaptmenuitems () {
	aptfiles=(`ls *.deb`)
	echo "Avaliable options:"
	for i in ${!aptfiles[@]}
	do
		printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${aptfiles[i]}"
	done
	[[ "$msg" ]] && echo "$msg"; :
}


function imaptmenuprompt () {
	aptprompt="Enter an option (enter again to uncheck, press RETURN when done): "
	while imaptmenuitems && read -rp "$aptprompt" num && [[ "$num" ]]
	do
		[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#aptfiles[@]} )) || {
			msg="Invalid option: $num"
			continue
		}
		((num--)); msg="${aptfiles[num]} was ${choices[num]:+un-}selected"
		[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
	done
	printf "\nYou selected\n\n"; msg=""
	for i in ${!aptfiles[@]}
	do
		[[ "${choices[i]}" ]] && { printf "%s\n" "${aptfiles[i]}"; msg=""; } >> "$TEMP"/imaptchoice.mirepo
	done
	if [ -e "$TEMP"/imaptchoice.mirepo ]; then
		for i in `cat "$TEMP"/imaptchoice.mirepo`
		do
			echo "${i%%/}"
		done
		imaptdebim
	else
		imwelcomeloop
	fi
}


function imddls () {
	ls "$DEBDROP" | grep deb | sort | uniq > "$TEMP"/imddls.mirepo
	if [ -e "$TEMP"/imddls.mirepo ]; then
		echo "`cat "$TEMP"/imddls.mirepo`"
	fi
}


function imddrm () {
	cd "$DEBDROP"
	for i in `ls *.deb`
	do
		rm -rf "${i%%/}"
	done
	cd -
}


function imdddel () {
	ddlist=(`cat "$TEMP"/imddchoice.mirepo`)
	if [ -n $(echo "$ddlist" | wc -l) ]; then
		for i in `cat "$TEMP"/imddchoice.mirepo`
		do
			rm -rf "$DEBDROP"/"${i%%/}"
		done
	fi
	imwelcomeloop
}


function imddmenuitems () {
	ddfiles=(`ls *.deb`)
	echo "Avaliable options:"
	for i in ${!ddfiles[@]}
	do
		printf "%3d%s) %s\n" $((i+1)) "${choices[i]:- }" "${ddfiles[i]}"
	done
	[[ "$msg" ]] && echo "$msg"; :
}


function imddmenuprompt () {
	ddprompt="Enter an option (enter again to uncheck, press RETURN when done): "
	while imddmenuitems && read -rp "$ddprompt" num && [[ "$num" ]]
	do
		[[ "$num" != *[![:digit:]]* ]] && (( num > 0 && num <= ${#ddfiles[@]} )) || {
			msg="Invalid option: $num"
			continue
		}
		((num--)); msg="${ddfiles[num]} was ${choices[num]:+un-}selected"
		[[ "${choices[num]}" ]] && choices[num]="" || choices[num]="x"
	done
	printf "\nYou selected\n\n"; msg=" nothing"
	for i in ${!ddfiles[@]}
	do
		[[ "${choices[i]}" ]] && { printf "%s\n" "${ddfiles[i]}"; msg=""; }
	done >> "$TEMP"/imddchoice.mirepo
	if [ -e "$TEMP"/imddchoice.mirepo ]; then
		for i in `cat "$TEMP"/imddchoice.mirepo`
		do
			echo "${i%%/}"
		done
		imdddel
	else
		imwelcomeloop
	fi
}

function ans1badopt () {
	echo "That is an invalid option. Please select option [1-3]."
	sleep 2
	ans1
}

function ans1 () {
	echo
	echo
	echo "		  AppToDeb Import."
	echo
	echo
	echo -e "\n    1) $OPT4\n	2) $OPT5\n	 3) Cancel\n"
	read option
	if [ "$option" == "1" ]; then
		echo
		echo "Importing all debs from AppToDeb."
		echo
		imatd
	elif [ "$option" == "2" ]; then
		cd "$IMPTH1"
		imatdmenu
	elif [ "$option" == "3" ]; then
		echo
		echo
		echo
		imwelcomeloop
	fi
	if [[ "$option" != "1" ]] && [[ "$option" != "2" ]] && [[ "$option" != "3" ]]; then
		ans1badopt
	fi
}

function ans2badopt () {
	echo "That is an invalid option. Please select option [1-3]."
	sleep 2
	ans2
}

function ans2 () {
	echo
	echo
	echo "		  DebMaker Import."
	echo
	echo
	echo -e "\n  1) $OPT4\n  2) $OPT5\n  3) Cancel\n"
	read option
	if [ "$option" == "1" ]; then
		echo
		echo "Importing all debs from DebMaker."
		echo
		imdm
	elif [ "$option" == "2" ]; then
		cd "$IMPTH2"
		imdmmenuprompt
	elif [ "$option" == "3" ]; then
		imwelcomeloop
	fi
	if [[ "$option" != "1" ]] && [[ "$option" != "2" ]] && [[ "$option" != "3" ]]; then
		ans2badopt
	fi
}

function ans3badopt () {
	echo "That is an invalid option. Please select option [1-3]."
	sleep 2
	ans3
}

function ans3 () {
	echo
	echo
	echo "		  iDeb Import."
	echo
	echo -e "\n  1) $OPT4\n  2) $OPT5\n  3) Cancel\n"
	read option
	if [ "$option" == "1" ]; then
		echo
		echo "		  Importing all debs from iDeb."
		echo
		imidebim
	elif [ "$option" == "2" ]; then
		cd "$IMPTH3"
		imidebmenuprompt
	elif [ "$option" == "3" ]; then
		echo
		imwelcomeloop
	fi
	if [[ "$option" != "1" ]] && [[ "$option" != "2" ]] && [[ "$option" != "3" ]]; then
		ans3badopt
	fi
}

function ans4badopt () {
	echo "That is an invalid option. Please select option [1-3]."
	sleep 2
	ans4
}


function ans4 () {
	echo
	echo
	echo "		  Downloads Folder Import."
	echo
	echo -e "\n  1) $OPT4\n  2) $OPT5\n  3) Cancel\n"
	read option
	if [ "$option" == "1" ]; then
		echo
		echo "		  Importing all debs from Downloads."
		echo
		imdnldim
	elif [ "$option" == "2" ]; then
		cd "$IMPTH4"
		imdnldmenuprompt
	elif [ "$option" == "3" ]; then
		echo
		imwelcomeloop
	fi
	if [[ "$option" != "1" ]] && [[ "$option" != "2" ]] && [[ "$option" != "3" ]]; then
		ans4badopt
	fi
}

function ans5badopt () {
	echo "That is an invalid option. Please select option [1-3]."
	sleep 2
	ans5
}

function ans5 () {
	echo
	echo
	echo "		  APT Cache Import."
	echo
	echo -e "\n  1) $OPT4\n  2) $OPT5\n  3) Cancel\n"
	read option
	if [ "$option" == "1" ]; then
		echo
		echo
		echo "		  Importing all debs from APT Cache."
		echo
		imaptim
		echo
		imwelcomeloop
	elif [ "$option" == "2" ]; then
		cd "$IMPTH5"
		imaptmenuprompt
	elif [ "$option" == "3" ]; then
		echo
		imwelcomeloop
	fi
	if [[ "$option" != "1" ]] && [[ "$option" != "2" ]] && [[ "$option" != "3" ]]; then
		ans5badopt
	fi
}


function ans6badopt () {
	echo "That is an invalid option. Please select option [1-3]."
	sleep 2
	ans6
}


function ans6 () {
	echo
	echo
	echo "		  Debdrop Directory"
	echo "	   Please Choose an Option"
	echo
	echo
	echo -e "\n  1) $OPT8\n  2) $OPT9\n  3) $OPT10\n"
	read option
	if [ "$option" == "1" ]; then
		echo "Emptying DebDrop directory"
		imddrm
		imwelcomeloop
	fi
	if [ "$option" == "2" ]; then
		echo "Select individually"
		cd "$DEBDROP"
		imddmenuprompt
		imdddel
		imwelcomeloop
	fi
	if [ "$option" == "3" ]; then
		echo "Generating deblist"
		echo
		echo
		imddls
		if [ -e "$TEMP"/imddls.mirepo ]; then
			echo -e "\n  1) Delete All\n  2) Delete Individually\n	3) Cancel\n"
			read option
			if [ "$option" == "1" ]; then
				echo "Deleting debs"
				imddrm
				imwelcomeloop
			fi
			if [ "$option" == "2" ]; then
				echo "Deleting selected debs"
				cd "$DEBDROP"
				imddmenuprompt
				imdddel
				imwelcomeloop
			fi
			if [ "$option" == "3" ]; then
				echo "Cancel"
				echo
				sleep 1
				imwelcomeloop
			fi
		fi
	fi
}


function imwelcomebadopt () {
	echo "That is an invalid option. Please select option [1-7]."
	sleep 2
	imwelcome
}


function imwelcome () {
	rm -rf "$TEMP"/*.mirepo
	importls
	clear
	echo
	echo "Welcome to MiRepo's import service."
	sleep 0.2
	echo
	clear
	echo "$DASH"
	echo
	echo "The available import options for your iDevice are:"
	echo
	echo "`cat "$TEMP"/iminstalled.mirepo`"
	echo
	echo "$DASH"
	echo
	sleep 1
	echo "Please choose the number that corresponds" 
	echo "to the packager you would like to import from."
	echo -e "\n  1) $IMSRC1\n  2) $IMSRC2\n  3) $IMSRC3\n  4) $IMSRC4\n  5) $IMSRC5\n  6) $IMSRC6\n  7) Main Menu\n"
	read answer
	if [ "$answer" == "1" ]; then
		ans1
	fi
	if [ "$answer" == "2" ]; then
		ans2
	fi
	if [ "$answer" == "3" ]; then
		ans3
	fi
	if [ "$answer" == "4" ]; then
		ans4
	fi
	if [ "$answer" == "5" ]; then
		ans5
	fi
	if [ "$answer" == "6" ]; then
		ans6
	fi
	if [ "$answer" == "7" ]; then
		ls "$DEBDROP" | grep deb | cut -d '/' -f6 | sort | uniq >"$TEMP"/imdebcheck.mirepo
		DEBLS=(`cat "$TEMP"/imdebcheck.mirepo`)
		if [ -n $(echo "$DEBLS" | wc -l) ]; then
			dxwelcome
		else
			mainmenuloop
		fi
	fi
	if [[ "$answer" != "1" ]] && [[ "$answer" != "2" ]] && [[ "$answer" != "3" ]] && [[ "$answer" != "4" ]] && [[ "$answer" != "5" ]] && [[ "$answer" != "6" ]] && [[ "$answer" != "7" ]]; then
		echo "Returning to Main Menu"
		imwelcomebadopt
	fi
}


#################################
#####	     MakeDeb	    #####
#################################


function makedeb () {
	clear
	echo
	echo
	echo "Preparing repository for package refresh"
	echo
	sleep 0.5
	echo "Please be patient..."
	echo
	cd "$MIREPO"
	chown root:wheel "$BLDDIR"
	chmod 755 "$BLDDIR"
	chown -R root:wheel "$BLDDIR"/*/DEBIAN
	chmod -R 755 "$BLDDIR"/*/DEBIAN
	chmod -R 777 "$DISTDIR"/*
	rm -rf "$DISTDIR"/*.deb
	cd "$BLDDIR"
	echo "Building Packages:"
	echo
	echo "## Build Log ##" > "$BLDLOG"
	echo "" >> "$BLDLOG"
	for DebianPkg in `ls -d */`
	do
		PKG=`echo "${DebianPkg%%/}" | cut -d '_' -f1`
		last=${PKG##*.}
		dpkg-deb -b -Zgzip -z6 "${DebianPkg%%/}"/ "$DISTDIR"/"${DebianPkg%%/}".deb &> /dev/null &>> "$BLDLOG"
		echo "Building:  `echo "${last}"`"
	done
	echo
	echo "$R`echo "DONE!"`$b"
	echo
	echo "Scanning Packages..."
	sleep 0.5
	cd "$REPO"
	if [ -e "$REPO"/Packages ]; then
		rm -rf "$REPO"/Packages
	fi
	if [ -e "$REPO"/Packages.bz2 ]; then
		rm -rf "$REPO"/Packages.bz2
	fi
	if [ -e "$REPO"/Packages.gz ]; then
		rm -rf "$REPO"/Packages.gz
	fi
	echo
	echo "Signing Packages..."
	sleep 0.5
	/usr/bin/dpkg-scanpackages -m debs /dev/null > Packages 2> "$SCANLOG"
	wait
	if [ -e "$REPO"/Packages ]; then
		cp "$REPO"/Packages "$REPO"/Packages2
		cp "$REPO"/Packages "$REPO"/Packages3
		bzip2 Packages
	fi
	if [ -e "$REPO"/Packages2 ]; then
		mv "$REPO"/Packages2 "$REPO"/Packages
		gzip Packages
	fi
	if [ -e "$REPO"/Packages3 ]; then
		mv "$REPO"/Packages3 "$REPO"/Packages
	fi
	wait
	if [ -e "$REPO"/Release.gpg ]; then
		rm -rf "$REPO"/Release.gpg
	fi
	if [ -e "$REPO"/Release ]; then
		echo "Origin: MiRepo" > "$REPO"/Release
		echo "Label: MiRepo" >> "$REPO"/Release
		echo "Suite: stable" >> "$REPO"/Release
		echo "Version: 6.0" >> "$REPO"/Release
		echo "Codename: MiRepo" >> "$REPO"/Release
		echo "Architectures: iphoneos-arm" >> "$REPO"/Release
		echo "Components: main" >> "$REPO"/Release
		echo "Description: MiRepo is a Debian repository for iOS." >> "$REPO"/Release
		echo "MD5Sum:" >> "$REPO"/Release
		echo " `md5sum "$REPO"/Packages | cut -d ' ' -f1` `stat --format=%s "$REPO"/Packages` Packages" >> "$REPO"/Release
		echo " `md5sum "$REPO"/Packages.bz2 | cut -d ' ' -f1` `stat --format=%s "$REPO"/Packages.bz2` Packages.bz2" >> "$REPO"/Release
		echo " `md5sum "$REPO"/Packages.gz | cut -d ' ' -f1` `stat --format=%s "$REPO"/Packages.gz` Packages.gz" >> "$REPO"/Release
	fi
	if [ -e "$REPO"/Release ]; then
		gpg -a -b -s -u MiRepo.com -o "$REPO"/Release.gpg "$REPO"/Release
	fi
	chown root:wheel "$DISTDIR"
	chmod 777 "$DISTDIR"
	chown -R daemon:_www /var/www
	chown root:wheel /var/www/repo/compile-repo.pl
	chmod 755 /var/www/repo/compile-repo.pl
	sleep 2
	echo
	echo
	sbalert -q 5 -t "MiRepo Alert" -m "MiRepo has been successfully refreshed. Add http://cydia.mirepo.com/repo/ to your sources in Cydia to access MiRepo."
	mainmenuloop
}

#################################
#####	    Main Menu	    #####
#################################


function mainbadopt () {
echo "That is an invalid option. Please select option [1-4]."
sleep 2
mainmenu
}


function mainmenu () {
	mkdir -p "$TEMP"
	pushd "$TEMP"
	if [ ! -d "$MIREPO" ]; then
		mkdir -p "$MIREPO"
		chown -R root:wheel "$MIREPO"
		chmod -R 755 "$MIREPO"
	fi
	if [ ! -d "$DEBDROP" ]; then
		mkdir -p "$DEBDROP"
		chown -R root:wheel "$DEBDROP"
		chmod -R 755 "$DEBDROP"
	fi
	if [ ! -d "$BLDDIR" ]; then
		mkdir -p "$BLDDIR"
		chown -R root:wheel "$BLDDIR"
		chmod -R 755 "$BLDDIR"
	fi
	if [ ! -d "$DISTDIR" ]; then
		mkdir -p "$DISTDIR"
		chown -R root:wheel "$DISTDIR"
		chmod 777 "$DISTDIR"
	fi
	if [ ! -d "$BACKUPDIR" ]; then
		mkdir -p "$BACKUPDIR"
		chown -R root:wheel "$BACKUPDIR"
		chmod -R 755 "$BACKUPDIR"
	fi
	if [ ! -d "$NEWDEBS" ]; then
		mkdir -p "$NEWDEBS"
		chown -R root:wheel "$NEWDEBS"
		chmod -R 755 "$NEWDEBS"
	fi
	if [ ! -d "$LOGDIR" ]; then
		mkdir -p "$LOGDIR"
		chown -R root:wheel "$LOGDIR"
		chmod -R 755 "$LOGDIR"
	fi
	if [ ! -L "$CYDIA" ]; then
		ln -s "$DISTDIR" "$CYDIA"
	fi
	if [ ! -L "$CMPL" ]; then
		ln -s "$DISTDIR" "$CMPL"
	fi
	clear
	rm -rf "$LOGDIR"/*.log
	echo
	echo "		  Welcome to MiRepo"
	echo "		http://cydia.mirepo.com/repo"
	echo
	echo "		 Directory Structure"
	echo
	echo "MiRepo:  $MIREPO"
	echo
	echo "Build:   $BLDDIR"
	echo
	echo "DebDrop: $DEBDROP"
	echo
	echo "Package: $DISTDIR"
	echo
	echo
	echo
	echo "Main Menu:"
	echo -e "\n  1) $OPT1\n\n  2) $OPT2\n\n  3) $OPT3\n\n  4) Exit MiRepo"
	read answer
	echo
	if [ "$answer" == "1" ]; then
		imwelcome 2> "$IMLOG"
	fi
	if [ "$answer" == "2" ]; then
		dxwelcome 2> "$DXLOG"
	fi
	if [ "$answer" == "3" ]; then
		makedeb
	fi
	if [ "$answer" == "4" ]; then
		clear
		cd "$MIREPO"
		mv "$TEMP"/*.log "$LOGDIR"
		popd "$TEMP"
		rm -rf "$TEMP"
		echo
		echo
		echo
		clear
		echo
		echo "Thank you for using MiRepo"
		echo
		echo "Goodbye."
		echo
		exit 0
	fi
	if [[ "$answer" != "1" ]] && [[ "$answer" != "2" ]] && [[ "$answer" != "3" ]] && [[ "$answer" != "4" ]]; then
		mainbadopt
	fi
}

testroot
mainmenu
