#!/usr/bin/bash -x
if [ $# -eq 0 ]; then
    echo "No arguments supplied"
    exit 0
fi
USERNAME="$1"
USERPASS=$(openssl passwd -1 passwd)
HOMEDIR="/home/"$USERNAME"/"
DBUSER=$USERNAME"_user"
DBTABLE=$USERNAME"_prod"
DBPASSWD=$USERNAME"_passwd123\$\%\^"
sudo useradd -p $USERPASS $USERNAME
sudo chmod 701 $HOMEDIR
sudo mkdir $HOMEDIR"www"
sudo mkdir $HOMEDIR"www/default"
sudo chmod 755 -R $HOMEDIR"www"
sudo chown $USERNAME:$USERNAME -R $HOMEDIR
chcon -t httpd_sys_content_t $HOMEDIR"www" -R
QUERY="CREATE USER '$DBUSER'@'%' IDENTIFIED BY '$DBPASSWD';"
QUERY+="CREATE DATABASE IF NOT EXISTS $DBTABLE;GRANT ALL PRIVILEGES ON $DBTABLE.* TO '$DBUSER'@'%';"
echo $QUERY
mysql -uap -p -e "$QUERY"
if [ $# -lt 2 ]
then
    echo "Creating a vhost for $1 with a webroot in /home/$1/www/default/"
    sudo cp /etc/nginx/conf.d/template-common /etc/nginx/conf.d/$1.conf
else
    echo "Creating a vhost for $1 with a webroot in /home/$1/www/default"
    sudo cp /etc/nginx/conf.d/template-$2 /etc/nginx/conf.d/$1.conf
fi
sudo sed -i 's/template/'$1'/g' /etc/nginx/conf.d/$1.conf