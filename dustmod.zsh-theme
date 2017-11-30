# OPTIONS
GIT_STATUS_SYMBOLS_ONLY=""
COMMAND_TRACK_MIN_TIME=20


ZSH_THEME_GIT_PROMPT_PREFIX="(git:%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

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

function prompt_prefix {
    if [ $UID -eq 0 ]; then 
        echo "%{$fg[red]%}#❯ %{$reset_color%}";
    else 
        echo "%{$FG[108]%}$❯ %{$reset_color%}";
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

function writable_current_dir {
    if [[ ! -w "${PWD}" ]]; then
        echo "%{$fg_bold[red]%}✗%{$reset_color%}";
    fi
}

function trailing_dir_slash {
    if [[ ! "${PWD}" == "/" ]]; then
        echo "/";
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


# Get the intial timestamp for cmd_exec_time (executed before starting a command, see "man zshall")
function preexec {
    cmd_timestamp=`date +%s`
}

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

# disables prompt mangling in virtual_env/bin/activate
export VIRTUAL_ENV_DISABLE_PROMPT=1
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="(venv:"
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

# taken from the "Bureau" oh-my-zsh theme
function columns_filler_space {
    # need to perform the expansion for the string
    # to call the functions there and expand the escape sequences
    local STRING=$1
    STRING=${(e)STRING}  # expand parameters, function calls and arithmetic expressions
#    STRING=$(print -Pr $STRING)  # this also expands the escape codes for colors which breaks below length calculation
    # see https://stackoverflow.com/questions/10564314/count-length-of-user-visible-string-for-zsh-prompt
    # for an explanation of below length computation
    local zero='%([BSUbfksu]|([FK]|){*})'
    local STRING_LENGTH=${#${(S%%)STRING//$~zero/}}
#    cleaned_string=$(echo -n $STRING | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g")
#    STRING_LENGTH=$#cleaned_string
    local SPACES=""
    ((LENGTH = ${COLUMNS} - $STRING_LENGTH - 1))

    # TODO: handle negative lengths, i.e. if the strings are too long for the columns
    for i in {0..$LENGTH}; do
      SPACES="$SPACES "
    done

    echo $SPACES
}

# prevent percentage showing up if output doesn't end with a newline
export PROMPT_EOL_MARK=''
# expand the variables, escape code and functions in the prompt
setopt prompt_subst

## putting it all togeher

# needs single quotes to be evaluated in the prompt each time with latest state values
HEADLINE_LEFT='$(username)@%{$fg[white]%}%m$(ssh_connection)%{$reset_color%} \
$(writable_current_dir) %{$fg[blue]%}%~$(trailing_dir_slash)%{$reset_color%} $(git_prompt_info) $(git_prompt_status)'

# Note that the following unicode ⌚⏰ symbols seem to confuse zsh about the length, 
CLOCK='%{$fg[blue]%}%{$fg[blue]%}%* ⏲ %{$reset_color%}'

COMMANDLINE='$(virtualenv_prompt_info)$(prompt_prefix)'

SPACER='$(columns_filler_space $HEADLINE_LEFT$CLOCK)'

PROMPT="$HEADLINE_LEFT$SPACER$CLOCK
$COMMANDLINE"

# nothing for now in the right prompt.
# showing e.g. the CLOCK there puts it on the line of the commands
#RPROMPT='$CLOCK'
