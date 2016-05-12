#!/bin/sh

# Create Date	: 2016-05-11 18:46:30
# Mini code by	: Anto Rij
# Website	: http://www.antorij.com
# Email		: antorij@yahoo.com
# Deskripsi	: Simple shell script to install tigervnc, xfce desktop, mozilla firefox and flash player on Centos 32/64 Bit for VPS

# login as root
if [ "$(id -u)" != "0" ]; then
        echo "Please login as root"
        exit 1
fi


RIJ_BIT='uname -m'

if [ ${RIJ_BIT} == 'x86_64' ]; then
	# Repository EPEL
	wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	rpm -ivh epel-release-6-8.noarch.rpm

	# Repository RPMI
	# wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
	# rpm -ivh remi-release-6.rpm

else
	# Repository EPEL 
	wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	rpm -ivh epel-release-6-8.noarch.rpm

	# Repository RPMI
	# wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
	# rpm -ivh remi-release-6.rpm
fi



# Update Centos
yum update

# Uninstall Gnome/Desktop
yum grouperase "Desktop" -y
yum grouperase xfce -y

# Install xfce
yum groupinstall xfce -y

# install fonts
# yum groupinstall Fonts
# yum install xorg-x11-fonts-Type1 xorg-x11-fonts-misc 

#Install TigerVNC-Server
yum install tigervnc-server -y

# Setting tigerVNC
echo 'VNCSERVERS="1:root"' >> /etc/sysconfig/vncservers
echo 'VNCSERVERARGS[1]="-geometry 1024x768"' >> /etc/sysconfig/vncservers
/sbin/chkconfig vncserver on 
/sbin/service vncserver start
chkconfig --add vncserver
chkconfig --level 345 vncserver on

# Startup xfce
echo "#!/bin/sh" > /root/.vnc/xstartup
echo "/usr/bin/startxfce4" >> /root/.vnc/xstartup
chmod +x /root/.vnc/xstartup

#Install firefox & Flash Player
yum install firefox -y
rpm -ivh http://linuxdownload.adobe.com/linux/i386/adobe-release-i386-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
yum check-update -y
yum install flash-plugin -y

# Password TigerVNC & restart vncserver
vncpasswd
/sbin/service vncserver restart

#Reboot Centos
#reboot
