#!/bin/bash
log() {
    echo $1 >> ~/env-setup.log
}

install_shell() {
    echo -e '\e[0;33mSetting up zsh as the shell\e[0m'

    ## zsh
    sudo apt-get install zsh -y

    curl -L http://install.ohmyz.sh | sh
    {
        CMD="$( sudo chsh -s /usr/bin/zsh ${USER} )"
    } || {
        log "Failed to set zsh as default shell: $CMD"
    }
    # ZSH_CUSTOM=~/.oh-my-zsh/custom
    # git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
    # ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

    ## tmux
    # {
    #     CMD="$( sudo apt install tmux urlview -y )"
    # } || {
    #     log "Failed to install tmux & urlview: $CMD"
    # }
    # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    ## install GitHub CLI
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

    # install copilot extension
    # gh extension install github/gh-copilot
}

install_dotfiles() {
    echo -e '\e[0;33mSetting up standard dotfiles\e[0m'

    git clone https://github.com/aaronpowell/dotfiles ~/code/github/dotfiles

    LINUX_SCRIPTS_DIR="$( readlink -f ~/code/github/dotfiles )"

    ln -s $LINUX_SCRIPTS_DIR/.zshrc ~/.zshrc
    # ln -s $LINUX_SCRIPTS_DIR/.tmux.conf ~/.tmux/.tmux.conf
    ln -s $LINUX_SCRIPTS_DIR/.vimrc ~/.vimrc
    ln -s $LINUX_SCRIPTS_DIR/.urlview ~/.urlview
    ln -s $LINUX_SCRIPTS_DIR/.gitconfig ~/.gitconfig
    git config --global core.autocrlf false
    ln -s $LINUX_SCRIPTS_DIR/gh-config.yml ~/.config/gh/config.yml

    ## Only setup cred manager if it's wsl
    if [[ "$WSLENV" ]]
    then
        git config --global credential.helper '/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe'
    fi

    # tmux source ~/.tmux/.tmux.conf
}

install_shell
install_dotfiles

