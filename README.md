# prep_freebsd
Automate the Configuration of FreeBSD 12 on a Raspberry Pi 3x

On your RPi...

1) Login (atomic pi installation video, #login as root)
	# Username=freebsd
	# Password=freebsd
2) Become root
	su -
	# Password=root
3) pkg install -y bash curl
4) bash
5) bash -c "$(curl https://raw.githubusercontent.com/paulwpoteete/prep_freebsd/master/prep_freebsd.sh)"

Images for FreeBSD can be found here:
32bit Pi2:
https://download.freebsd.org/ftp/snapshots/arm/armv7/ISO-IMAGES/12.1/FreeBSD-12.1-STABLE-arm-armv7-RPI2-20200430-r360472.img.xz
64bit Pi3+:
https://download.freebsd.org/ftp/releases/arm64/aarch64/ISO-IMAGES/12.1/FreeBSD-12.1-RELEASE-arm64-aarch64-RPI3.img.xz
