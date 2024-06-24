# git info
source $DOTFILES_LOCATION/bash/prompts/git_prompt.sh

COLOUR1="$(tput setaf 34)"
COLOUR2="$(tput setaf 220)"
COLOUR3="$(tput setaf 214)"
COLOUR4="$(tput setaf 33)"
COLOUR5="$(tput sgr0)"

function _git_prompt {
    IsGitRepo
    if [[ 0 != $? ]]; then
        echo ""
        return 0
    fi

    local branch=$(GitBranchOrCurrentCommit)
    local stashCount=$(GitRepoStashCount)
    local commitsNotInMain=$(GitRepoCommitsNotInMain)
    local changes=$(GitRepoCountChanges)

    local stashOutput="$COLOUR2$stashCount"
    local commitsNotInMainOutput="$COLOUR3$commitsNotInMain"
    local changesOutput="$COLOUR2$changes"
    local separator="$COLOUR5|"
    local start="$COLOUR5["
    local end="$COLOUR5]"
    local branchOutput="$COLOUR4$branch"

    echo "\n$branchOutput $start$commitsNotInMainOutput $separator $changesOutput $separator $stashOutput$end"
    return 0
}

function _prompt_command {
    local exitCode=$?
    # Default green
    local exitCodeColour=46
    if [[ 0 != $exitCode ]]; then
        # Red. Last command failed.
        exitCodeColour=196
    fi
    local prompt="$COLOUR1\$"
    local reset="$COLOUR5"
    local exitInfo="$(tput setaf $exitCodeColour)($exitCode)"
    local end="$(_git_prompt)\n$prompt$reset "
    local jobInfo="$COLOUR2\j"
    PS1="$COLOUR1\u$COLOUR2@$COLOUR3\h:$COLOUR4\w $exitInfo $reset[$jobInfo$reset]$end"
}

export PROMPT_COMMAND=_prompt_command
