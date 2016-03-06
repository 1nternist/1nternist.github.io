#!/bin/bash

#############################################
###         iOS 8 Theme Fix Script        ###
### by Chir0student <chir0student@me.com> ###
###              Version 0.1              ###
#############################################


## App Bundle Directories ##

THEMES=/Library/Themes
PHONE=$THEMES/*/Bundles/com.apple.mobilephone
FACETIME=$THEMES/*/Bundles/com.apple.facetime
MESSAGES=$THEMES/*/Bundles/com.apple.MobileSMS
PREFERENCES=$THEMES/*/Bundles/com.apple.Preferences
CLOCKSMALL=$THEMES/*/Bundles/com.apple.mobiletimer
SPRINGBOARD=$THEMES/*/Bundles/com.apple.springboard
CONTACTS=$THEMES/*/Bundles/com.apple.MobileAddressBook
MAPS=$THEMES/*/Bundles/com.apple.Maps
IBOOKS=$THEMES/*/Bundles/com.apple.iBooks
WEATHER=$THEMES/*/Bundles/com.apple.weather
COMPASS=$THEMES/*/Bundles/com.apple.compass
STOCKS=$THEMES/*/Bundles/com.apple.stocks
PASSBOOK=$THEMES/*/Bundles/com.apple.Passbook
GAMECENTER=$THEMES/*/Bundles/com.apple.gamecenter


## iOS 7 AppIcon Names ##
# Phone
PHONE_120=icon@2x~iphone.png
PHONE_58=Icon-Small@2x~iphone.png
PHONE_40=Icon-BB@2x~iphone.png

# FaceTime
FACETIME_152=Icon-FaceTime@2x~ipad.png
FACETIME_120=Icon-FaceTime@2x~iphone.png
FACETIME_76=Icon-FaceTime~ipad.png
FACETIME_58=Icon-FaceTime-Small@2x~iphone.png
FACETIME_40=Icon-FaceTime-BB@2x~iphone.png

# Messages
MESSAGES_152=icon@2x~ipad.png
MESSAGES_120=icon@2x~iphone.png
MESSAGES_80=icon40@2x.png
MESSAGES_76=icon~ipad.png
MESSAGES_58=Icon-Small@2x.png
MESSAGES_40=icon20@2x.png

# Preferences
PREFERENCES_152=icon@2x~ipad.png
PREFERENCES_120=icon@2x~iphone.png
PREFERENCES_80=icon-about@2x.png
PREFERENCES_76=icon~ipad.png
PREFERENCES_58=icon-table@2x.png
PREFERENCES_40=icon-spotlight@2x.png
PREFERENCES_29=icon-table~ipad.png

# Clock
CLOCK_152=ClockIconBackgroundSquare@2x~ipad.png
CLOCK_120=ClockIconBackgroundSquare@2x~iphone.png
CLOCK_80=icon-about@2x.png
CLOCK_76=ClockIconBackgroundSquare~ipad.png
CLOCK_40=icon-spotlight@2x.png
CLOCK_20=icon-spotlight~ipad.png

# Contacts
CONTACTS_152=Icon@2x~ipad.png
CONTACTS_120=Icon@2x~iphone.png
CONTACTS_80=Icon-Spotlight@2x.png
CONTACTS_76=Icon~ipad.png
CONTACTS_58=Icon-Small@2x.png
CONTACTS_40=Icon-Notifications@2x.png
CONTACTS_29=Icon-Small.png
CONTACTS_20=Icon-Notifications.png

# Maps
MAPS_152=Icon-152.png
MAPS_120=Icon-120.png
MAPS_80=Icon-80.png
MAPS_76=Icon-76.png
MAPS_58=Icon-58.png
MAPS_40=Icon-40.png
MAPS_29=Icon-29.png
MAPS_20=icon-spotlight~ipad.png

