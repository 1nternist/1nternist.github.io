#!/bin/bash

MYDIR="`pwd`"
DIR=$MYDIR
CYGIT="$(dirname $DIR)"
RNAME="$(basename $DIR)"
REPO="$CYGIT/$RNAME"
LOGD="$REPO/log"
LASTLOG="$LOGD/lastrun"
BLDLOG="$LOGD/buildlog.log"
BLDERR="$LOGD/builderr.log"
SCNLOG="$LOGD/scanlog.log"
SCNERR="$LOGD/scanerr.log"
SIGNLOG="$LOGD/signlog.log"
SIGNERR="$LOGD/signerr.log"
SYNCLOG="$LOGD/git-sync.log"
SYNCERR="$LOGD/git-sync-err.log"
ARCHLOG="$LOGD/archivelog.log"
ARCHERR="$LOGD/archiveerr.log"
UTILS="$REPO/.repofiles/utils/bin"
BUILD="$REPO/.repofiles/uncompiled"
DONE="$REPO/.repofiles/compiled"
DEBS="$REPO/debs"
DONE_BETA="$REPO/.repofiles/compiled-beta"
BUILD_BETA="$REPO/.repofiles/uncompiled-beta"
PKG_ARC="$CYGIT/pkg_archives"
COMP="$CYGIT/unpackaged"
OPT1="Build packages"
OPT2="Push changes to GitHub"
OPT3="Full refresh"
OPT4="Exit"
DATE=$(date '+%m-%d-%Y %H:%M:%S')
export PATH="$UTILS:$PATH"

#################################
#####	 Extra Functions    #####
#################################

function mainmenuloop () {
	mainmenu
}

function dirsetup () {
	for dir in $LOGD $LASTLOG $UTILS $BUILD $DONE $BUILD_BETA $DONE_BETA; do
		if [ ! -d "${dir%%/}" ]; then
			mkdir -p "${dir%%/}"
		fi
	done
}

