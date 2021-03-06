# User tweakable options for the theme look

# show the runtime of the last command if it took longer to execute than this
DUSTMOD_COMMAND_TRACK_MIN_TIME_SECS=${DUSTMOD_COMMAND_TRACK_MIN_TIME_SECS:=20}
# show a long description of the git status, e.g. 'modified' or only symbols
DUSTMOD_GIT_STATUS_LONG_DESCRIPTION=${DUSTMOD_GIT_STATUS_LONG_DESCRIPTION:="true"}
# show the 'username@hostname' always or only when on remote machines
DUSTMOD_USER_HOST_ALWAYS="${DUSTMOD_USER_HOST_ALWAYS:=true}"

# requires git.zsh lib
ZSH_THEME_GIT_PROMPT_PREFIX="(git:%F{green}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
# showing dirty/clean is redundant, given the individual symbols below. So avoid that noise
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

if [[ "$DUSTMOD_GIT_STATUS_LONG_DESCRIPTION" == "true" ]]; then
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
else
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
fi

# make sure we have those functions when they are called below
# below is removed because the if-test takes care of it and whitespace would be printed anyways
#functions git_prompt_info &> /dev/null || git_prompt_info(){}
#functions git_prompt_status &> /dev/null || git_prompt_status(){}

function git_info {
    if {echo $fpath | grep -q "plugins/git"}; then
        echo " $(git_prompt_info) $(git_prompt_status)"
    fi
}

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

function ssh_connection {
    if [[ -n $SSH_CONNECTION ]]; then
        echo "%{$fg_bold[red]%} (ssh)%{$reset_color%}";
    fi
}

function user_and_host {
    if [[ "$DUSTMOD_USER_HOST_ALWAYS" == "true" || -n $SSH_CONNECTION ]]; then
        echo "$(username)@%{$fg[white]%}%m$(ssh_connection)%{$reset_color%} "
    fi
}

function is_current_dir_writable {
    if [[ ! -w "${PWD}" ]]; then
        echo "%{$fg_bold[red]%}✗%{$reset_color%}";
    fi
}

function current_dir {
    # do not show a trailing slash in the root dir
    if [[ "${PWD}" == "/" ]]; then
        echo "%{$fg[blue]%}%~%{$reset_color%}"
    else
        echo "%{$fg[blue]%}%~/%{$reset_color%}"
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
    if [ $elapsed -gt $DUSTMOD_COMMAND_TRACK_MIN_TIME_SECS ]; then
        time_pretty=$(print_human_time $elapsed)
        echo # add a newline
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

# idea from the "Bureau" oh-my-zsh theme
function columns_filler_space {
    # need to perform the expansion for the string
    # to call the functions there and expand the escape sequences
    local STRING=$1
    STRING=${(e)STRING}  # expand parameters, function calls and arithmetic expressions
#    STRING=$(print -Pr $STRING)  # this also expands the escape codes for colors which breaks below length calculation
    # see https://stackoverflow.com/questions/10564314/count-length-of-user-visible-string-for-zsh-prompt
    # and https://stackoverflow.com/questions/40827667/zsh-length-of-a-string-with-possibly-unicode-and-escape-characters
    # for an explanation of below length computation
    local zero='%([BSUbfksu]|([FK]|){*})'
    local STRING_LENGTH=${#${(S%%)STRING//$~zero/}}
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

PREV_COMMAND_INFO='$(last_command_status)$(cmd_exec_time)'
# needs single quotes to be evaluated in the prompt each time with latest state values
HEADLINE_LEFT='$(user_and_host)$(is_current_dir_writable)$(current_dir)$(git_info)'

# Note that the following unicode ⌚⏰ symbols seem to confuse zsh about the length, 
CLOCK='%{$fg[blue]%}%{$fg[blue]%}%* ⏲ %{$reset_color%}'

COMMANDLINE='$(virtualenv_prompt_info)$(prompt_prefix)'

SPACER='$(columns_filler_space $HEADLINE_LEFT$CLOCK)'

PROMPT="$PREV_COMMAND_INFO
$HEADLINE_LEFT$SPACER$CLOCK
$COMMANDLINE"

# nothing for now in the right prompt.
# showing e.g. the CLOCK there puts it on the line of the commands
#RPROMPT='$CLOCK'
RPROMPT=''
