# dustmod zsh theme

Started with fixes, improvements and modifications to the nice and clean [**dst** theme](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/dst.zsh-theme). In the end it became yet another fully featured zsh theme.

Features are:
- the usual username, host, current directory in prompt
- different color and prompt for `root` user
- neutral color theme with info and prompt split on 2 lines to allow for enough space for info and commands
- git status. branch-name, repository status in a verbose description or using only symbols (*TODO*: list possible states and symbols)
- clock on the right
- show return code of last command if it was not 0. translates the return code to a human readable error message
- duration of last command for long running commands, i.e. > 20 seconds

## Screenshots
*TODO*: add screenshots

## Requirements
Needs **Python** installed to translate the return error codes

## Installation
Add the following line to your .zshrc depending on your zsh plugin manager

- [oh-my-zsh: adding themes](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-and-adding-themes)

    ZSH_THEME="dustmod"

- [antigen](https://github.com/zsh-users/antigen):

    antigen theme bmihaila/dustmod dustmod

- [zgen](https://github.com/tarjoilija/zgen):

    zgen load bmihaila/dustmod

- [zplug](https://github.com/zplug/zplug):

    zplug "bmihaila/dustmod"
