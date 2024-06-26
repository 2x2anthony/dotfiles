function IsGitRepo {
    git rev-parse --is-inside-work-tree > /dev/null 2>&1
    return $?
}

function IsEmptyRepo {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    git rev-parse HEAD > /dev/null 2>&1
    if [[ 0 == $? ]]; then
        return 1
    fi
    return 0
}

function IsHeadBranch {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    local branch=$(git branch --show-current)
    if [[ "" == "$branch" ]]; then
        return 1
    fi

    return 0
}

function GitGetMainBranchName {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    IsEmptyRepo
    if [[ 0 == $? ]]; then
        return 1
    fi

    local name=$(git rev-parse --abbrev-ref HEAD | sed 's@^origin/@@')
    echo $name
    return 0
}

function GitBranchOrCurrentCommit {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    local branch=$(git branch --show-current)
    if [[ "" == "$branch" ]]; then
        # Detached HEAD state. Get current commit.
        branch=$(git rev-parse --short HEAD)
    fi

    echo $branch
    return 0
}

function GitRepoHasChanges {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    local porcelain=$(git status --porcelain)
    if [[ "" == "$porcelain" ]]; then
        return 1
    fi

    return 0
}

function GitRepoCountChanges {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    local porcelain=$(git status --porcelain)
    local count=0
    if [[ "" != "$porcelain" ]]; then
        count=$(wc -l <<< "${porcelain}")
    fi

    echo $count
    return 0
}

function GitRepoStashCount {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    local stash=$(git rev-list --walk-reflogs --ignore-missing --count refs/stash)
    echo $stash
    return 0
}

function GitRepoCommitCountHead {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    IsEmptyRepo
    if [[ 0 == $? ]]; then
        echo "0"
        return 0
    fi

    local count=$(git rev-list --count HEAD)
    echo $count
    return 0
}

function GitRepoCommitCountMain {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    IsEmptyRepo
    if [[ 0 == $? ]]; then
        echo "0"
        return 0
    fi

    local defaultBranch=$(GitGetMainBranchName)

    local count=$(git rev-list --count $defaultBranch)
    echo $count
    return 0
}

function GitRepoCommitsNotInMain {
    IsGitRepo
    if [[ 0 != $? ]]; then
        return 1
    fi

    local current=$(GitRepoCommitCountHead)
    local main=$(GitRepoCommitCountMain)

    local diff=$(expr $current - $main)
    echo $diff
    return 0
}
