# ec2-setup
Setup Instructions for a new EC2 Instance

## Install NodeJS

Update apt-get
```bash
sudo apt-get update
```

Install Nodejs and Node Package Manager
```bash
sudo apt-get install nodejs
sudo apt-get install npm
```

Create symbolic link for node instead of nodejs
```bash
sudo ln -s /usr/bin/nodejs /usr/bin/node
```

## Create New User

username = Domain replace all non alpha characters and lowercase

```bash
sudo adduser <username> --gecos "" --disabled-password
```

## SSH Key

Create authorized keys file and make the new user the owner
```bash
sudo cd /home/username
sudo mkdir .ssh
sudo touch .ssh/authorized_keys
sudo chown -R username:username .ssh
sudo chmod 0700 .ssh
sudo chmod 0600 .ssh/authorized_keys
```

Download RETI Employee ssh public key and append to authorized_keys
```bash
wget https://risingempiretech.github.io/ec2-setup/publickey.pem
cat publickey.pem >> .ssh/authorized_keys
rm publickey.pem
```

Restart SSH
```bash
sudo service ssh restart
```

## Install SSL Cert

Install Cert Bot
```bash
wget https://dl.eff.org/certbot-auto
chmod a+x ./certbot-auto
```

Request & Install Cert
```bash
./certbot-auto certonly --standalone --agree-tos --email <admin_email> -d <domain_name>
```

## Create Public Directory

Serve files from a 'public' directory in the users home directory
```bash
mkdir public
```

## Install & Configure NGINX

Install NGINX
```bash
sudo apt-get install nginx
```

Download and save NGINX site config
```bash
wget https://risingempiretech.github.io/ec2-setup/nginx.config
mv ./nginx.config /etc/nginx/sites-enabled/default
```
(need to do replacement)

Restart nginx
```bash
sudo service nginx restart
```
