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
      case $(<$outtmp) in
        1) 
          clear
          if rootfs_toggle_mount ; then
            dlg_msg "${mount_menu} ok"
          else
            dlg_msg "${mount_menu} error"
          fi
          ;;
        2) 
          clear
          rootfs_chroot || dlg_msg "chroot error"
          ;;
        3) 
          rootfs_emulate || dlg_msg "emulate error"
          ;;
        4) 
          run_xnest
          ;;
        5) 
          build_squashfs || dlg_msg "building error"
          ;;
        6) 
          build_initrd || dlg_msg "building error"
          ;;
        7) 
          build_livecd || dlg_msg "building error"
          ;;
        8) 
          livecd_emulate || dlg_msg "building error"
          ;;
        9)
          dlg --msgbox "(c) 2014 Abi Hafshin \nhttp://dipzenk.hafs.in/\n\nLicensed under MIT (http://opensource.org/licenses/MIT)" 10 41
          ;;
        *) 
          done=1 
          ;;
      esac
      
    else
      done=1
    fi
  done
}



tput smcup
main_menu
clear
tput rmcup
