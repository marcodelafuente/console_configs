#!/bin/bash
passvar=$1
USE_PROXY=$2
addomainvar=$3
addomaincapsvar=${addomainvar^^}

# Install all the required packages
sudo -E apt -y install tmux vim dconf-tools virtualbox-5.2 virtualbox-ext-pack google-chrome-stable openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libssl-dev ccache libgl1-mesa-dev libxml2-utils samba system-config-samba gdebi-core sagasu xsltproc unzip libx11-6:i386 libxext6:i386 libxmu-dev:i386 rpm 

# Create a VirtualBox disk from /dev/sda
sudo usermod -a -G disk $USER
sudo adduser $USER vboxusers
mkdir -d ~/VirtualBox\ VMs/Windows\ 7/
echo '----------------------------------------------------------------'
echo 'Need to logout before new group is added correctly and be able to execute the following command:'
echo
echo 'VBoxManage internalcommands createrawvmdk -filename ~/VirtualBox\ VMs/Windows\ 7/Windows\ 7.vmdk -rawdisk /dev/sda'
echo
echo '----------------------------------------------------------------'

# Set the lauch bar in the bottom
sudo gsettings set com.canonical.Unity.Launcher launcher-position Bottom

# Add computer to the Active Directory
sudo -E apt -y install realmd sssd sssd-tools samba-common krb5-user packagekit samba-common-bin samba-libs adcli ntp

echo "server $addomainvar" | sudo tee -a /etc/ntp.conf &> /dev/null
sudo /etc/init.d/ntp restart

echo "[users]" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "default-home = /home/%U" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "default-shell = /bin/bash" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "[active-directory]" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "default-client = sssd" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "os-name = Ubuntu Desktop" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "os-version = 16.04" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "[service]" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "automatic-install = no" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "[$addomainvar]" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "fully-qualified-names = no" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "automatic-id-mapping = yes" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "user-principal = yes" | sudo tee -a /etc/realmd.conf &> /dev/null
echo "manage-system = no" | sudo tee -a /etc/realmd.conf &> /dev/null

sudo kinit $USER@$addomaincapsvar
sudo realm --verbose join $addomainvar --user-principal=UBUNTU/$USER@$addomaincapsvar

sudo sed -i '/\# end of pam-auth-update config/i \
session required pam_mkhomedir.so skel=/etc/skel/ umask=0077' /etc/pam.d/common-session

sudo sed -i "/allowed_users=console/c\allowed_users=anybody" /etc/X11/Xwrapper.config

sudo sed -i "/access_provider = simple/c\access_provider = ad" /etc/sssd/sssd.conf
sudo sed -i '/krb5_store_password_if_offline = True/a \
ad_gpo_access_control = permissive' /etc/sssd/sssd.conf

sudo service sssd restart

sudo sed -i "/sudoers: *files sss/c\sudoers:        files" /etc/nsswitch.conf

# Change Caps Lock to Control
dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"

# Create symbolic link for configurations
ln -s ~/configs/console_configs/enable-proxy.sh ~/bin/enable-proxy.sh
chmod +x ~/bin/enable-proxy.sh 

ln -s ~/configs/console_configs/.vimrc ~/.vimrc
ln -s ~/configs/console_configs/.tmux.conf ~/.tmux.conf

# Download Repo tool
wget 'https://storage.googleapis.com/git-repo-downloads/repo' -P ~/bin
chmod +x ~/bin/repo
