#!/bin/bash

# Get parameters from command line
while getopts d:e: option
  do
    case "${option}"
      in
      d) DOMAIN=${OPTARG};;    
  esac
done

if [ "$(whoami)" != "root" ]; then
	echo "This script has to be run with sudo."
	exit 1
fi

if [ -z $DOMAIN ]; then
	echo "No domain name was given."
	exit 1
fi

# Convert domain name to lowercase
DOMAIN="$(echo $DOMAIN | tr '[A-Z]' '[a-z]')"

# Remove non-alpha characters
USERNAME=$(echo $DOMAIN | sed 's/[^a-z]//g')

# Add user
echo "===== Add New User ====="
adduser $USERNAME --gecos "" --disabled-password

echo "===== Create SSH Directory ====="
cd /home/$USERNAME
mkdir .ssh
touch .ssh/authorized_keys
chown -R $USERNAME:$USERNAME .ssh
chmod 0700 .ssh
chmod 0600 .ssh/authorized_keys

echo "===== Get Public Key ====="
wget https://risingempiretech.github.io/ec2-setup/publickey.pem
cat publickey.pem >> .ssh/authorized_keys
rm publickey.pem

service ssh restart

echo "===== Download Certbot ====="
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto

service nginx stop

./certbot-auto certonly --non-interactive --standalone --agree-tos --email blake@risingempire.tech -d $DOMAIN

service nginx start

mkdir public
chown -R $USERNAME:$USERNAME public

echo "===== Download NGINX Config ====="
wget https://risingempiretech.github.io/ec2-setup/nginx-site.config
sed -i "s/DOMAIN/${DOMAIN}/g" nginx-site.config
sed -i "s/USERNAME/${USERNAME}/g" nginx-site.config
cat ./nginx-site.config >> /etc/nginx/sites-enabled/default
rm ./nginx-site.config

service nginx restart
