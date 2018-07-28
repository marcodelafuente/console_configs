HOST="185.46.212.88"
PORT=80
read -sp 'Password:' passvar

export http_proxy=http://$USER:$passvar@$HOST:$PORT
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export socks_proxy=$http_proxy
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$http_proxy
export FTP_PROXY=$http_proxy
export SOCKS_PROXY=$http_proxy
git config --global http.proxy $http_proxy

unset passvar
echo
$SHELL
git config --unset --global http.proxy
