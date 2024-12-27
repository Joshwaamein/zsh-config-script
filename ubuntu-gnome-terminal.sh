#!/bin/bash

echo "This script will configure your zsh. Do not run this script as sudo. This script should only be run on a fresh install of Ubuntu. You can cancel the script within the next 5 seconds"
sleep 5

echo "Current user is $USER"

if [ "$EUID" -eq 0 ]; then
  echo "Please do not run as root"
  exit 1
fi

# Get the default profile ID
PROFILE_ID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")

# Set the colors
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ background-color '#000000'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ foreground-color '#29B443'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ bold-color '#24FF00'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/ bold-color-same-as-fg false

echo "GNOME Terminal colors have been updated."


if [ -f "$HOME/.zshrc" ]; then
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
    echo "Existing .zshrc backed up to .zshrc.backup"
fi


echo "Patching OS"
sudo apt-get update
sudo apt-get upgrade -y

echo "Install prerequisite packages (ZSH, git, powerline & powerline fonts)"
sudo apt-get install zsh git powerline fonts-powerline -y

echo "Installing fortune, cowsay, lolcat"
sudo apt-get install fortune cowsay lolcat -y

echo "Clone the Oh My Zsh Repo to current working directory"
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

echo "Create a New ZSH configuration file"
cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo "Change your Default Shell"
sudo chsh -s $(which zsh) $USER

echo "Setting Preferred Theme"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="duellj"/g' "$HOME/.zshrc"

echo "Configure Syntax Highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh-syntax-highlighting" --depth 1
echo "source $HOME/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"

echo "Adding cow :)"
echo "fortune | cowsay | lolcat" >> "$HOME/.zshrc"

echo "Shell changed to zsh. Please log out and log back in for the changes to take effect. Alternatively run 'exec zsh'"
echo "Please open a new terminal window to see the changes."
sleep 5