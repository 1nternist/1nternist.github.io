#!/bin/bash

REPO="/var/mobile/Developer/Github/1nternist.github.io"
LOGD=$REPO/log
SCANLOG=$LOGD/scanpkgs.log
SIGNLOG=$LOGD/signpkgs.log
SYNCLOG=$LOGD/git-sync.log

su mobile -c "git status" &> $SYNCLOG
wait
su mobile -c "git add ." &>> $SYNCLOG
wait
su mobile -c 'git commit -m "Repo package refresh"' &>> $SYNCLOG
wait
su mobile -c "git push origin master" &>> $SYNCLOG
