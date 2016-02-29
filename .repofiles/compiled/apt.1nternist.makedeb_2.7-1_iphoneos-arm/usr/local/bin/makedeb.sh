#!/bin/bash

working_dir="/private/var/mobile/Documents"
repo_dir="$working_dir"/repo
build_dir="$repo_dir"/build
debs_dir="$repo_dir"/debs

if [ ! -d "$repo_dir" ]; then
    cd "$working_dir" && mkdir -p repo/build repo/debs
fi

clear
sleep 1
echo "Clearing old debs..."
sleep 3
cd "$repo_dir"
chown -R root:wheel build && chmod -R 755 build
cd "$build_dir"
rm -rf ../debs/*.deb

for DebianPkg in `ls -d */`; do
	dpkg-deb -b ${DebianPkg%%/}/ ../debs/${DebianPkg%%/}.deb
done
sleep 2
cd "$debs_dir"

if [ -e "$debs_dir"/Packages.bz2 ]; then
    rm -rf "$debs_dir"/Packages.bz2
fi

dpkg-scanpackages -m . /dev/null -->Packages && bzip2 Packages
sleep 1
echo
echo "Repository has been updated successfully!"
echo
exit 0