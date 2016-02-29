#!/bin/bash


##### root test #####
# won't go any farther unless you're uid=0
[ `id -u` != 0 ] && exec echo "Oops, you need to be root to run this script"

#set variables
infile=$1
workdir="`pwd`"
downloads=/var/mobile/Downloads
#and colors
R=$(tput bold; tput setaf 1)
G=$(tput bold; tput setaf 2)
Y=$(tput bold; tput setaf 3)
Pl=$(tput bold; tput setaf 4)
Pk=$(tput bold; tput setaf 5)
Cn=$(tput bold; tput setaf 6)
r=$(tput setaf 1)
g=$(tput setaf 2)
y=$(tput setaf 3)
pl=$(tput setaf 4)
pk=$(tput setaf 5)
cn=$(tput setaf 6)
bld=$(tput bold)
b=$(tput sgr0)





pause(){
    read -p ""$R"      --> "$b""$bld"Press [Enter] key to continue..."$b"" fackEnterKey
}

function dircheck () {
if [ ! -d "$downloads" ]; then
	mkdir -p "$downloads"
fi
if [ "`pwd`" != "$downloads" ]; then
	cp -f "$infile" "$downloads"
fi
cd "$downloads"
}

function filecheck () {
	filetype=$(file --mime-type "$infile" | awk '{ print $NF }' | cut -d '/' -f1)
if [[ "$infile" = "--help" ]] || [[ "$infile" = "-h" ]] || [[ "$infile" = "" ]]; then
	showhelp
	sleep 2
	exit 0
elif [[ "$infile" != "" ]]; then
	if [[ "$filetype" = "audio" ]]; then
		ORIG=$infile
	elif [[ "$filetype" = "video" ]]; then
		ORIG=$infile
	else
		echo "Please choose an audio file!"
		exit 0
	fi
fi
}

function showhelp () {
clear
echo "$Y#############*$Cn*****iRingtone Help*****$Y*#############"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "$Y##$R   HHH    HHH  EEEEEEEE  LLL       PPPPPPPP     $Y##"
echo "$Y##$R   HHH    HHH  EEE       LLL       PPP    PPP   $Y##"
echo "$Y##$R   HHH    HHH  EEE       LLL       PPP     PP   $Y##"
echo "$Y##$R   HHHHHHHHHH  EEEEEE    LLL       PPP    PPP   $Y##"
echo "$Y##$R   HHH    HHH  EEE       LLL       PPPPPPPP     $Y##"
echo "$Y##$R   HHH    HHH  EEE       LLL       PPP          $Y##"
echo "$Y##$R   HHH    HHH  EEE       LLL       PPP          $Y##"
echo "$Y##$R   HHH    HHH  EEEEEEEE  LLLLLLLL  PPP          $Y##"
echo "$Y####################################################$b"
echo "$Y##$Cn iRingtone 3.0:$b Ringtone maker for iOS          $Y##"
echo "$Y##$Cn Developer:$b Chir0student <chir0student@me.com>  $Y##"
echo "$Y##$Cn What is iRingtone?$b                             $Y##"
echo "$Y##$b   iRingtone is a script that can               $Y##"
echo "$Y##$b   turn any audio or video                      $Y##"
echo "$Y##$b   into a customized ringtone.                  $Y##"
echo "$Y##$Cn How do I use iRingtone?                        $Y##"
echo "$Y##$b    In MobileTerminal execute:                  $Y##"
echo "$Y##$G    sudo iRingtone /path/to/audio/file.mp3      $Y##"
echo "$Y##$b    Then follow the script instructions.        $Y##"
echo "$Y##$Cn Where can I find my new ringtone?$b              $Y##"
echo "$Y##$b    You can select your new ringtone            $Y##"
echo "$Y##$b    by opening Settings > Sounds                $Y##"
echo "$Y##$b                                                $Y##"
echo "$Y##$R NOTE: if you are on iOS 7+ then                $Y##"
echo "$Y##$R       you must have ToneEnabler                $Y##"
echo "$Y##$R       from BigBoss repo installed              $Y##"
echo "$Y##$R       on your device.                          $Y##"
echo "$Y####################################################$b"
}

function startover () {
	clear
	/usr/local/bin/iRingtone "$infile"
}

