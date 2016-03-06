#/bin/bash


## lighttpd-tool v1.0
## Written by: Chir0student <chir0student@me.com>
## January 27th 2014

TMP=/tmp
PID="$TMP"/lighttpd.pid
GETPID=$(launchctl list | grep lighttpd | grep -v net.was.lighttpd | grep -v com.myrepospace.chir0student.lighttpd-tool | awk '{ print $3 }' > "$PID")
lspid=$(echo "`cat /tmp/lighttpd.pid | grep lighttpd`")
SERVER_ON="WebServer is running. Would you like to stop it, or keep it running?"
SERVER_ON_A1="Stop it"
SERVER_ON_A2="Keep it running"
SERVER_OFF="WebServer is not running. Would you like to start it now, or leave it off?"
SERVER_OFF_A1="Start it"
SERVER_OFF_A2="Leave off"
CMD1=$(launchctl unload -w /Library/LaunchDaemons/com.myrepospace.chir0student.lighttpd-tool.plist)
CMD2=$(launchctl load -w /Library/LaunchDaemons/com.myrepospace.chir0student.lighttpd-tool.plist)
CMD3=$(exit 0)



function lighttpd_on () {
echo "$SERVER_ON"
echo -e "\n1) $SERVER_ON_A1\n2) $SERVER_ON_A2\n3) Exit\n"
read answers
if [ "$answer" == "1" ]; then
    "$CMD1"
fi
if [ "$answer" == "2" ]; then
    "$CMD2"
fi
if [ "$answer" == "3" ]; then
    "$CMD3"
fi
}

function lighttpd_off () {
echo "$SERVER_OFF"
echo -e "\n1) $SERVER_OFF_A1\n2) $SERVER_OFF_A2\n3) Exit\n"
read answers
if [ "$answer" == "1" ]; then
    "$CMD2"
fi
if [ "$answer" == "2" ]; then
    "$CMD1"
fi
if [ "$answer" == "3" ]; then
    "$CMD3"
fi
}

if [ -e "$PID" ]; then
    rm -rf "$PID"
    $GETPID
fi



if [ "$lspid" == "lighttpd" ]; then
    lighttpd_on
else
	lighttpd_off
fi


exit 0
