#!/bin/bash

./scanpkgs.sh || exit 1
wait

echo "Origin: 1nternist's Repo" > Release
echo "Label: 1nternist's Repo" >> Release
echo "Suite: stable" >> Release
echo "Version: 1.2" >> Release
echo "Codename: apt.1nternist.github.io" >> Release
echo "Architectures: iphoneos-arm" >> Release
echo "Components: main" >> Release
echo "Description: 1nternist's Cydia repository on GitHub!" >> Release
echo "MD5Sum:" >> Release
echo " `md5sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >> Release
echo " `md5sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >> Release
echo " `md5sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >> Release
echo ""
echo "SHA1:" >> Release
echo " `sha1sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >> Release
echo " `sha1sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >> Release
echo " `sha1sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >> Release
echo "SHA256:" >> Release
echo " `sha256sum Packages | cut -d ' ' -f1` `stat --format=%s Packages` Packages" >> Release
echo " `sha256sum Packages.bz2 | cut -d ' ' -f1` `stat --format=%s Packages.bz2` Packages.bz2" >> Release
echo " `sha256sum Packages.gz | cut -d ' ' -f1` `stat --format=%s Packages.gz` Packages.gz" >> Release
