#!/usr/bin/env sh

echo Building GRUB ...
cd /build || exit
echo "insmod fat" > grub.cfg
echo "insmod linux" >> grub.cfg
echo "insmod gzio" >> grub.cfg
echo "set root=(hd0,gpt1)" >> grub.cfg
if [ "$ARCH" = "x64" ]; then
  format=x86_64-efi
else
  format=arm64-efi
fi
grub-mkimage -c grub.cfg -O $format -o grub -p /EFI/BOOT normal configfile part_gpt fat linux gzio

echo Packaging GRUB ...
mkdir /export
cd /export || exit
cp /build/grub .
cp /build/LICENSE .
echo "Source  : https://git.alpinelinux.org/aports/tree/main/grub?id=1895cf9fc22dde29d848d62c20eb0276ea2d34a7" > /export/SOURCE
echo "Version : 2.06-r2" >> /export/SOURCE
echo "Package : https://github.com/vmify/grub/releases/download/$TAG/grub-$ARCH-$TAG.tar.gz" >> /export/SOURCE

tar -czvf /grub.tar.gz *