function mainmenu () {
clear
echo "$Y####################################################"
echo "$Y##$Pl##############*$Cn*****iRingtone*****$Pl*#############$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##$R                    Main Menu                   $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "##                                                ##"  
echo "##    "$b""$g"Welcome to iRingtone                        $Y##"
echo "##    "$b""$g"Please choose an option (1-3)               $Y##"
echo "##                                                ##"
echo "##    "$R"Options:"$Y"                                    ##"
echo "##                                                ##"
echo "##     "$R"1) "$b"Create Ringtone                         $Y##"
echo "##     "$R"2) "$b"Ringtone Manager                        $Y##"
echo "##     "$R"3) "$b"Cancel                                  $Y##"
echo "##                                                ##"
echo ""$Y"####################################################"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##          "$b""$g"For instructions type "$b""$bld"'help'          $Y##"
echo "$Y##$Cn------------------------------------------------$Y##"
echo "$Y##     "$b""$g"To return to the main menu type "$b""$bld"'home'     $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y####################################################"
echo
read -p "      "$b""$bld"Your Choice: "$b""$bld"" choice
echo

if [ "$choice" = "1" ]; then
	iRingtone     
fi

if [ "$choice" = "2" ]; then
	renametone    
fi

if [ "$choice" = "3" ]; then
	echo
	echo "Thank you for using iRingtone!"
	echo "Goodbye"
	echo
	exit 0
fi

if [ "$choice" = "help" ]; then
	showhelp
fi

if [ "$choice" = "home" ]; then 
	startover
fi
if [[ "$choice" != "1" ]] && [[ "$choice" != "2" ]] && [[ "$choice" != "3" ]]; then
	echo "$Cn      **You have selected an invalid option.**"
	echo "$Cn		**Please try again**"
	echo
	sleep 5
	startover
fi
}

function abitrateloop () {
	abitrate
}

function abitrate () {
clear
echo "$Y####################################################"
echo "$Y##$Pl##############*$Cn*****iRingtone*****$Pl*#############$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##$R                 Ringtone Quality               $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "##                                                ##"
echo "##    "$b""$g"Please select the sound quality for your    $Y##"
echo "##    "$b""$g"new ringtone.                               $Y##"
echo "##                                                ##"
echo "##    "$R"Options:"$Y"                                    ##"
echo "##                                                ##"
echo "##     "$R"1) "$b"Normal (128k)"$Y"                           ##"
echo "##     "$R"2) "$b"High Quality (192k)"$Y"                     ##"
echo "##     "$R"3) "$b"Very High Quality (256k)"$Y"                ##"
echo "##                                                ##"
echo "####################################################"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "##                 "$R"Configuration:"$Y"                 ##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y####################################################"
echo
echo ""$R"      >> "$b""$bld" In-File: "$G" "$infile""$b""
echo ""$R"      >> "$b""$bld"New Name: "$G" "$NEW".m4r"
read -p ""$G"      >> "$b""$bld" Quality:  "$G"" quality
echo
if [ "$quality" == "1" ]; then
	echo ""$G"        "$b"You chose:  "$g"Normal (128k)"$b""
	ab="128000"
	abgui="128k"
fi
if [ "$quality" == "2" ]; then
	echo ""$G"        "$b"You chose:  "$g"High Quality (192k)"$b""
	ab="192000"
	abgui="192k"
fi
if [ "$quality" == "3" ]; then
	echo ""$G"        "$b"You chose:  "$g"Very High Quality (256k)"$b""
	ab="256000"
	abgui="265k"
fi
if [[ "$quality" != "1" ]] && [[ "$quality" != "2" ]] && [[ "$quality" != "3" ]]; then
	echo "Please enter 1, 2 or 3"
	abitrateloop
fi
read -p ""$G"        "$b"Is this correct? (y/n) "$bld"" bitrate
if [ "$bitrate" = "n" ]; then
	abitrateloop
fi
if [ "$bitrate" = "y" ]; then
	echo
	echo ""$G"        "$g"$abgui "$b"confirmed"
fi
if [[ "$bitrate" != "y" ]] && [[ "$bitrate" != "n" ]]; then
	echo
	echo "          "$b""$bld"Please select y or n."$b""
	sleep 2
	abitrateloop
fi
}

