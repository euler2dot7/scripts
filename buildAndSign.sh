#!/bin/bash

PROJECT_NAME="AppName"
PACKAGE_NAME="app.package.name"
# Compile
clean=""
if [[ "$1" == "-c" ]]
then
	clean="clean"
fi
rm -f bin/*.apk
#ndk-build
time ant $clean release

# Sign
java -jar SignApk/signapk.jar \
	SignApk/platform.x509.pem \
	SignApk/platform.pk8 \
	bin/${PROJECT_NAME}-release-unsigned.apk \
	bin/${PROJECT_NAME}.apk

adb devices | grep 2E6408 | cut -sf 1 | parallel adb -s {} install -r bin/${PROJECT_NAME}.apk | grep -v -E "\[*\]"

exit 0
