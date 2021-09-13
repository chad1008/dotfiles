# Git
## Configuration Details
My git configuration includes a global `.gitignore` and `.gitconfig` files.

**Important**: Make sure to update your name and username before working on any of your projects!

```
git config --global user.name  "Your Name"
git config --global user.email "your@email.address"
```
## Aliases and Functions
If you're using my dotfiles (including my .zshrc), these will get automatically loaded, or you can load them manually by putting this in your shell-rc file:

```
source ~/.dotfiles/Git/aliases.sh
source ~/.dotfiles/Git/functions.sh
```

I strongly recommend looking over the aliases and removing any you don't need before proceeding... you don't want to have unexpected commands firing in an important project repo.

### gitcheat
`gitcheat` is a helper function to output a list of the custom git aliases, with some basic reformatting for improved readability. Running the command will output the full list. For a more compact view, pass the function a keyword and it will only output the relevant section:

```
gitcheat bisect

// # Bisect
//   gbs = git bisect
//  gbss = git bisect start
//  gbsg = git bisect good
//  gbsb = git bisect bad
//  gbsr = git bisect reset
```
You can add keywords and create new sections directly in `Git/aliases.sh`. Just be mindful of the formatted requirements described at the top of the file.

Run `gitcheat other` to see the current alias for this function.

### nuke_git_branches
If you ever find your local repo cluttered with uneeded or obsolete branches, `nuke_git_branches` is here to help. After a confirmation prompt, it will delete all branches except for the current repos main branch, regardless of how you've named said main branch. This utilizes `-d` flag and not the more destructive `-D`, so you won't lose any unmerged branches. Those you'll need to delete by hand.

Run `gitcheat branch` to see the current alias for this function.