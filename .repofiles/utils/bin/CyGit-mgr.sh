#!/bin/bash

REPO="/var/mobile/Developer/Github/1nternist.github.io"
LOGD="$REPO/log"
BLDLOG="$LOGD/buildlog.log"
BLDERR="$LOGD/builderr.log"
SCNLOG="$LOGD/scanlog.log"
SCNERR="$LOGD/scanerr.log"
SIGNLOG="$LOGD/signlog.log"
SIGNERR="$LOGD/signerr.log"
SYNCLOG="$LOGD/git-sync.log"
SYNCERR="$LOGD/git-sync-err.log"
UTILS="$REPO/.repofiles/utils/bin"
BLD="$REPO/.repofiles/uncompiled"
ARCH="$REPO/.repofiles/compiled"
ARCH_BETA="$REPO/.repofiles/compiled-beta"
BLD_BETA="$REPO/.repofiles/uncompiled-beta"
OPT1="Refresh repository"
OPT2="Push changes to GitHub"
OPT3="Exit"
DATE=$(date '+%m-%d-%Y %H:%M:%S')
export PATH="$UTILS:$PATH"

#################################
#####	 Extra Functions    #####
#################################

function mainmenuloop () {
	mainmenu
}

function dirsetup () {
	for dir in $LOGD $UTILS $BLD $ARCH $BLD_BETA $ARCH_BETA; do
		if [ ! -d "${dir%%/}" ]; then
			mkdir -p "${dir%%/}"
		fi
	done
}

function compilepkgs () {
rm -rf $LOGD/*.log
sudo chown -R root $BLD
sudo chmod 755 $BLD
sudo chmod 777 $REPO/debs
clear
echo ""
echo " ➔ Building packages"
for PkgDir in `ls $BLD 2> $BLDERR`; do
  sudo dpkg-deb -b $BLD/"${PkgDir%%/}" $REPO/debs/"${PkgDir%%/}".deb &>> $BLDLOG
done
sleep 1
sudo mv -f $BLD/* $ARCH 2>> $BLDERR
wait
sudo chown -R mobile $ARCH
sudo chown -R mobile $BLD
sudo chown -R mobile debs
chmod 777 debs
sudo chown -R mobile $LOGD
}

function scanpkgs () {
echo " ➔ Scanning packages"
rm -rf "Packages.gz" "Packages.bz2" "Packages"
scanpkg="$UTILS/dpkg-scanpackages"
$scanpkg -m debs /dev/null > Packages
#sed -i 'Packages' "s#Filename: debs//#Filename: debs/#g"
bzip2 -zkf < Packages > Packages.bz2
gzip -f < Packages > Packages.gz
}

function signpkgs () {
echo " ➔ Signing Release with gpg"
rm -rf Release
rm -rf Release.gpg
cp Release-Template Release
echo " `md5sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >> Release
echo " `md5sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >> Release
echo " `md5sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >> Release
echo "SHA1:" >> Release
echo " `sha1sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >> Release
echo " `sha1sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >> Release
echo " `sha1sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >> Release
echo "SHA256:" >> Release
echo " `sha256sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >> Release
echo " `sha256sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >> Release
echo " `sha256sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >> Release
gpg --passphrase-file /usr/share/keyrings/passwd/github --batch -abs -u dc1nternist -o Release.gpg Release
sleep 2
}

function pushupdate () {
	echo ""
	git status &> $SYNCLOG
	wait
	git add . &>> $SYNCLOG
	wait
	git status &>> $SYNCLOG
	wait
	git commit -m "Repository update $DATE" &>> $SYNCLOG
	wait
	git push origin master &>> $SYNCLOG
	wait
}

function choice1msg () {
	clear
	echo ""
	echo " ##################################"
	echo " ## Repository has been updated. ##"
	echo " ##   You must push the update   ##"
	echo " ##    to GitHub and refresh     ##"
	echo " ##	your Cydia sources     ##"
	echo " ##################################"
	echo ""
	echo ""
	sleep 3
}

function choice2msg () {
	clear
	echo ""
	echo " ##################################"
	echo " ##   Pushing changes to Github, ##"
	echo " ##   please be patient...       ##"
	echo " ##################################"
	echo ""
	echo ""
}

function choice2msg2 () {
	echo ""
	echo " ##################################"
	echo " ##  GitHub repository has been  ##"
	echo " ##    updated. Please wait a    ##"
	echo " ##   minute before refreshing   ##"
	echo " ##	     Cydia.	       ##"
	echo " ##################################"
	echo ""
	sleep 3
}

function exitscreen () {
	clear
	echo ""
	echo " ##################################"
	echo " ## Thank you for using cyrepo.  ##"
	echo " ##	    Good Bye.	       ##"
	echo " ##################################"
	echo ""
	echo ""
	exit 0
}

function mainbadopt () {
	echo ""
	echo "That is an invalid option. Please select option [1-3]."
	echo ""
	mainmenuloop
}

function mainmenu () {
	clear
	cd "$REPO"
	dirsetup
	echo ""
	echo " ##################################"
	echo " ##	  Main Menu	       ##"
	echo " ##################################"
	echo ""
	echo ""
	echo "	What would you like to do?"
	echo ""
	echo -e "\n  1) $OPT1\n  2) $OPT2\n  3) $OPT3\n\n" 
	read choice
	if [ "$choice" = "1" ]; then
		compilepkgs 2> "$BLDERR"
		wait
		scanpkgs 2> "$SCNERR"
		wait
		signpkgs 2> "$SIGNERR"
		wait
		choice1msg
		mainmenuloop
	fi
	if [ "$choice" = "2" ]; then
		choice2msg
		pushupdate 2> "$SYNCERR"
		wait
		choice2msg2
		mainmenuloop
	fi
	if [ "$choice" = "3" ]; then
		exitscreen
	fi
	if [[ "$choice" != "1" ]] && [[ "$choice" != "2" ]] && [[ "$choice" != "3" ]]; then
		mainbadopt
	fi
}

mainmenu

