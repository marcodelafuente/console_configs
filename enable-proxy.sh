#!/bin/bash
if [ -f ~/.ssh/config ] || [ -f ~/.auth ]; then
	echo "Only one proxy enable session can be active at a time."
	echo "Please exit from a console that has proxy enable first."
	echo 'Type echo $PROXY_IS_SET to check which console is active.'
	exit -1;
fi

HOST="185.46.212.88"
PORT=80
if [ $USER = administrator ]; then
    read -p 'Username:' uservar
else
    uservar=$USER
fi
read -sp 'Password:' passvar

export http_proxy=http://$uservar:$passvar@$HOST:$PORT
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy   
export socks_proxy=$http_proxy
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$http_proxy
export FTP_PROXY=$http_proxy
export SOCKS_PROXY=$http_proxy
git config --global http.proxy $http_proxy 
git config --global core.gitproxy '/usr/bin/git-proxy.sh'
echo $uservar:$passvar > ~/.auth
echo "ProxyCommand /usr/bin/corkscrew 136.17.0.23 83 %h %p ~/.auth" > ~/.ssh/config

unset passvar
export PROXY_IS_SET=active
echo
$SHELL
git config --unset --global http.proxy
git config --unset --global core.gitproxy
rm ~/.auth
rm ~/.ssh/config
unset PROXY_IS_SET
