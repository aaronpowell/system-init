#! /bin/bash

echo 'Preparing to setup a linux machine from a base install'

## General updates
sudo apt-get update
sudo apt-get upgrade -y

## Docker
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable nightly test"

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

## Git
sudo add-apt-repository ppa:git-core/ppa
sudo apt update
sudo apt install git -y
cp ../common/.gitconfig ~/.gitconfig

## zsh
sudo apt-get install zsh -y
curl -L http://install.ohmyz.sh | sh
chsh -s /bin/zsh ${USER}

## firacode
sudo add-apt-repository universe
sudo apt install fonts-firacode -y

## tmux
sudo apt install tmux -y

if uname -r | grep -E 'Microsoft$' -q; then
    sh ./setup-wsl.sh
else
    sh ./setup-metal.sh
fi