function astartloop () {
	astart
}
function astart () {
clear
echo "$Y####################################################"
echo "$Y##$Pl##############*$Cn*****iRingtone*****$Pl*#############$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##$R                   Start Time                   $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "##                                                ##"
echo "##    "$b""$g"Please select a start time in seconds       $Y##"
echo "##    "$b""$g"for your new ringtone.                      $Y##"
echo "##                                                ##"
echo "##    "$b""$R"Example:"$b" A time of "$bld"1:20 "$b"would be            $Y##"
echo "##             "$b""$bld"80 "$b"seconds.                        $Y##"
echo "##                                                ##"
echo "####################################################"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "##                 "$R"Configuration:"$Y"                 ##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y####################################################"
echo
echo ""$R"      >> "$b""$bld" In-File: "$G" "$infile""$b""
echo ""$R"      >> "$b""$bld"New Name: "$G" "$NEW".m4r"
echo ""$R"      >> "$b""$bld" Quality: "$G" "$abgui""$b""
read -p ""$G"      >> "$b""$bld"   Start:  "$G"" starttime
echo
if [[ -z $(echo $starttime | grep "^[0.1-9]\+$") ]] && [[ "$starttime" != "" ]]; then 
	echo "          "$b""$bld"Start time must be a number!"
	sleep 2
	astartloop
elif [ "$starttime" = "" ]; then
	echo ""$G""$b"      You entered:  "$G"0"$b" seconds"
	read -p "$G$b      Is this correct? (y/n) "$bld"" starttimeanswer0
	if [ "$starttimeanswer0" = "n" ]; then
		astartloop
	fi
	if [ "$starttimeanswer0" = "y" ]; then
		ss="0"
	fi
	if [[ "$starttimeanswer0" != "y" ]] && [[ "$starttimeanswer0" != "n" ]]; then
		echo
		echo "          "$b""$bld"Please select y or n."$b""
		sleep 2
		astartloop
	fi
else
	echo ""$G""$b"      You entered:  "$G""$starttime""$b" seconds"
	read -p "$G$b      Is this correct? (y/n) "$bld"" starttimeanswer
	if [ "$starttimeanswer" = "n" ]; then
		astartloop
	fi
	if [ "$starttimeanswer" = "y" ]; then
		ss="$starttime"
	fi
	if [[ "$starttimeanswer" != "y" ]] && [[ "$starttimeanswer" != "n" ]]; then
		echo
		echo "          "$b""$bld"Please select y or n."$b""
		sleep 2
		astartloop
	fi
fi
}

function adurationloop () {
	aduration
}

function aduration () {
clear
echo "$Y####################################################"
echo "$Y##$Pl##############*$Cn*****iRingtone*****$Pl*#############$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##$R                    Duration                    $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "##                                                ##"
echo "##    "$b""$g"Please choose the duration in seconds       $Y##"
echo "##    "$b""$g"for your new ringtone.                      $Y##"
echo "##                                                ##"
echo "##    "$b""$R"Attention: "$b"iTunes will only accept          $Y##"
echo "##               "$b"ringtones that are 40 sec        $Y##"
echo "##               "$b"or less.                         $Y##"
echo "##                                                ##"
echo "####################################################"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "##                 "$R"Configuration:"$Y"                 ##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y####################################################"
echo
echo ""$R"      >> "$b""$bld" In-File: "$G" "$infile""$b""
echo ""$R"      >> "$b""$bld"New Name: "$G" "$NEW".m4r"
echo ""$R"      >> "$b""$bld" Quality: "$G" "$abgui""$b""
echo ""$R"      >> "$b""$bld"   Start: "$G" "$ss" sec"$b""
read -p ""$G"      >> "$b""$bld"Duration:  "$G"" durationtime
echo
if [[ -z $(echo $durationtime | grep "^[0.1-9]\+$") ]] && [[ "$durationtime" != "" ]]; then 
	echo "          "$b""$bld"The duration must be a number!"
	sleep 2
	adurationloop
elif [ "$durationtime" = "" ]; then
	echo ""$G""$b"      You entered:  "$G"0"$b" seconds"
	read -p "$G$b      Is this correct? (y/n) "$bld"" durationtimeanswer0
	if [ "$durationtimeanswer0" = "n" ]; then
		adurationloop
	fi
	if [ "$durationtimeanswer0" = "y" ]; then
		echo "          "$b""$bld"The duration time cannot be 0 seconds."
		echo "          "$b""$bld"Please select a valid duration time."
		sleep 2
		adurationloop
	fi
	if [[ "$durationtimeanswer0" != "y" ]] && [[ "$durationtimeanswer0" != "n" ]]; then
		echo
		echo "          "$b""$bld"Please select y or n."$b""
		sleep 2
		adurationloop
	fi
else
	echo ""$G""$b"      You entered:  "$G""$durationtime""$b" seconds"
	read -p "$G$b      Is this correct? (y/n) "$bld"" durationtimeanswer
	if [ "$durationtimeanswer" = "n" ]; then
		adurationloop
	fi
	if [ "$durationtimeanswer" = "y" ]; then
		t="$durationtime"
	fi
	if [[ "$durationtimeanswer" != "y" ]] && [[ "$durationtimeanswer" != "n" ]]; then
		echo
		echo "          "$b""$bld"Please select y or n."$b""
		sleep 2
		adurationloop
	fi
fi
}

