#!/usr/bin/env bash

. ./VARIABLES

echo "Copying magisk files"
mkdir $MountPointSystem/sbin
for file in magisk32 magisk64 magiskinit; do
chmod 755 $MagiskExtractFolder/$file
cp -af $MagiskExtractFolder/$file $MountPointSystem/sbin/
done

echo "Appending magisk init script"
INIT_RC="$MountPointSystem/system/etc/init/hw/init.rc"
grep -q "magisk" "$INIT_RC" || cat >> "$INIT_RC" << EOF
on post-fs-data
    start logd
    start adbd
    mkdir /dev/wsa-magisk
    mount tmpfs tmpfs /dev/wsa-magisk mode=0755
    copy /sbin/magisk64 /dev/wsa-magisk/magisk64
    chmod 0755 /dev/wsa-magisk/magisk64
    symlink ./magisk64 /dev/wsa-magisk/magisk
    symlink ./magisk64 /dev/wsa-magisk/su
    symlink ./magisk64 /dev/wsa-magisk/resetprop
    copy /sbin/magisk32 /dev/wsa-magisk/magisk32
    chmod 0755 /dev/wsa-magisk/magisk32
    copy /sbin/magiskinit /dev/wsa-magisk/magiskinit
    chmod 0755 /dev/wsa-magisk/magiskinit
    symlink ./magiskinit /dev/wsa-magisk/magiskpolicy
    mkdir /dev/wsa-magisk/.magisk 700
    mkdir /dev/wsa-magisk/.magisk/mirror 700
    mkdir /dev/wsa-magisk/.magisk/block 700
    rm /dev/.magisk_unblock
    start FAhW7H9G5sf
    wait /dev/.magisk_unblock 80
    rm /dev/.magisk_unblock

service FAhW7H9G5sf /dev/wsa-magisk/magisk --post-fs-data
    user root
    seclabel u:r:magisk:s0
    oneshot

service HLiFsR1HtIXVN6 /dev/wsa-magisk/magisk --service
    class late_start
    user root
    seclabel u:r:magisk:s0
    oneshot

on property:sys.boot_completed=1
    start YqCTLTppv3ML

service YqCTLTppv3ML /dev/wsa-magisk/magisk --boot-complete
    user root
    seclabel u:r:magisk:s0
    oneshot
EOF

echo "Appending vendor file contexts"
VENDOR_FILE_CONTEXTS="$MountPointSystem/vendor/etc/selinux/vendor_file_contexts"
grep -q "magisk" "$VENDOR_FILE_CONTEXTS" || cat >> "$VENDOR_FILE_CONTEXTS" << EOF
/dev/wsa-magisk(/.*)? u:object_r:magisk_file:s0
EOF

echo "Setting permissions"
chmod 0700 $MountPointSystem/sbin
chmod 0755 $MountPointSystem/sbin/*

echo "Applying root file ownership"
chown -R root:root $MountPointSystem/sbin

echo "Applying SELinux security contexts"
chcon u:object_r:rootfs:s0 $MountPointSystem/sbin
chcon u:object_r:system_file:s0 $MountPointSystem/sbin/*

echo "Applying magisk policies"
$MagiskRoot/magiskpolicy --load $MountPointSystem/vendor/etc/selinux/precompiled_sepolicy --save $MountPointSystem/vendor/etc/selinux/precompiled_sepolicy --magisk "allow * magisk_file lnk_file *"

echo "!! Magisk apply completed !!"
