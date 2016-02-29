#!/bin/bash


chmod 777 /private
chmod 777 /private/var

chown mobile:mobile /private/var/mobile
chmod 755 /private/var/mobile

chown mobile:mobile /private/var/mobile/Library
chmod 755 /private/var/mobile/Library

chown mobile:mobile /private/var/mobile/Library/Preferences/com.apple.springboard.plist
chmod 755 /private/var/mobile/Library/Preferences/com.apple.springboard.plist
