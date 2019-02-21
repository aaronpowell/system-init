#! /bin/bash

echo 'Preparing to setup a linux machine from a base install'

gover=1.11.5
tmpDir=~/tmp/setup-base

if [ ! -d "$tempDir" ]; then
    mkdir --parents $tmpDir
fi

if uname -r | grep -E 'Microsoft$' -q; then
    wsl=true
else
    wsl=false
fi

## General updates
sudo apt-get update
sudo apt-get upgrade -y

## Utilities
sudo apt-get install unzip

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

## dotnet
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install dotnet-sdk-2.2

## go
wget "https://storage.googleapis.com/golang/go$gover.linux-amd64.tar.gz" --output-document "$tmpDir/go.tar.gz"
sudo tar -C /usr/local -xzf "$tmpDir/go.tar.gz"

## Node.js via fnm
curl https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash

## install-specific stuff
if $wsl; then
    sh ./setup-wsl.sh
else
    sh ./setup-metal.sh
fi

rm -rf $tempDir