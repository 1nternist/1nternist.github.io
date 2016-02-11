#!/bin/bash

##
## debXpandr v3.0
## Written by Chir0student (Markus McCormac) <chir0student@me.com>
## This is a script that neatly extracts Debian packages
##
## Simply execute the command "debXpandr" from Terminal in your working directory.
##
WKDIR="`pwd`"
BASEDIR="${WKDIR}"

for i in `ls *.deb`; do
	WORK_DIR=`echo "${i%%/}" | sed "s/....$//"`
	if [ -d "$WORK_DIR" ]; then
		rm -rf "$WORK_DIR";
		mkdir -p "$WORK_DIR"/DEBIAN
	else
		mkdir -p "$WORK_DIR"/DEBIAN
	fi
	/usr/bin/7z x -y -o"${BASEDIR}/${WORK_DIR}" "${BASEDIR}/${i%%/}" &> /dev/null
	echo "Processing: ${i%%/}"
	tar zxf "$WORK_DIR"/control.tar.gz -C "$WORK_DIR"/DEBIAN
	TEST=$(ls ${BASEDIR}/${WORK_DIR} | grep data.tar)
	if [[ "`echo ${TEST}`" == "data.tar.gz" ]]; then
		tar zxf "$WORK_DIR"/data.tar.gz -C "$WORK_DIR"
	fi
	if [[ "`echo ${TEST}`" == "data.tar.lzma" ]]; then
		tar -x --lzma -f "$WORK_DIR"/data.tar.lzma -C "$WORK_DIR"
	fi
	if [[ "`echo ${TEST}`" == "data.tar.xz" ]]; then
		tar Jxf "$WORK_DIR"/data.tar.xz -C "$WORK_DIR"
	fi
	rm -rf "$WORK_DIR"/control.tar.*
	rm -rf "$WORK_DIR"/data.tar.*
done
mkdir -p extracted-debs
for i in `ls *.deb`; do
	EXT="extracted-debs"
	if [ -d "$EXT" ]; then
	mv ${i%%/} "$EXT"
else
	mkdir -p extracted-debs && mv ${i%%/} extracted-debs
fi
done
exit 0


