#!/bin/bash
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

set -u -e -v

if (( $# != 1 )); then
	echo "Usage: ./gen.sh mode"
	echo "Example: ./gen.sh vesafb"
	echo "Example: ./gen.sh txtmode"
	echo "You need to specify exactly 1 argument"
	exit 1
fi

# This is where GRUB is expected to be (outside of the grub-assemble, instead in main checkout)
grubdir="../../../grub"

source "modules.conf"

if [ "$1" = "vesafb" ]
then
	# Generate the grub.elf (vesafb)
	$grubdir/grub-mkstandalone \
	  --grub-mkimage=$grubdir/grub-mkimage \
	  -O i386-coreboot \
	  -o grub_vesafb.elf \
	  -d $grubdir/grub-core/ \
	  --fonts= --themes= --locales=  \
	  --modules="$grub_modules" \
	  --install-modules="$grub_install_modules" \
	  /boot/grub/grub.cfg="../../../resources/grub/config/grub_memdisk.cfg" \
	  /background.jpg="../../../resources/grub/background/background.jpg" \
	  /dejavusansmono.pf2="../../../resources/grub/font/dejavusansmono.pf2" \
	  $(./grub_memdisk_keymap)
elif [ "$1" = "txtmode" ]
then
	# Generate the grub.elf (txtmode)
	$grubdir/grub-mkstandalone \
	  --grub-mkimage=$grubdir/grub-mkimage \
	  -O i386-coreboot \
	  -o grub_txtmode.elf \
	  -d $grubdir/grub-core/ \
	  --fonts= --themes= --locales=  \
	  --modules="$grub_modules" \
	  --install-modules="$grub_install_modules" \
	  /boot/grub/grub.cfg="../../../resources/grub/config/grub_memdisk.cfg" \
	  /memtest="../../../memtest86+-5.01/memtest" \
	  /invaders.exec="../../../grubinvaders/invaders.exec" \
	  $(./grub_memdisk_keymap)
else
	echo "grub-assemble gen.sh: invalid mode '$1'"
	exit 1
fi

