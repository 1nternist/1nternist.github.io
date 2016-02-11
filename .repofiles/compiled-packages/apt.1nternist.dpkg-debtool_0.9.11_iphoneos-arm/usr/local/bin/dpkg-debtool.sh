#!/bin/sh

if [[ ! -f "/User/Documents/dpkg-debtool.config" ]]; then
	printf '/\nlzma\nNone' > /User/Documents/dpkg-debtool.config
fi

export DEBROOT=`head -1 /User/Documents/dpkg-debtool.config`
export ZIP=`tail -n2 /User/Documents/dpkg-debtool.config |head -n1`
export AUTONAME=`tail -1 /User/Documents/dpkg-debtool.config`

check="0"

AUTHOR=""
PACKAGE=""
VERSION=""
DEBFOLDER=""

if [[ $1 != "" && $2 != "" && $3 != "" && $4 != "" ]]; then
	DEBROOT=$1
	ZIP=$2
	AUTONAME=$3
	lastset=$4
fi

case "$AUTONAME" in
	1 ) export NAMEFORMAT="1. author_package_version.deb"
		;;
	2 ) export NAMEFORMAT="2. package_version.deb"
		;;
	3 ) export NAMEFORMAT="3. package.deb"
		;;
	* ) export NAMEFORMAT="4. None (Directory name)"
		;;
esac

# Output parameter settings
echo ""
echo "=================================================="
echo ""
echo "Last path : $DEBROOT"
echo ""
echo "Compression Method : $ZIP"
echo ""
echo "Filename Format : $NAMEFORMAT"
echo ""
echo "=================================================="
echo ""

# Check loop settings (y/n)
while [ "$check" == "0" ]
do
	if [[ $lastset != "y" ]]; then
		read -p "Read the config which used at last time? (y/n/reset) " lastset
	fi
	
	if [ "$lastset" == "Y" -o "$lastset" == "y" ]; then
		check="1"
	elif [ "$lastset" == "N" -o "$lastset" == "n" ]; then
	
		read -e -p "Please set your package path : " DEBROOT
		check="1"
		
		echo ""
		echo "Compression method (Default method is lzma):"
		echo "1.lzma"
		echo "2.bzip2"
		echo "3.gzip"
		read -p "" ZIP
		if [[ "$ZIP" == "lzma" || "$ZIP" == "1" ]]; then
			ZIP="lzma"
		elif [[ "$ZIP" == "bzip2" || "$ZIP" == "2" ]]; then
			ZIP="bzip2"
		elif [[ "$ZIP" == "gzip" || "$ZIP" == "3" ]]; then
			ZIP="gzip"
		else
			ZIP="lzma"
		fi

		echo ""
		echo "DEB file name format (Default is DirectoryName.deb)"
		echo "This will get the package and version from ./DEBIAN/CONTROL"
		echo "1. author_package_version.deb"
		echo "2. package_version.deb"
		echo "3. package.deb"
		echo "4. None (Directory name)"
		read -p "" AUTONAME
		if [[ "$AUTONAME" == "1" ]]; then
			AUTONAME="1"
		elif [[ "$AUTONAME" == "2" ]]; then
			AUTONAME="2"
		elif [[ "$AUTONAME" == "3" ]]; then
			AUTONAME="3"
		elif [[ "$AUTONAME" == "4" ]]; then
			AUTONAME="4"
		else
			AUTONAME="4"
		fi
	
	# Reset profile
	elif [ "$lastset" == "reset" -o "$lastset" == "RESET" ]; then
		rm /User/Documents/dpkg-debtool.config
		printf '/\nlzma\nNone' > /User/Documents/dpkg-debtool.config

		echo ""
		echo "Config reset :P"
		echo ""
		exit 0
	else
		check="0"
	fi
done

rm /User/Documents/dpkg-debtool.config
printf $DEBROOT'\n'$ZIP'\n'$AUTONAME > /User/Documents/dpkg-debtool.config

cd $DEBROOT/DEBIAN

if [[ $AUTONAME != "4" ]]; then
	AUTHOR=$(grep Package: control | sed -e 's/Package://'  -e 's/ //' | awk -F "." '{ print $2}')
	PACKAGE=$(grep Package: control | sed -e 's/Package://'  -e 's/ //' | awk -F "." '{ print $3}')
	VERSION=$(grep Version: control | sed -e 's/Version://' -e 's/ //')
else
	if [[ $(echo "$DEBROOT" | awk -F "/" '{print $NF}') == "" ]]; then
		DEBFOLDER=$(echo "$DEBROOT" | awk -F "/" '{print $(NF-1)}')
	else
		DEBFOLDER=$(echo "$DEBROOT" | awk -F "/" '{print $NF}')
	fi
fi
	
if [ -f  preinst ]; then
   	chmod 755 ./preinst
else
   	echo "preinst not found"
fi

if [ -f  postinst ]; then    
   	chmod 755 ./postinst
else
   	echo "postinst not found"
fi
	
if [ -f  prerm ]; then
    	chmod 755 ./prerm
else
    echo "prerm not found"
fi

if [ -f  postrm ]; then
   	chmod 755 ./postrm
else
   	echo "postrm not found"
fi

# Delete unnecessary files
cd $DEBROOT
find ./ -iname ".DS_Store" -exec rm {}  \;
find ./ -iname "Thumbs.db" -exec rm {}  \;

case "$AUTONAME" in
	1 ) export DEBNAME=$AUTHOR\_$PACKAGE\_$VERSION.deb
		;;
	2 ) export DEBNAME=$PACKAGE\_$VERSION.deb
		;;
	3 ) export DEBNAME=$PACKAGE.deb
		;;
	* ) export DEBNAME=$DEBFOLDER.deb
		;;
esac

cd ../
dpkg-deb -bZ $ZIP $DEBROOT $DEBNAME
	
echo ""
echo "All done !"


	if [[ -f ./$DEBNAME ]]; then
	echo "=================================================="
	echo "md5 checksum:"
	md5sum $DEBNAME
	echo " "
	echo "file size:"
	stat -c%s $DEBNAME
	echo "=================================================="
	echo " "
else
	echo " "
fi