# iBooks
IBOOKS_152=Icon-iPad@2x.png
IBOOKS_120=Icon-iPhone@2x.png
IBOOKS_80=80.png
IBOOKS_76=Icon-iPad.png
IBOOKS_58=Icon-Settings@2x.png
IBOOKS_29=Icon-Settings.png

# Weather
WEATHER_152=icon@2x.png
WEATHER_120=icon@2x.png
WEATHER_76=icon-ipad.png
WEATHER_58=Icon-spotlight@2x.png

# Compass
COMPASS_120=icon@2x~iphone.png
COMPASS_80=icon-about@2x.png
COMPASS_58=icon-table@2x.png
COMPASS_40=icon-spotlight@2x.png

# Stocks
STOCKS_120=icon@2x~iphone.png
STOCKS_80=icon-about@2x~iphone.png
STOCKS_58=icon-table@2x.png
STOCKS_40=icon-spotlight@2x~iphone.png

# Passbook
PASSBOOK_120=icon@2x.png
PASSBOOK_58=Icon-Small@2x.png

# Newsstand
NEWSSTANDENGLISH_290=EmptyNewsstandEnglish@2x.png
NEWSSTANDENGLISH_152=NewsstandIconEnglish@2x~ipad.png
NEWSSTANDENGLISH_120=NewsstandIconEnglish@2x~iphone.png
NEWSSTANDENGLISH_76=NewsstandIconEnglish~ipad.png

NEWSSTANDINTERNATIONAL_290=EmptyNewsstandInternational@2x.png
NEWSSTANDINTERNATIONAL_152=NewsstandIconInternational@2x~ipad.png
NEWSSTANDINTERNATIONAL_120=NewsstandIconInternational@2x~iphone.png
NEWSSTANDINTERNATIONAL_76=NewsstandIconInternational~ipad.png

# Game Center
GAMECENTER_152=Icon@2x~ipad.png
GAMECENTER_120=Icon@2x.png
GAMECENTER_80=Icon-Small-50@2x.png
GAMECENTER_76=Icon~ipad.png
GAMECENTER_58=Icon-Small@2x.png
GAMECENTER_40=Icon-Small@2x.png



##------------------------------------##


## iOS 8 AppIcon Names ##
APPICON_120=AppIcon60x60@2x.png
APPICON_80=AppIcon40x40@2x.png
APPICON_58=AppIcon29x29@2x.png
APPICON_40=AppIcon20x20@2x.png
APPICON_29=AppIcon29x29.png
APPICON_20=AppIcon20x20.png

APPICONIPAD_152=AppIcon76x76@2x~ipad.png
APPICONIPAD_80=AppIcon40x40@2x~ipad.png
APPICONIPAD_76=AppIcon76x76~ipad.png
APPICONIPAD_58=AppIcon29x29@2x~ipad.png
APPICONIPAD_40=AppIcon20x20@2x~ipad.png
APPICONIPAD_29=AppIcon29x29~ipad.png
APPICONIPAD_20=AppIcon20x20~ipad.png


##---------CODE----------##

for dir in $PHONE; do
	cp -f "${dir%%/}"/"$PHONE_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$PHONE_58" "${dir%%/}"/"$APPICON_58"
done

for dir in $FACETIME; do
	cp -f "${dir%%/}"/"$FACETIME_152" "${dir%%/}"/"$APPICONIPAD_152"
	cp -f "${dir%%/}"/"$FACETIME_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$FACETIME_76" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$FACETIME_76" "${dir%%/}"/"$APPICONIPAD_80"
	cp -f "${dir%%/}"/"$FACETIME_58" "${dir%%/}"/"$APPICON_58"
	cp -f "${dir%%/}"/"$FACETIME_58" "${dir%%/}"/"$APPICONIPAD_58"
done

