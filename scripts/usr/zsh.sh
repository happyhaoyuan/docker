# export HOME=/home/$DOCKER_USER

wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

cp -f /settings/.zshrc /home/$(id -un)/.zshrc

# lf
mkdir -p ~/.linuxbrew/bin
ln -s /workdir/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
eval $(~/.linuxbrew/bin/brew shellenv)
sed -i "1iexport PATH=\$PATH:~/.linuxbrew/bin" /home/$(id -un)/.zshrc
brew install lf

sed -i "s~USER_NAME~$(id -un)~" ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i "1isource ~/.env_var" ~/.zshrc
sed -i "1iif test -t 1; then\nexec zsh\nfi" ~/.bashrc
source ~/.bashrc

#chmod 755 $HOME/.zshrc
#sed -i "s~ZSH_THEME=\"robbyrussell\"~ZSH_THEME=\"agnoster\"~g" ~/.zshrc
#sed -i "1iZSH_DISABLE_COMPFIX=\"true\"" ~/.zshrc
#sed -i "1iunsetopt share_history" ~/.zshrc
#sed -i "1iunsetopt inc_append_history" ~/.zshrc
#sed -i "s~plugins=(git)~plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker sudo vi-mode extract web-search git-extras)~g" ~/.zshrc
