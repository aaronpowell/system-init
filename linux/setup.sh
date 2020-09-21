#! /bin/bash

log() {
    echo $1 >> ~/env-setup.log
}

install_docker() {
    echo -e '\e[0;33mSetting up docker\e[0m'

    sudo apt-get update
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common \
        -y

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository --yes \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable nightly test"

    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo /etc/init.d/docker start
}

install_git() {
    echo -e '\e[0;33mInstalling git\e[0m'

    sudo add-apt-repository ppa:git-core/ppa --yes
    sudo apt update
    sudo apt install git -y
}

install_devtools() {
    echo -e '\e[0;33mInstalling dev software/runtimes/sdks\e[0m'

    ## dotnet
    wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo add-apt-repository universe --yes
    sudo apt-get update
    sudo apt-get install dotnet-sdk-2.2 dotnet-sdk-3.1 -y
    
    read -p "Install .NET Preview SDK? (Y/n)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo docker pull mcr.microsoft.com/dotnet/core/5.0.100-preview
    fi

    ## go
    read -p "Install Golang? (Y/n)" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        gover=1.14.1
        wget "https://storage.googleapis.com/golang/go$gover.linux-amd64.tar.gz" --output-document "$tmpDir/go.tar.gz"
        sudo tar -C /usr/local -xzf "$tmpDir/go.tar.gz"
    fi

    ## Node.js via fnm
    curl https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash
}

echo -e '\e[0;33mPreparing to setup a linux machine from a base install\e[0m'

tmpDir=~/tmp/setup-base

if [ ! -d "$tmpDir" ]; then
    mkdir --parents $tmpDir
fi

## General updates
sudo apt-get update
sudo apt-get upgrade -y

## Utilities
sudo apt-get install unzip curl jq -y

# Create standard github clone location
mkdir -p ~/code/github

install_git
source "./setup-shell.sh"
install_devtools
install_docker

rm -rf $tmpDir
