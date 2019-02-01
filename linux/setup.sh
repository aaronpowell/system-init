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
    software-properties-common
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

## VSCode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install code-insiders -y

## zsh
sudo apt-get install zsh -y
curl -L http://install.ohmyz.sh | sh

## firacode
sudo add-apt-repository universe
sudo apt install fonts-firacode -y

## tmux
sudo apt install tmux -y

## linux-surface
while true; do
    read -p "Setup surface-linux [Yn]?" yn
    yn=${yn-Y}
    case $yn in
        [Yy]* )
            sudo apt install git curl wget sed
            git clone --depth 1 https://github.com/jakeday/linux-surface.git ~/linux-surface
            sudo sh ~/linux-surface/setup.sh
            break;;
        [Nn]* ) break;;
    esac
done