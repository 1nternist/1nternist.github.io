#!/bin/bash
/usr/bin/dpkg-scanpackages256 -m debs /dev/null > Packages && bzip2 < Packages > Packages.bz2 && gzip < Packages > Packages.gz
