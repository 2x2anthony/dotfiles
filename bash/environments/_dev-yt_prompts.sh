COLOUR1="$(tput setaf 34)"
COLOUR2="$(tput setaf 220)"
COLOUR3="$(tput setaf 214)"
COLOUR4="$(tput setaf 33)"
COLOUR5="$(tput sgr0)"

function _yt_prompt_command {
    local exitCode=$?;
    # Default green
    local exitCodeColour=46;
    if [[ 0 != $exitCode ]]; then
        # Red. Last command failed.
        exitCodeColour=196;
    fi
    local prompt="$COLOUR1\$";
    local reset="$COLOUR5";
    local exitInfo="$(tput setaf $exitCodeColour)($exitCode)";
    local end="$(_git_prompt)\n$prompt$reset ";
    local jobInfo="$COLOUR2\j";
    PS1="$COLOUR1$(echo "tony")$COLOUR2@$COLOUR3\h:$COLOUR4\h $exitInfo $reset[$jobInfo$reset]$end";
}

export PROMPT_COMMAND=_yt_prompt_command;
