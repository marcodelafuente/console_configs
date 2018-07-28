#!/bin/bash
read -p 'Name:' namevar
read -p 'email:' emailvar
read -p 'Active Directory Domain:' addomainvar
HOST="185.46.212.88"
PORT=80

# Obtain password
echo 'The following password will be used for sudo and proxy settings.'
read -sp 'Password:' passvar
echo
echo 'Validating Password...'
echo $passvar | sudo -S echo 'Password Test' &> /dev/null
if [ $? -ne 0 ]; then
    echo 'Invalid password'
    exit
fi
echo 'OK'

# Configuring proxy settings
read -p "Use proxy? " -n 1 -r
USE_PROXY=$REPLY
if [[ $USE_PROXY =~ ^[Yy]$ ]]; then
    export http_proxy=http://$USER:$passvar@$HOST:$PORT
    export https_proxy=$http_proxy
fi

# Add additional sources
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list.d/virtualbox.list'

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list

sudo -E add-apt-repository ppa:jonathonf/vim

sudo -E apt update

# Download git
sudo -E apt -y install git

if [[ $USE_PROXY =~ ^[Yy]$ ]]; then
    git config --global http.proxy $http_proxy
fi

git config --global user.name "$namevar"
git config --global user.email $emailvar

# Download configs from github
mkdir ~/configs
cd ~/configs

git clone https://github.com/marcodelafuente/console_configs.git

echo $passvar | sudo -S echo 'Password Test' &> /dev/null

bash console_configs/config.sh $passvar $USE_PROXY $addomainvar
