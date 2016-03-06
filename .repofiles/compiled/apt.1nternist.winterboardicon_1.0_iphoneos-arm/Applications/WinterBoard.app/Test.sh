#!/bin/bash
set -e

ip=$1
app=$2

if [[ -z $ip ]]; then
    exit 1;
fi

make package
scp -p winterboard.deb root@"$ip":
ssh root@"$ip" dpkg -i winterboard.deb

if [[ -n $app ]]; then
    ssh root@"$ip" killall "$app"
fi
