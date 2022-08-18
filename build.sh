#!/usr/bin/env sh

echo Building GRUB ...
cd /build
echo "insmod fat" > grub.cfg
echo "insmod linux" >> grub.cfg
echo "insmod gzio" >> grub.cfg
echo "set root=(hd0,gpt1)" >> grub.cfg
echo "configfile /EFI/BOOT/GRUB.CFG" >> grub.cfg
if [ "$ARCH" = "x64" ]; then
  format=x86_64-efi
  output=bootx64.efi
else
  format=arm64-efi
  output=bootaa64.efi
fi
grub-mkimage -c grub.cfg -O $format -o $output -p /EFI/BOOT normal configfile part_gpt fat linux gzio

echo Packaging GRUB ...
mkdir /export
cd /export || exit
cp /build/$output .
cp /build/LICENSE .
echo "https://git.alpinelinux.org/aports/tree/main/grub?id=1895cf9fc22dde29d848d62c20eb0276ea2d34a7" > /export/SOURCE
echo "2.06-r2" > /export/VERSION

tar -czvf /grub.tar.gz *
