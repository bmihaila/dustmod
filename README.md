# dustmod zsh theme

Started with fixes, improvements and modifications to the simple and clean [dst](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/dst.zsh-theme) theme. In the end it became yet another fully featured zsh theme. Still striving for cleanliness, though!

Features are:
- [Solarized](https://github.com/altercation/solarized)-inspired color theme with info and prompt split on 2 lines to allow for enough space for info and commands
- clock on the right
- the usual: username, host, current directory in prompt
- different color and prompt for `root` user
- show if on `ssh` connection
- `git` status if inside a repo: shows the branch-name and repository status in a verbose description or using only symbols (✓✶✗↝✩⇡⇣↱⤱)
- python virtual environment name in prompt
- show return code of last command if it was not `0`. additionally translates the return code to a human readable error message
- duration of last command for long running commands, i.e. > 20 seconds

## Screenshots
![Showing all features](https://raw.githubusercontent.com/bmihaila/dustmod/master/screenshots/Screenshot_all_2.png)

Showing Konsole on Linux with [Inconsolata Font](https://fonts.google.com/specimen/Inconsolata) at 13 point.

## Requirements
- Zsh - see [zsh.org](http://www.zsh.org/)
- a Zsh framework like [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh), [antigen](https://github.com/zsh-users/antigen), [zplug](https://github.com/zplug/zplug) or [zgen](https://github.com/tarjoilija/zgen)
- needs [Python](https://www.python.org/) installed to translate the return error codes

## Installation
Add the following line to your `.zshrc` file depending on your zsh plugin manager:

- [oh-my-zsh - adding themes howto](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-and-adding-themes)

    `ZSH_THEME="dustmod"`

- [antigen](https://github.com/zsh-users/antigen):

    `antigen theme bmihaila/dustmod dustmod`

- [zgen](https://github.com/tarjoilija/zgen):

    `zgen load bmihaila/dustmod`

- [zplug](https://github.com/zplug/zplug):

    `zplug "bmihaila/dustmod"`
