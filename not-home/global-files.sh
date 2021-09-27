#!/usr/bin/env bash

# This script will install all files that are not in $HOME

sudo cp npmrc /usr/etc/npmrc
sudo cp 45-sda-power.rules /etc/udev/rules.d/45-sda-power.rules
