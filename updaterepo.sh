#!/bin/bash
ws=$(cd "$(dirname "$0")" && pwd)
cd "$ws"
rm -f "Release" "Packages.bz2" "Packages"
scanpkg="$ws/dpkg-scanpackages"
"$scanpkg" "debs" > "Packages"
sed -i '' "s#Filename: debs//#Filename: debs/#g" Packages
bzip2 -zkf "Packages"
rm -f "Packages"
echo "Origin: YangRepo" > "Release"
echo "Label: YangRepo" >> "Release"
echo "Suite: stable" >> "Release"
echo "Version: 1.0" >> "Release"
echo "Codename: yangapp" >> "Release"
echo "Architectures: iphoneos-arm" >> "Release"
echo "Components: main" >> "Release"
echo "Description: Linus Yang's iOS Repository" >> "Release"
echo "Support: http://linusyang.com/" >> "Release"
echo "MD5Sum:" >> "Release"
if [ -e /usr/bin/md5sum ]; then 
	md5=$(md5sum "Packages.bz2" | cut -c -32)
else
	md5=$(openssl md5 "Packages.bz2" | cut -f2 -d' ')
fi
size=$(ls -l "Packages.bz2" | awk '{print $5}')
echo " $md5 $size Packages.bz2" >> "Release"
gpg --yes -abs -o Release.gpg Release
