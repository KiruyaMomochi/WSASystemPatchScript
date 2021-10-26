#!/bin/bash

. ./VARIABLES

echo "Unmounting product.img"
umount $MountPointProduct

echo "Unmounting system_ext.img"
umount $MountPointSystemExt

echo "Unmounting vendor.img"
umount $MountPointVendor

echo "Unmounting system.img"
umount $MountPointSystem

echo "!! Unmounting completed !!"