#! /bin/bash

echo 'Starting setup for Linux on base metal'

## VSCode
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install code-insiders -y

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