#!/bin/bash

REPO="/var/mobile/Developer/Github/1nternist.github.io"
LOGD=$REPO/log
SCANLOG=$LOGD/scanlog.log
SIGNLOG=$LOGD/signlog.log
SYNCLOG=$LOGD/git-sync.log
utils="$REPO/.repofiles/utilities"
export PATH="$utils/bin:$PATH"


function scanpkgs () {
echo "Scanning packages..."
rm -rf "Packages.gz" "Packages.bz2" "Packages"
rm -rf "$LOGD"/*.log
scanpkg="$utils/bin/dpkg-scanpackages"
$scanpkg -m debs /dev/null > Packages
sed -i '' "s#Filename: debs//#Filename: debs/#g" Packages
bzip2 -zkf < Packages > Packages.bz2
gzip < Packages > Packages.gz
}

function signpkgs () {
echo "Signing Release with gpg..."
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
}

function pushupdate () {
echo "Pushing changes to Github..."
git add . &> $SYNCLOG
wait
git status &>> $SYNCLOG
wait
git commit -m "Package update" &>> $SYNCLOG
wait
git push origin master &>> $SYNCLOG
}

scanpkgs 2> "$SCANLOG"
wait
signpkgs 2> "$SIGNLOG"
wait
pushupdate 2> $SYNCLOG
wait

echo "##################################"
echo "#  Repository has been updated.  #"
echo "#      Please open Cydia and     #" 
echo "#      refresh your sources.     #"
echo "##################################"
