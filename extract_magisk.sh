#!/usr/bin/env bash

. ./VARIABLES

rm -rf $MagiskExtractFolder

mkdir -p $MagiskExtractFolder

echo "Extracting Magisk"
unzip -oj "$MagiskRoot/"app-debug.apk "lib/$Architecture/*.so" "lib/x86/libmagisk32.so" -d $MagiskExtractFolder
unzip -oj "$MagiskRoot/"app-debug.apk "lib/$SystemArchitecture/libmagiskinit.so" -d $MagiskRoot

echo "Renaming files"
mv $MagiskRoot/libmagiskinit.so $MagiskRoot/magiskpolicy
chmod 755 $MagiskRoot/magiskpolicy

pushd $MagiskExtractFolder >> /dev/null
for file in lib*.so; do
  chmod 755 $file
  mv "$file" "${file:3:${#file}-6}"
done
popd >> /dev/null

echo "!! Magisk folder ready !!"
