# Dotfiles
My config files

# For my future self
This will clone my Dotfiles
``` bash
git clone https://github.com/santigo-zero/Dotfiles.git
```
Using rsync everything will be moved to their respective directories
``` bash
rsync --recursive --verbose --exclude '.git' --exclude 'backup.sh' --exclude 'README.md' --exclude 'not-home.sh' Dotfiles/ $HOME
```
And now delete it so it doesn't clutter home more than what already is
``` bash
rm -r Dotfiles
```
