# Dotfiles
My config files

# For my future self
This will clone my Dotfiles
``` bash
git clone https://github.com/santigo-zero/Dotfiles.git
```
Using rsync everything will be moved to their respective directories
``` bash
rsync --recursive --verbose --exclude '.git' --exclude 'README.md' Dotfiles/ $HOME
```
And now delete it so it doesn't clutter home more than what already is
``` bash
rm -r Dotfiles
```
