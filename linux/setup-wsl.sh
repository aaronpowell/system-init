#! /bin/bash

echo 'Setting up wsl specific stuff'

tmpDir=~/tmp/setup-wsl
windowsUserName=$(powershell.exe '$env:UserName')

## setup WSL config
(
    echo '[automount]'
    echo 'enabled = true'
    echo 'root = /'
    echo 'options = "metadata"'
)> "$tmpDir/wsl.conf"
sudo mv "$tmpDir/wsl.conf" /etc/wsl.conf

## symlink go paths
ln -s ~/go "/c/User/$windowsUserName/go"

## Common aliases
echo "" >> $HOME/.zshrc
echo '# Aliases to useful Windows apps' >> $HOME/.zshrc
echo "alias p=\"powershell.exe\"" >> $HOME/.zshrc
echo "alias docker=\"docker.exe\"" >> $HOME/.zshrc
echo "alias docker-compose=\"docker-compose.exe\"" >> $HOME/.zshrc

# setup docker bridge
# gover=1.11.5
# windowsUserName=$(powershell.exe '$env:UserName')

# if [ ! -d "$tempDir" ]; then
#     mkdir --parents $tmpDir
# fi

# wget "https://storage.googleapis.com/golang/go$gover.linux-amd64.tar.gz" --output-document "$tmpDir/go.tar.gz"
# sudo tar -C /usr/local -xzf "$tmpDir/go.tar.gz"
# export PATH=$PATH:/usr/local/go/bin

# go get -d github.com/jstarks/npiperelay
# GOOS=windows go build -o "/mnt/c/Users/$windowsUserName/go/bin/npiperelay.exe" github.com/jstarks/npiperelay

# sudo ln -s "/mnt/c/Users/$windowsUserName/go/bin/npiperelay.exe" /usr/local/bin/npiperelay.exe

# sudo apt install socat

# echo '#!/bin/sh' >> ~/docker-relay
# echo 'exec socat UNIX-LISTEN:/var/run/docker.sock,fork,group=docker,umask=007 EXEC:"npiperelay.exe -ep -s //./pipe/docker_engine",nofork' >> ~/docker-relay
# chmod +x ~/docker-relay
# sudo adduser ${USER} docker
