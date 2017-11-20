# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)

ZSH_THEME_GIT_PROMPT_PREFIX="(git:%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$reset_color%}):"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

GIT_STATUS_SYMBOLS_ONLY=""

if [ -n "$GIT_STATUS_SYMBOLS_ONLY" ]; then
    ZSH_THEME_GIT_PROMPT_ADDED="%F{green}✓%f "
    ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}✶%f "
    ZSH_THEME_GIT_PROMPT_DELETED="%F{red}✗%f "
    ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}↝%f "
    ZSH_THEME_GIT_PROMPT_UNMERGED="%F{yellow}%f "
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{cyan}✩%f "
    ZSH_THEME_GIT_PROMPT_AHEAD="%F{red}⇡%f "
    ZSH_THEME_GIT_PROMPT_BEHIND="%F{green}⇣%f "
    ZSH_THEME_GIT_PROMPT_STASHED="%F{green}↱%f "
    ZSH_THEME_GIT_PROMPT_DIVERGED="%F{green}⤱%f "
else
    ZSH_THEME_GIT_PROMPT_ADDED="%F{green}✓added%f "
    ZSH_THEME_GIT_PROMPT_MODIFIED="%F{blue}✶modified%f "
    ZSH_THEME_GIT_PROMPT_DELETED="%F{red}✗deleted%f "
    ZSH_THEME_GIT_PROMPT_RENAMED="%F{magenta}↝renamed%f "
    ZSH_THEME_GIT_PROMPT_UNMERGED="%F{yellow}unmerged%f "
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{cyan}✩untracked%f "
    ZSH_THEME_GIT_PROMPT_AHEAD="%F{red}⇡ahead%f "
    ZSH_THEME_GIT_PROMPT_BEHIND="%F{green}⇣behind%f "
    ZSH_THEME_GIT_PROMPT_STASHED="%F{green}↱stashed%f "
    ZSH_THEME_GIT_PROMPT_DIVERGED="%F{green}⤱diverged%f "
fi

function prompt_char {
	if [ $UID -eq 0 ]; then 
        echo "%{$fg[red]%}#%{$reset_color%}"; 
    else 
        echo "%{$FG[108]%}$%{$reset_color%}"; 
    fi
}

function username {
    if [ $UID -eq 0 ]; then 
        echo "%{$fg[red]%}%n%{$reset_color%}"; 
    else 
        echo "%{$FG[108]%}%n%{$reset_color%}"; 
    fi
}

# unused because the style variables above achieve the same
function git_prompt {
    local git_info=$(git_prompt_info)
    if [ ${#git_info} != 0 ]; then
        echo "(git:${git_info})"
    fi
}

function ssh_connection {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%} (ssh)%{$reset_color%}";
  fi
}

# print the error message for a return code
function error_description { 
    python -c "from __future__ import print_function; import os; import locale; locale.setlocale(locale.LC_ALL, '');\
    error_desc = os.strerror($1); print(error_desc, end='');"
}

function last_command_status {
    local return_value=$?
    if [ $return_value -ne 0 ]; then
        echo # add a newline
        echo -n "%{$fg[red]%}✘ FAILED with exit code $return_value"
        echo -n ": "; error_description "$return_value"; echo -n "%{$reset_color%}"
    fi
}

# turns seconds into human readable time
# 165392 => 1d 21h 56m 32s
function print_human_time {
    local tmp=$1
    local days=$(( tmp / 60 / 60 / 24 ))
    local hours=$(( tmp / 60 / 60 % 24 ))
    local minutes=$(( tmp / 60 % 60 ))
    local seconds=$(( tmp % 60 ))
    result=''
    (( $days > 0 )) && result=$result"${days}d "
    (( $hours > 0 )) && result=$result"${hours}h "
    (( $minutes > 0 )) && result=$result"${minutes}m "
    result=$result"${seconds}s"
    echo -n "$result"
}

COMMAND_TRACK_MIN_TIME=20

# Displays the exec time of the last command if set threshold was exceeded
function cmd_exec_time {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}
    let local elapsed=$stop-$start
    if [ $elapsed -gt $COMMAND_TRACK_MIN_TIME ]; then
        time_pretty=$(print_human_time $elapsed)
        echo # add a newline
#        echo -n "%{$fg[yellow]%}"
        echo -n "%{$FG[240]%}"
        echo -n "⌚ Command execution took ${time_pretty} %{$reset_color%}"
    fi
}

# Get the intial timestamp for cmd_exec_time (executed before starting a command, see "man zshall")
function preexec {
    cmd_timestamp=`date +%s`
}

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="(virtualenv:"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX=")"

function virtualenv_prompt_info {
    if [ -n "$VIRTUAL_ENV" ]; then
        if [ -f "$VIRTUAL_ENV/__name__" ]; then
            local name=`cat $VIRTUAL_ENV/__name__`
        elif [ `basename $VIRTUAL_ENV` = "__" ]; then
            local name=$(basename $(dirname $VIRTUAL_ENV))
        else
            local name=$(basename $VIRTUAL_ENV)
        fi
        echo "$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX%{$fg[green]%}$name%{$reset_color%}$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX"
    fi
}

# prevent percentage showing up if output doesn't end with a newline
export PROMPT_EOL_MARK=''

setopt prompt_subst

PROMPT='$(last_command_status)$(cmd_exec_time)
$(username)@%{$fg[white]%}%m$(ssh_connection)%{$reset_color%}: %{$fg[blue]%}%~/%{$reset_color%}\
 $(git_prompt_info) $(git_prompt_status)
$(virtualenv_prompt_info)> $(prompt_char) '

# show the time on the right prompt
# Note that the unicode ⌚⏰ symbols seem to confuse zsh about the length, 
RPROMPT='%{$fg[blue]%}⏲ %{$fg[magenta]%}%*%{$reset_color%}'
