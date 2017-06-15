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
$DOMAIN="$(echo $DOMAIN | tr '[A-Z]' '[a-z]')"

echo $DOMAIN

# # Update apt-get
# echo "===== Updating apt-get ====="
# apt-get update

# # Install NodeJS and Node Package Manager
# apt-get install nodejs
# apt-get install npm

# # Create symbolic link for node
# ln -s /usr/bin/nodejs /usr/bin/node

# # Remove non-alpha characters
# $USERNAME=$(echo $DOMAIN | sed 's/[^a-z]//g')

# # Add user
# adduser $USERNAME --gecos "" --disabled-password

# cd /home/$USERNAME
# mkdir .ssh
# touch .ssh/authorized_keys
# chown -R $USERNAME:$USERNAME .ssh
# chmod 0700 .ssh
# chmod 0600 .ssh/authorized_keys

# wget https://risingempiretech.github.io/ec2-setup/publickey.pem
# cat publickey.pem >> .ssh/authorized_keys
# rm publickey.pem

# service ssh restart

# wget https://dl.eff.org/certbot-auto
# chmod a+x ./certbot-auto

# ./certbot-auto certonly --standalone --agree-tos --email blake@risingempire.tech -d $DOMAIN

# mkdir public

# apt-get install nginx

# wget https://risingempiretech.github.io/ec2-setup/nginx.config
# sed -i "s/DOMAIN/${DOMAIN}/g" nginx.config
# sed -i "s/USERNAME/${USERNAME}/g" nginx.config
# mv ./nginx.config /etc/nginx/sites-enabled/default

# service nginx restart

# crontab -l > oldcron

# echo "24 02 * * * /home/$USERNAME/certbot-auto renew" >> oldcron

# crontab oldcron
# rm oldcron
