#!/bin/bash
# 20200509_PWP
# 20230628.0009 PWP Generic Config for FreeBSD

clear
echo "These options are entirely based on my opinion, and may or may not be suitable for your particular needs."
echo -e "\033[4mThere is no warranty of any kind.\033[0m"
echo '
Copyright 2020 Paul W. Poteete
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'

printf "\n\n\n\033[1m\e[91mOnly run this script as root, after running: pkg install -y bash curl && bash\n\n\033[0m\n"
printf "\n\n\nIf you wish to continue, type the lowercase letter y and press enter: "
read var_agree
if [ $var_agree != 'y' ]
then
	echo -e "\n\033[1m\e[91mConfiguration Cancelled.\033[0m\n"
	exit 0
fi

echo -e "\n\n\n\033[1m\e[92mWell then... Let's get started!!!\033[0m\n\n"
sleep 1

echo -e "\n\033[1mInstalling base tools...(100-300 minutes)\033[0m"
pkg install -y wget
for app in git rsync john iperf bash bash-completion vim iftop lsblk htop inxi ; do pkg install -y $app; done

ln -s /usr/local/bin/bash /bin/bash

echo -e "\n\n\033[1mBacking up and Replacing configuration files...\033[0m"
cp -rvp /etc/rc.conf /etc/rc.conf.original
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
	mkdir /public
	chmod 777 /public
	echo '# Very liberal allowance for access to /public' >> /etc/exports
	echo '/public -maproot=nobody -alldirs -public' >> /etc/exports

cp -rvp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
	echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
cp -rvp /etc/motd /etc/motd.original
	curl -s https://raw.githubusercontent.com/paulwpoteete/prep_freebsd/master/motd > /etc/motd

echo -e "\n\033[1mUpdating the ROOT bash prompt and vimrc...\033[0m"
curl -s https://raw.githubusercontent.com/paulwpoteete/prep_freebsd/master/bashrc > /root/.bashrc
	if [ ! -f  /root/.bash_profile ] ; then ln -s /root/.bashrc /root/.bash_profile ; fi
	if [ -f  /root/.profile ] ; then mv /root/.profile /root/.profile.original && ln -s /root/.bashrc /root/.profile ; fi
curl -s https://raw.githubusercontent.com/paulwpoteete/prep_freebsd/master/vimrc > /root/.vimrc
chsh -s /usr/local/bin/bash root


if [ -d /home/student ]
then
	echo "Student User Detected"
	echo -e "\n\033[1mUpdating the STUDENT bash prompt and vimrc...\033[0m"
	curl -s https://raw.githubusercontent.com/paulwpoteete/prep_freebsd/master/bashrc > /home/student/.bashrc
	if [ ! -f  /home/student/.bash_profile ] ; then ln -s /home/student/.bashrc /home/student/.bash_profile ; fi
	if [ -f  /home/student/.profile ] ; then mv /home/student/.profile /home/student/.profile.original && ln -s /home/student/.bashrc /home/student/.profile ; fi
	curl -s https://raw.githubusercontent.com/paulwpoteete/prep_freebsd/master/vimrc > /home/student/.vimrc
	chsh -s /usr/local/bin/bash student
fi

ssh-keygen
cat /root/.ssh/id_rsa.pub >> authorized_keys

/usr/local/bin/inxi -F

exit 0