function avolumeloop () {
	avolume
}

function avolume () {
clear
echo "$Y####################################################"
echo "$Y##$Pl##############*$Cn*****iRingtone*****$Pl*#############$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##$R                     Volume                     $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "##                                                ##"
echo "##    "$b""$g"If you wish to adjust the ringtone volume   $Y##"
echo "##    "$b""$g"level, you may do so in this setting.       $Y##"
echo "##                                                ##"
echo "##    "$b""$R"Example:"$b"  120% volume = 1.2                 $Y##"
echo "##    "$b"          100% volume = 1.0                 $Y##"
echo "##    "$b"           80% volume = 0.8                 $Y##"
echo "##                                                ##"
echo "####################################################"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "##                 "$R"Configuration:"$Y"                 ##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y####################################################"
echo
echo ""$R"      >> "$b""$bld" In-File: "$G" "$infile""$b""
echo ""$R"      >> "$b""$bld"New Name: "$G" "$NEW".m4r"
echo ""$R"      >> "$b""$bld" Quality: "$G" "$abgui""$b""
echo ""$R"      >> "$b""$bld"   Start: "$G" "$ss" sec"$b""
echo ""$R"      >> "$b""$bld"Duration: "$G" "$t" sec"$b""
read -p ""$G"      >> "$b""$bld"  Volume:  "$G"" volumeadjust
echo
if [[ -z $(echo $volumeadjust | grep "^[0.1-9]\+$") ]] && [[ "$volumeadjust" != "" ]]; then 
	echo "          "$b""$bld"The volume setting must be a number!"
	sleep 2
	avolumeloop
elif [ "$volumeadjust" = "" ]; then
	echo ""$G""$b"      You entered:  "$G"nothing"$b""
	echo ""$G""$b"      Would you like to leave the" 
	read -p "$G$b      volume unchanged? (y/n) "$bld"" volumeadjustanswer0
	if [ "$volumeadjustanswer0" = "n" ]; then
		avolumeloop
	fi
	if [ "$volumeadjustanswer0" = "y" ]; then
		echo "          "$b""$bld"The volume will remain unchanged."
		af="1.0"
	fi
	if [[ "$volumeadjustanswer0" != "y" ]] && [[ "$volumeadjustanswer0" != "n" ]]; then
		echo
		echo "          "$b""$bld"Please select y or n."$b""
		sleep 2
		avolumeloop
	fi
else
	echo ""$G""$b"      You entered:  "$G""$volumeadjust""$b""
	read -p "$G$b      Is this correct? (y/n) "$bld"" volumeadjustanswer
	if [ "$volumeadjustanswer" = "n" ]; then
		avolumeloop
	fi
	if [ "$volumeadjustanswer" = "y" ]; then
		t="$volumeadjust"
	fi
	if [[ "$volumeadjustanswer" != "y" ]] && [[ "$volumeadjustanswer" != "n" ]]; then
		echo
		echo "          "$b""$bld"Please select y or n."$b""
		sleep 2
		avolumeloop
	fi
fi
}

function confirmsettingsloop () {
	confirmsettings
}

