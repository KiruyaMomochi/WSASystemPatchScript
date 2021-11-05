#!/usr/bin/env bash

. ./VARIABLES

echo "Unmounting product.img"
umount $MountPointProduct

echo "Unmounting system_ext.img"
umount $MountPointSystemExt

echo "Unmounting vendor.img"
umount $MountPointVendor

echo "Unmounting system.img"
umount $MountPointSystem

echo "Unmounting vendor.img"
umount $MountPointVendor

echo "chk product.img"
e2fsck -p -f $ImagesRoot/product.img

echo "Resizing product.img"
resize2fs -M $ImagesRoot/product.img

echo "chk system.img"
e2fsck -p -f $ImagesRoot/system.img

echo "Resizing system.img"
resize2fs -M $ImagesRoot/system.img

echo "chk system_ext.img"
e2fsck -p -f $ImagesRoot/system_ext.img

echo "Resizing system_ext.img"
resize2fs -M $ImagesRoot/system_ext.img

echo "chk vendor.img"
e2fsck -p -f $ImagesRoot/vendor.img

echo "Resizing vendor.img"
resize2fs -M $ImagesRoot/vendor.img

echo "!! Unmounting completed !!"