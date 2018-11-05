#!/bin/sh

APPNAME="Sblack"

rm -rf ~/.build
mkdir ~/.build

rm ~/Desktop/${APPNAME}$1.zip
rm -rf ~/Desktop/${APPNAME}.app

xcodebuild -project Sblack.xcodeproj -scheme "Sblack" -derivedDataPath ~/.build -configuration Release

ditto /Users/frank/.build/Build/Products/Release/${APPNAME}.app ~/Desktop/${APPNAME}.app
open ~/Desktop

pushd ~/Desktop

zip --symlinks -r "${APPNAME}$1.zip" "${APPNAME}.app/"
zip --symlinks -r "${APPNAME}-latest.zip" "${APPNAME}.app/"
#ditto Evergreen$1.zip ~/Archive/Releases/

popd
