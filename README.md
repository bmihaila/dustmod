# Dustmod zsh theme

Started with fixes, improvements and modifications to the simple and clean [dst](https://raw.githubusercontent.com/larryhynes/oh-my-zsh-themes/master/images/dst.png) [(code)](https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/dst.zsh-theme) theme. In the end it became yet another fully featured zsh theme. Still striving for cleanliness, though!  
Picked inspirations and features from various themes: [avit](https://github.com/larryhynes/oh-my-zsh-themes/blob/master/images/avit.png?raw=true), [bureau](https://raw.githubusercontent.com/larryhynes/oh-my-zsh-themes/master/images/bureau.png), [clean](https://raw.githubusercontent.com/larryhynes/oh-my-zsh-themes/master/images/clean.png), [dst](https://raw.githubusercontent.com/larryhynes/oh-my-zsh-themes/master/images/dst.png), [jreese](https://raw.githubusercontent.com/larryhynes/oh-my-zsh-themes/master/images/jreese.png), [mortalscumbag](https://raw.githubusercontent.com/larryhynes/oh-my-zsh-themes/master/images/mortalscumbag.png), [michelebologna](https://github.com/larryhynes/oh-my-zsh-themes/blob/master/images/michelebologna.png?raw=true), [sunaku](https://github.com/larryhynes/oh-my-zsh-themes/blob/master/images/sunaku.png?raw=true), [sunrise](https://github.com/larryhynes/oh-my-zsh-themes/blob/master/images/sunrise.png?raw=true), [tjkirch](https://github.com/larryhynes/oh-my-zsh-themes/blob/master/images/tjkirch.png?raw=true), [spaceship](https://github.com/denysdovhan/spaceship-zsh-theme/blob/master/preview.gif), [pure](https://github.com/sindresorhus/pure/raw/master/screenshot.png)

Features are:
- [Solarized](https://github.com/altercation/solarized) color-scheme inspired theme with info and command prompt split on 2 lines to allow for enough space for both
- clock/time on the right
- the usual: username, host, current directory in prompt
- different color and prompt for `root` user
- show a little `✗` in front of the current path if it is not writable by the user
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
- git lib for zsh - provided by above frameworks
- needs [Python](https://www.python.org/) installed to translate the return error codes


## Installation
Download the theme file to the right directory for you framework and add the following line to your `.zshrc` file depending on your zsh plugin manager:

- [oh-my-zsh - adding themes howto](https://github.com/robbyrussell/oh-my-zsh/wiki/Customization#overriding-and-adding-themes)

    `ZSH_THEME="dustmod"`

- [antigen](https://github.com/zsh-users/antigen):

    `antigen theme bmihaila/dustmod dustmod`

- [zgen](https://github.com/tarjoilija/zgen):

    `zgen load bmihaila/dustmod`

- [zplug](https://github.com/zplug/zplug):

    `zplug "bmihaila/dustmod"`

## Tweaks and settings

The appearance can be modified by setting environment variables in your `.zhrc`:

- `DUSTMOD_COMMAND_TRACK_MIN_TIME_SECS=20` - after how many seconds consider a "long running command" and display its runtime after it finished
- `DUSTMOD_GIT_STATUS_LONG_DESCRIPTION="true"` - show the git status verbose, e.g. `✶modified` or only using the symbols `✶`
- `DUSTMOD_USER_HOST_ALWAYS="true"` - show the `username@hostname` part always or hide it when on the local machine


For further changes, modify the code!
