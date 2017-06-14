# ec2-setup
Setup Instructions for a new EC2 Instance

Update apt-get.
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
