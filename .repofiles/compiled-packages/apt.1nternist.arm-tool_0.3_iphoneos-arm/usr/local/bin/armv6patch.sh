#!/bin/bash

### root test ###
[ `id -u` != 0 ] && exec echo "Error: You must be root to run this script."

target=$1

sed -i'' 's/\x00\x30\x93\xe4/\x00\x30\x93\xe5/g;s/\x00\x30\xd3\xe4/\x00\x30\xd3\xe5/g;' "$1"

/usr/bin/ldid -S "$1"

exit 0
