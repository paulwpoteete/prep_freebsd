#!/bin/bash
# 20200509_PWP
# Configure an Ubuntu 20.04 RPi 3 for Production use
clear
printf "\n\nThis script will autoconfigure a RPi 3 for production use.\n"
echo "These options are entirely based on my opinion, and may or may not be suitable for your particular needs."
echo "(This process will remove netplan and snapd)"
echo -e "\033[4mThere is no warranty of any kind.\033[0m"
echo '
Copyright 2020 Paul W. Poteete
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'
printf "\n\nOnly run this script as root, after running: pkg install -y bash curl && bash\n\n"
printf "\n\n\nIf you wish to continue, type the lowercase letter y and press enter: "
read var_agree
if [ $var_agree != 'y' ]
then
	echo -e "\n\033[1m\e[91mConfiguration Cancelled.\033[0m\n"
	exit 0
fi

echo -e "\n\n\n\033[1m\e[92mWell then... Let's get started!!!\033[0m\n\n"
sleep 1

echo -e "\n\033[1mInstalling base tools...\033[0m"
pkg install -y wget
pkg install -y rsync john iperf p5-Bash-Completion-0.008_1 vim glusterfs-3.11.1_6

echo -e "\n\033[1mChecking Script Run Status...\033[0m"
if [ -f /etc/rc.conf.original ]
then
	echo -e "\n\n\n\033[1m\e[91mThis script has already been run.\033[0m\n\n"
	printf "If you want to revert all configuration changes and run the script again, type the lowercase letter y and press enter: "
	read var_run
		if [ $var_run == 'y' ]
		then
			for file in /etc/rc.conf /etc/exports /boot/msdos/config.txt /etc/sysctl.conf /etc/ssh/sshd_config /etc/motd
			do
				mv -vf $file.original $file
			done
			echo -e "\n\nReversion Complete..."
			sleep 1
		fi
fi

echo -e "\n\n\033[1mBacking up and Replacing configuration files...\033[0m"
cp -rvp /etc/rc.conf /etc/rc.conf.original
	var_iface=`ifconfig -a | grep "^[a-z]" | grep -v lo | awk -F":" '{ print $1 }'`
	sed -i -e s/DEFAULT\=\"DHCP\"/$var_iface\=\"inet\ 192.168.1.199\ netmask\ 255.255.255.0\"/g /etc/rc.conf
	echo 
	echo '' >> /etc/rc.conf
	echo '### Disable IPv6' >> /etc/rc.conf
	echo 'ipv6_enable="NO"' >> /etc/rc.conf
	echo 'ipv6_network_interfaces="NONE"' >> /etc/rc.conf
	echo '' >> /etc/rc.conf
	echo '### NFS Server and Client' >> /etc/rc.conf
	echo 'nfs_server_enable="YES"' >> /etc/rc.conf
	echo 'nfs_client_enable="YES"' >> /etc/rc.conf
	echo 'rpcbind_enable="YES"' >> /etc/rc.conf
	echo 'nfscbd_enable="YES"' >> /etc/rc.conf
	echo 'nfsuserd_enable="YES"' >> /etc/rc.conf
	echo 'rpc_lockd_enable="YES"' >> /etc/rc.conf
	echo 'rpc_statd_enable="YES"' >> /etc/rc.conf
	echo 'mountd_enable="YES"' >> /etc/rc.conf
	echo 'mountd_flags="-r"' >> /etc/rc.conf

cp -rvp /etc/exports /etc/exports.original
	echo '# Very liberal allowance for access to /mnt' >> /etc/exports
	echo '/mnt -maproot=nobody -alldirs -public' >> /etc/exports

cp -rvp /boot/msdos/config.txt /boot/msdos/config.txt.original
	echo 'arm_freq=900' >> /boot/msdos/config.txt

cp -rvp /etc/sysctl.conf /etc/sysctl.conf.original
	echo "dev.cpu.0.freq=900" >> /etc/sysctl.conf
cp -rvp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
cp -rvp /etc/motd /etc/motd.original
#	wget -O /etc/motd http://public.cybernados.net/pub/prep_freebsd/motd
	curl -s http://public.cybernados.net/pub/prep_freebsd/motd > /etc/motd

echo -e "\n\033[1mUpdating the bash prompt and vimrc...\033[0m"
#wget -O /root/.bashrc http://public.cybernados.net/pub/prep_freebsd/bashrc
curl -s http://public.cybernados.net/pub/prep_freebsd/bashrc > /root/.bashrc
	if [ ! -f  /root/.bash_profile ] ; then ln -s /root/.bashrc /root/.bash_profile ; fi
#wget -O /home/freebsd/.bashrc http://public.cybernados.net/pub/prep_freebsd/bashrc
curl -s http://public.cybernados.net/pub/prep_freebsd/bashrc > /home/freebsd/.bashrc
	if [ ! -f  /home/freebsd/.bash_profile ] ; then ln -s /home/freebsd/.bashrc /home/freebsd/.bash_profile ; fi
#wget -O /root/.vimrc http://public.cybernados.net/pub/prep_freebsd/vimrc
curl -s http://public.cybernados.net/pub/prep_freebsd/vimrc > /root/.vimrc
curl -s http://public.cybernados.net/pub/prep_freebsd/vimrc > /home/freebsd/.vimrc


chsh -s /usr/local/bin/bash root
chsh -s /usr/local/bin/bash freebsd

printf "\n\nConfiguration Complete.\nThe new IP address upon reboot will be 192.168.1.199\nIf you wish to change this, edit the /etc/rc.conf file now...\n\n"
exit 0