for dir in $MESSAGES; do
	cp -f "${dir%%/}"/"$MESSAGES_152" "${dir%%/}"/"$APPICONIPAD_152"
	cp -f "${dir%%/}"/"$MESSAGES_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$MESSAGES_80" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$MESSAGES_80" "${dir%%/}"/"$APPICONIPAD_80"
	cp -f "${dir%%/}"/"$MESSAGES_58" "${dir%%/}"/"$APPICON_58"
	cp -f "${dir%%/}"/"$MESSAGES_58" "${dir%%/}"/"$APPICONIPAD_58"
done

for dir in $PREFERENCES; do
	cp -f "${dir%%/}"/"$PREFERENCES_152" "${dir%%/}"/"$APPICONIPAD_152"
	cp -f "${dir%%/}"/"$PREFERENCES_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$PREFERENCES_80" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$PREFERENCES_80" "${dir%%/}"/"$APPICONIPAD_80"
	cp -f "${dir%%/}"/"$PREFERENCES_58" "${dir%%/}"/"$APPICON_58"
	cp -f "${dir%%/}"/"$PREFERENCES_58" "${dir%%/}"/"$APPICONIPAD_58"
done

for dir in $CONTACTS; do
	cp -f "${dir%%/}"/"$CONTACTS_152" "${dir%%/}"/"$APPICONIPAD_152"
	cp -f "${dir%%/}"/"$CONTACTS_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$CONTACTS_80" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$CONTACTS_80" "${dir%%/}"/"$APPICONIPAD_80"
	cp -f "${dir%%/}"/"$CONTACTS_58" "${dir%%/}"/"$APPICON_58"
	cp -f "${dir%%/}"/"$CONTACTS_58" "${dir%%/}"/"$APPICONIPAD_58"
done

for dir in $MAPS; do
	cp -f "${dir%%/}"/"$MAPS_20" "${dir%%/}"/Icon-20.png
done

for dir in $IBOOKS; do
	cp -f "${dir%%/}"/"$IBOOKS_152" "${dir%%/}"/"$APPICONIPAD_152"
	cp -f "${dir%%/}"/"$IBOOKS_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$IBOOKS_80" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$IBOOKS_80" "${dir%%/}"/"$APPICONIPAD_80"
	cp -f "${dir%%/}"/"$IBOOKS_58" "${dir%%/}"/"$APPICON_58"
	cp -f "${dir%%/}"/"$IBOOKS_58" "${dir%%/}"/"$APPICONIPAD_58"
done

for dir in $WEATHER; do
	cp -f "${dir%%/}"/"$WEATHER_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$WEATHER_76" "${dir%%/}"/"$APPICON_80"
done

for dir in $COMPASS; do
	cp -f "${dir%%/}"/"$COMPASS_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$COMPASS_80" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$COMPASS_58" "${dir%%/}"/"$APPICON_58"
	cp -f "${dir%%/}"/"$COMPASS_40" "${dir%%/}"/"$APPICON_40"
done

for dir in $STOCKS; do
	cp -f "${dir%%/}"/"$STOCKS_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$STOCKS_80" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$STOCKS_58" "${dir%%/}"/"$APPICON_58"
	cp -f "${dir%%/}"/"$STOCKS_40" "${dir%%/}"/"$APPICON_40"
done

for dir in $PASSBOOK; do
	cp -f "${dir%%/}"/"$PASSBOOK_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$PASSBOOK_58" "${dir%%/}"/"$APPICON_58"
done

for dir in $GAMECENTER; do
	cp -f "${dir%%/}"/"$GAMECENTER_152" "${dir%%/}"/"$APPICONIPAD_152"
	cp -f "${dir%%/}"/"$GAMECENTER_120" "${dir%%/}"/"$APPICON_120"
	cp -f "${dir%%/}"/"$GAMECENTER_80" "${dir%%/}"/"$APPICON_80"
	cp -f "${dir%%/}"/"$GAMECENTER_80" "${dir%%/}"/"$APPICONIPAD_80"
done

exit 0
