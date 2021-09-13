# Personal Dotfiles

These are my personal dotfiles. Feel free to fork or take whatever bits and pieces you like - not all of it is my own, and there's plenty of inspiration taken by others.

## Getting Started

My dotfiles use [Dotbot](https://github.com/anishathalye/dotbot), because it's awesome. Makes installing Dotfiles and keeping new additions tothe structure up to date between machines a breeze.

To begin, fork and clone this repo, and then run `./install` from the new project root, and you should be good to go. Dotbot will handle the necessay symlink generation for you.

Warning, the install *will* replace some files if they already exist, so proceed with caution. You can check out the `link` section of `install.conf.json` if you'd like, the items entries with `"force" : true` will overwrite existing counterparts. 

## History and attribution

I first stumbled across dotfiles when looking at ways to [synchronize iTerm2 settings between devices](https://shyr.io/blog/sync-iterm2-configs). I instantly loved the idea, and I've taken a lot of inpiration in terms of organization and structure and implementation from the author of that article, who also has [opensourced their own dotfiles](https://github.com/sheharyarn/dotfiles). I've [directly adopted](https://github.com/chad1008/dotfiles/blob/5c12a2ab5f5444180451b935fc594496486117c2/Zsh/zshrc#L36) their use of dynamically loaded function and alias files in each directory, so full credit for that part of this setup goes to them!