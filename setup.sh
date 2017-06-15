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

echo $DOMAIN

# Update apt-get
echo "===== Updating apt-get ====="
apt-get update

# Install NodeJS and Node Package Manager
echo "===== Installing Node ====="
apt-get -y install nodejs
echo "===== Installing NPM ====="
apt-get -y install npm

# Create symbolic link for node
echo "===== Create Symbolic Link ====="
ln -s /usr/bin/nodejs /usr/bin/node

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

./certbot-auto certonly --non-interactive --standalone --agree-tos --email blake@risingempire.tech -d $DOMAIN

mkdir public

echo "===== Install NGINX ====="
apt-get -y install nginx

echo "===== Download NGINX Config ====="
wget https://risingempiretech.github.io/ec2-setup/nginx.config
sed -i "s/DOMAIN/${DOMAIN}/g" nginx.config
sed -i "s/USERNAME/${USERNAME}/g" nginx.config
mv ./nginx.config /etc/nginx/sites-enabled/default

service nginx restart

echo "===== Switch User ====="
su $USERNAME

echo "===== Create Cron Job ====="
(crontab -l 2>/dev/null; echo "24 02 * * * /home/$USERNAME/certbot-auto renew --pre-hook 'service nginx stop' --post-hook 'service nginx start'") | crontab -
