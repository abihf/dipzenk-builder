#!/usr/bin/bash

. ./config
. ./lib/helper

outtmp=/tmp/.dipzenk-$RANDOM

main_menu() {
  done=0
  while [ $done -eq 0 ]; do
    if rootfs_mounted; then
      mount_menu='Unmount'
    else
      mount_menu='Mount'
    fi
    dlg --cancel-label "Exit" --menu "Pilih menu" 16 41 10 \
      1 "${mount_menu} rootfs" \
      2 "Chroot" \
      3 "Emulate rootfs" \
      4 "Run Xnest" \
      5 "Rebuild system.sfs (rootfs updated)" \
      6 "Rebuild initrd (Kernel updated)" \
      7 "Rebuild CD" \
      8 "Emulate CD" \
      9 "About" \
      2> $outtmp
    out=$?
    if [ $out -eq 0 ] ; then
      clear
      do_cmd $(<$outtmp)
      echo -n "Press enter: "
      read line
    else
      done=1
    fi
  done
}

do_cmd() {
  case $1 in
    1|--toggle-mount)
      rootfs_toggle_mount 
      ;;
    -m|--mount)
      rootfs_mount
      ;;
    -u|--unmount)
      rootfs_unmount
      ;;
    2|-c|--chroot)
      rootfs_chroot
      ;;
    3|-e|--emulate)
      rootfs_emulate
      ;;
    4|-x|--xnest)
      run_xnest
      ;;
    5|-s|--build-squashfs)
      build_squashfs
      ;;
    6|-i|--build-initrd)
      build_initrd
      ;;
    7|-l|--build-livecd)
      build_livecd
      ;;
    8|-r|--run-livecd)
      livecd_emulate
      ;;
    *)
      cat "${DIR_BASE}/README"
      ;;
  esac
}

if [ -z "$1" ]; then
  tput smcup
  main_menu
  clear
  tput rmcup
else
  do_cmd $1
fi