function confirmsettings () {
clear
echo "$Y####################################################"
echo "$Y##$Pl##############*$Cn*****iRingtone*****$Pl*#############$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##$R                Confirm Settings                $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "##                                                ##"
echo "##    "$b""$g"Please confirm the settings for your new    $Y##"
echo "##    "$b""$g"ringtone.                                   $Y##"
echo "##                                                ##"
echo "##    "$b""$R"Attention:                                  $Y##"
echo "##                                                ##"
echo "##      "$b"After confirming your settings            $Y##"
echo "##      "$b"iRingtone will create your ringtone,      $Y##"
echo "##      "$b"and you will be able to select it in      $Y##"
echo "##      "$b"Settings > Sounds.                        $Y##"
echo "##                                                ##"
echo "####################################################"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "##                 "$R"Configuration:"$Y"                 ##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y####################################################"
echo
echo ""$R"      >> "$b""$bld" In-File: "$G" "$infile""$b""
echo ""$R"      >> "$b""$bld"New Name: "$G" "$NEW".m4r"
echo ""$R"      >> "$b""$bld" Quality: "$G" "$abgui""$b""
echo ""$R"      >> "$b""$bld"   Start: "$G" "$ss" sec"$b""
echo ""$R"      >> "$b""$bld"Duration: "$G" "$t" sec"$b""
echo ""$R"      >> "$b""$bld"  Volume: "$G" "$af""$b""
echo
echo ""$G"        "$b"iRingtone is ready to create your ringtone."
read -p ""$G"        "$b"Would you like to proceed? (y/n) "$bld"" makeringtone
echo
if [ "$makeringtone" = "n" ]; then
	iRingtonestartover
fi
if [ "$makeringtone" = "y" ]; then
	ffmpeg -i "$ORIG" -strict -2 -vn -ac 2 -ab "$ab" -ss "$ss" -t "$t" -af volume="$af" -acodec aac -f mp4 -y "$NEW".m4a >/dev/null 2>&1
fi
if [[ "$makeringtone" != "y" ]] && [[ "$makeringtone" != "n" ]]; then
	echo
	echo "          "$b""$bld"Please select y or n."$b""
	sleep 2
	confirmsettingsloop
fi

chown root:admin "$NEW".m4a
chmod 0664 "$NEW".m4a
mv "$NEW".m4a /Library/Ringtones/"$NEW".m4r
echo
echo "          "$b""$bld"Done!"
echo "          "$b"You can now find "$G""$NEW""$b".m4r"$bld""
echo "          "$b"in$Y Settings $b>$Y Sounds$b with other ringtones"
echo
echo
rm -rf *.irt
exit 0
}

function iRingtonestartover () {
	iRingtone
}

function newnameloop () {
	echo
	echo ""$R"      Error, you must choose a name for your ringtone!"
	echo
	echo ""$R"                     **TRY AGAIN!**$b"
	echo
	sleep 2
	iRingtone
}

function correctnameloop () {
	echo
	echo "      Please re-enter a name for your ringtone."
	echo
	sleep 2
	iRingtone
}

function iRingtone () {
clear
echo "$Y####################################################"
echo "$Y##$Pl##############*$Cn*****iRingtone*****$Pl*#############$Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y##$R                New Ringtone Name               $Y##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "####################################################"
echo "##                                                ##"
echo "##    "$b"Welcome to iRingtone's configuration        $Y##"
echo "##    "$b"utility. Here we will customize the script  $Y##"
echo "##    "$b"variables.                                  $Y##"
echo "##                                                ##"
echo "##    "$b""$g"Please choose a name for your ringtone.     $Y##"
echo "##                                                ##"
echo "####################################################"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "##                 "$R"Configuration:"$Y"                 ##"
echo "##-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y-$R-$Y##"
echo "$Y####################################################"
echo
echo ""$R"      >> "$b""$bld" In-File: "$G" "$infile""$b""
read -p ""$G"      >> "$b""$bld"New Name:  "$G"" newname
echo "$newname" > newname.irt
echo
NEW="`cat newname.irt`"
if [ "$NEW" = "" ]; then
	newnameloop
else
	echo "$G  $b    You entered:$G  $NEW$b"
	read -p "$G  $b    Is this correct? (y/n) "$bld"" confirm
	if [ "$confirm" = "n" ]; then
		correctnameloop
	fi
	if [ "$confirm" = "y" ]; then
		echo "$G     $b Your ringtone will be saved as:$G $NEW$b.m4r"
		echo
	fi
	if [[ "$confirm" != "y" ]] && [[ "$confirm" != "n" ]]; then
		echo
		echo "      "$b"Please select y or n."
		sleep 2
		correctnameloop
	fi
fi
pause
abitrate
astart
aduration
avolume
confirmsettings
clear
}

dircheck
filecheck
mainmenu
