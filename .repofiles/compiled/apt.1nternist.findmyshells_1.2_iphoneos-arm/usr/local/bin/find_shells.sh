#!/bin/bash

function findshells () {
for dir in \
	/bin \
	/sbin \
	/usr/bin \
	/usr/sbin \
	/usr/libexec \
	/usr/local/bin \
	/usr/local/sbin \
; do
	file "${dir}"/* | grep -i text
done
}

findshells >/dev/null >/var/mobile/Shells.txt 2>&1

