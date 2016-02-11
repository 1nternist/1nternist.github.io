#!/bin/bash

REPO="/var/mobile/Developer/Github/1nternist.github.io"
LOGD=$REPO/log
SCANLOG=$LOGD/scanpkgs.log
SIGNLOG=$LOGD/signpkgs.log
SYNCLOG=$LOGD/git-sync.log

rm -rf $REPO/Packages*
wait
/usr/bin/dpkg-scanpackages256 -m debs /dev/null > Packages && bzip2 < Packages > Packages.bz2 && gzip < Packages > Packages.gz
