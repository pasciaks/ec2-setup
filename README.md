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
sudo adduser <username>
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

```

## Install NGINX

