#!/usr/bin/env bash

. ./VARIABLES

rm -rf $MagiskExtractFolder

mkdir -p $MagiskExtractFolder

echo "Extracting Magisk"
unzip -oj "$MagiskRoot/"app-debug.apk "lib/x86_64/*.so" "lib/x86/libmagisk32.so" -d $MagiskExtractFolder

echo "Renaming files"
pushd $MagiskExtractFolder >> /dev/null
for file in lib*.so; do
  chmod 755 $file
  mv "$file" "${file:3:${#file}-6}"
done
popd >> /dev/null
