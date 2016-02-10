#!/bin/bash

REPO="/var/mobile/Developer/Github/1nternist.github.io"
LOGD=$REPO/log
SCANLOG=$LOGD/scanpkgs.log
SIGNLOG=$LOGD/signpkgs.log
SYNCLOG=$LOGD/git-sync.log

rm -rf $LOGD/*.log


./scanpkgs.sh 2> $SCANLOG || exit 1
wait
./signpkgs.sh 2> $SIGNLOG || exit 1
#chown -R mobile $REPO
#sudo ./git-sync.sh || exit 1

git add . 2>> $SYNCLOG
wait
git status 2> $SYNCLOG
wait
git commit -m "Repository update" 2>> $SYNCLOG
wait
git push origin master 2>> $SYNCLOG


echo "  Repository updated successfully."
echo "  Please open Cydia and refresh "
echo "  your sources."


