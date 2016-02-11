#!/bin/bash

if [ -z $1 ]; then
echo "Usage: dpkg-scanpackages [PACKAGE FOLDER] [REPO FOLDER] [-u]"
echo "-u: update old Packages file"
exit
fi
if [ -z $2 ]; then
echo "Usage: dpkg-scanpackages [PACKAGE FOLDER] [REPO FOLDER] [-u]"
echo "-u: update old Packages file"
exit
fi 
if [ ! -d "$2" ]; then
mkdir $2
fi
echo "comparing variables"
if [ "$2" = "-u" ]; then
echo "2 = -u"
else
echo "removing pkgs"
rm $2/Packages
rm $2/Packages.gz
fi
if [ ! -f $2/Release ]; then
echo "Origin: " >> $2/Release
echo "Label: " >> $2/Release
echo "Suite: stable" >> $2/Release
echo "Version: 1.0" >> $2/Release
echo "Codename: stable" >> $2/Release
echo "Architectures: iphoneos-arm" >> $2/Release
echo "Components: main" >> $2/Release
echo "Description: " >> $2/Release
echo "Please fill out blank fields in $2/Release"
fi
IFS=!
ARRAY=($1/*.deb)
for i in ${ARRAY[*]}; do
`7z -o$1 x -y $i control.tar.gz` > /dev/null 2>&1
`tar -zxvf $1/control.tar.gz --directory=$1` > /dev/null 2>&1
echo `cat $1/control` >> $2/Packages
filename=`basename $i`
echo "Filename: ./$filename" >> $2/Packages
size=`stat -c %s $i`
md5=`md5sum $i | awk '{ print $1 }'`
echo "Size: $size" >> $2/Packages
echo "MD5sum: $md5" >>  $2/Packages
echo "" >> $2/Packages
if [ -e $1/*.tar.gz ]; then
`rm $1/*.tar.gz` > /dev/null 2>&1
fi
if [ -e $1/*inst ];then
`rm $1/*inst` > /dev/null 2>&1
fi
if [ -e $1/*rm ]; then
`rm $1/*rm` > /dev/null 2>&1
fi
if [ -e $1/control ]; then
`rm $1/control` > /dev/null 2>&1
fi
cp $2/Packages $2/Packages2
gzip -f $2/Packages
mv $2/Packages2 $2/Packages
#rm $i
done