function cleanlog () {
	rm -rf $LOGD/lastrun/*.log
	wait
	mv -f $LOGD/*.log $LOGD/lastrun
}

function permissions () {
chown mobile $BUILD
chmod 755 $BUILD
chown mobile $DONE
chmod 755 $DONE
chown mobile $COMP 
chmod 755 $COMP
chown mobile $DEBS
chmod 777 $DEBS
chown -R mobile $PKG_ARC
chmod 755 $PKG_ARC
chown -R mobile $LOGD
chmod 755 $LOGD
}

function mvarch () {
	cd $DONE
	echo ""
	echo "Moving previous build directories to archive folder"
	for ArchDir in `ls &>>$ARCHLOG`; do
	if [[ -d "${ArchDir%%/}" ]] && [[ ! -d $COMP/"${ArchDir%%/}" ]]; then
		mv -f $DONE/"${ArchDir%%/}" $COMP
	elif [[ -d "${ArchDir%%/}" ]] && [[ -d $COMP/"${ArchDir%%/}" ]]; then
		rm -rf $COMP/"${ArchDir%%/}"
		mv -f $DONE/"${ArchDir%%/}" $COMP
	fi
	echo "Moved: ${ArchDir%%/} ➔ OK!"
	done
	cd $REPO
}

function compilepkgs () {
#sudo chown -R root $BUILD
#sudo chmod 755 $BUILD
#sudo chmod 777 $REPO/debs
chown -R root $BUILD
chmod 777 $BUILD
chown root $DONE
chmod 777 $DONE
chown root $COMP
chmod 777 $COMP
chown -R root:wheel $DEBS
chmod 777 $DEBS
chown root $PKG_ARC
chmod 777 $PKG_ARC
chown root $LOGD
chmod 777 $LOGD
clear
cd $BUILD
echo ""
echo "Building Packages into debs Directory."
for PkgDir in `ls &>>$BUILDLOG`; do
  dpkg-deb -b -Zxz "${PkgDir%%/}" $DEBS/"${PkgDir%%/}".deb &>>$BUILDLOG
done
sleep 1
for DebDir in `ls &>>$ARCHLOG`; do
	if [ -f $PKG_ARC/"${DebDir%%/}".txz ]; then
		rm -rf $PKG_ARC/"${DebDir%%/}".txz
		wait
		tar Jcf $PKG_ARC/"${DebDir%%/}".txz "${DebDir%%/}" &>>$ARCHLOG
	else
		tar Jcf $PKG_ARC/"${DebDir%%/}".txz "${DebDir%%/}" &>>$ARCHLOG
	fi
	wait
	if [[ -d "${DebDir%%/}" ]] && [[ ! -f "${DebDir%%/}".txz ]] && [[ -f $PKG_ARC/"${DebDir%%/}".txz ]]; then
		mv -f $BUILD/"${DebDir%%/}" $DONE/"${DebDir%%/}" &>>$ARCHLOG
	elif [[ -d "${DebDir%%/}" ]] && [[ -f "${DebDir%%/}".txz ]] && [[ ! -f $PKG_ARC/"${DebDir%%/}".txz ]]; then
		mv -f $BUILD/"${DebDir%%/}".txz $PKG_ARC &>>$ARCHLOG
		mv -f $BUILD/"${DebDir%%/}" $DONE &>>$ARCHLOG
	fi
done
wait
cd $REPO
clear
echo ""
echo "Package Build Complete."
sleep 2
}

function scanpkgs () {
echo " ➔ Scanning packages"
rm -rf "Packages.gz" "Packages.bz2" "Packages"
scanpkg="$UTILS/dpkg-scanpackages"
$scanpkg -m debs /dev/null > Packages
bzip2 -zkf < Packages > Packages.bz2
gzip -f < Packages > Packages.gz
}

function signpkgs () {
echo " ➔ Signing Release with gpg"
rm -rf Release
rm -rf Release.gpg
cp Release-Template Release
echo "MD5Sum:" >>Release
echo " `md5sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >>Release
echo " `md5sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >>Release
echo " `md5sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >>Release
echo "SHA1:" >>Release
echo " `sha1sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >>Release
echo " `sha1sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >>Release
echo " `sha1sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >>Release
echo "SHA256:" >>Release
echo " `sha256sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >>Release
echo " `sha256sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >>Release
echo " `sha256sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >>Release
echo "SHA512:" >>Release
echo " `sha512sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >>Release
echo " `sha512sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >>Release
echo " `sha512sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >>Release
gpg --passphrase-file /usr/share/keyrings/passwd/gpg --batch -abs -u dc1nternist -o Release.gpg Release
echo " ➔ Release File Signed Successfully."
sleep 2
}

function pushupdate () {
	echo ""
	git status &>$SYNCLOG
	wait
	git add . &>>$SYNCLOG
	wait
	git status &>>$SYNCLOG
	wait
	git commit -am "Repository update $DATE" &>>$SYNCLOG
	wait
	git push origin master &>>$SYNCLOG
	wait
}

function choice1msg () {
	clear
	echo ""
	echo " ##################################"
	echo " ## Repository has been updated. ##"
	echo " ##   You must push the update   ##"
	echo " ##    to GitHub and refresh     ##"
	echo " ##	 your Cydia sources	 ##"
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
	echo " ##	     Cydia.		 ##"
	echo " ##################################"
	echo ""
	sleep 3
}

function exitscreen () {
	clear
	echo ""
	echo " ##################################"
	echo " ##     Thank you for using      ##"
	echo " ##	      CyGit.		 ##"
	echo " ##################################"
	echo ""
	echo ""
	exit 0
}

function mainbadopt () {
	echo ""
	echo "That is an invalid option. Please select option [1-4]."
	echo ""
	sleep 2
	mainmenuloop
}

function mainmenu () {
	clear
	cd "$REPO"
	cleanlog
	dirsetup
	echo ""
	echo " ##################################"
	echo " ##	   Main Menu		 ##"
	echo " ##################################"
	echo ""
	echo ""
	echo "	What would you like to do?"
	echo ""
	echo -e "\n  1) $OPT1\n  2) $OPT2\n  3) $OPT3\n  4) $OPT4\n\n" 
	read choice
	if [ "$choice" = "1" ]; then
		mvarch 2>"$ARCHERR"
		wait
		compilepkgs 2> "$BUILDERR"
		wait
		scanpkgs 2> "$SCNERR"
		wait
		signpkgs 2> "$SIGNERR"
		wait
		permissions
		wait
		choice1msg
		wait
		mainmenuloop
	fi
	if [ "$choice" = "2" ]; then
		choice2msg
		wait
		pushupdate 2> "$SYNCERR"
		wait
		choice2msg2
		wait
		mainmenuloop
	fi
		if [ "$choice" = "3" ]; then
		mvarch 2>$ARCHERR
		wait
		compilepkgs 2> "$BUILDERR"
		wait
		scanpkgs 2> "$SCNERR"
		wait
		signpkgs 2> "$SIGNERR"
		wait
		permissions
		choice1msg
		sleep 3
		choice2msg
		pushupdate 2> "$SYNCERR"
		wait
		choice2msg2
		mainmenuloop
	fi
	if [ "$choice" = "4" ]; then
		exitscreen
	fi
	if [[ "$choice" != "1" ]] && [[ "$choice" != "2" ]] && [[ "$choice" != "3" ]] && [[ "$choice" != "4" ]]; then
		mainbadopt
	fi
}

mainmenu
