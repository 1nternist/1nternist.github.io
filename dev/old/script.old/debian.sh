#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEBIN=apt-git
SOURCEDOC=README.md
DEBFOLDER=apt-git
DEBVERSION=$(date +%Y%m%d)

DEBFOLDERNAME="../$DEBFOLDER-$DEBVERSION"

cd $DEBFOLDER

# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp $SOURCEBINPATH/$SOURCEBIN $DEBFOLDERNAME 
cd $DEBFOLDERNAME

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig 

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo $SOURCEBIN usr/bin > debian/install 
#echo $SOURCEDOC usr/share/doc/apt-git >> debian/install

# Remove the example files
rm debian/*.ex

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc > ../log 