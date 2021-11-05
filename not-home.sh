#!/usr/bin/env bash

sudo mkdir /usr/etc/
sudo touch /usr/etc/npmrc
sudo tee -a /usr/etc/npmrc <<EOT
cache=${XDG_CACHE_HOME}/npm
tmp=${XDG_RUNTIME_DIR}/npm
init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
EOT

sudo tee -a /etc/udev/rules.d/45-sda-power.rules <<EOT
ACTION=="add", SUBSYSTEM=="block", KERNEL=="sda", ATTR{queue/rotational}=="1", RUN+="/usr/bin/hdparm -S 1 /dev/sda"
EOT

sudo tee -a /etc/profile << EOT

# Change the directory of things
xdg-user-dirs-update --set DESKTOP $HOME/.local/Desktop
xdg-user-dirs-update --set DOWNLOAD $HOME/.local/Downloads
xdg-user-dirs-update --set TEMPLATES $HOME/.local/Templates
xdg-user-dirs-update --set PUBLICSHARE $HOME/.local/"Public Share"
xdg-user-dirs-update --set DOCUMENTS $HOME/.local/Documents
xdg-user-dirs-update --set MUSIC $HOME/.local/Music
xdg-user-dirs-update --set PICTURES $HOME/.local/Pictures
xdg-user-dirs-update --set VIDEOS $HOME/.local/Videos
EOT
