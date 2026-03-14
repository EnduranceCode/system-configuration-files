#!/usr/bin/env zsh
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains git related custom zsh aliases and functions. Source it from the zsh_"${USER}".sh file on the
# ~/.zsh_"${USER}" folder, adding the below snippet on the referred zsh_"${USER}".sh file.
#
#   if [ -f ~/.zsh_"${USER}"/zsh_git.sh ]; then
#       source ~/.zsh_"${USER}"/zsh_git.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Git related command aliases
# + Git related custom zsh functions
#   + set-author()
#   + set-date()
#   + changed-files()
#   + todos()
#
# ----------------------------------------------------------------------------------------------------------------------

# Git related command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias cgb='clear && git branch'
alias gb='git branch'
alias cgl='clear && git log --oneline -15'
alias gl='git log --oneline -15'
alias cgs='clear && git status'
alias gs='git status'
alias cgls='clear && git log --oneline -15 && git status'
alias gls='git log --oneline -15 && git status'
alias cgd='clear && git diff'
alias gd='git diff'
alias gpr='git pull --rebase'

# Git related custom zsh commands
# ----------------------------------------------------------------------------------------------------------------------

# Set the author for the repository
#
# Made with the help of the following resource:
# + https://smarterco.de/set-the-username-and-email-in-git-globally-and-per-project/#set-the-usernameemail-for-a-specific-repository
#
set-author()
{
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo -e "[\e[31mERROR\e[0m] Not inside a Git repository!"
        echo
        return 1
    fi

    local USERNAME=""
    local EMAIL=""
    local OPTIND=1

    usage() {
        echo "Usage: set-author [-u username] [-e email] [-h]"
        echo
        echo "Options:"
        echo "  -u    Set the git user.name"
        echo "  -e    Set the git user.email"
        echo "  -h    Display this help message"
    }

    while getopts "u:e:h" opt; do
        case $opt in
            u) USERNAME="$OPTARG" ;;
            e) EMAIL="$OPTARG" ;;
            h) usage; return 0 ;;
            *) usage; return 1 ;;
        esac
    done
    shift $((OPTIND - 1))

    echo -e "[\e[34mINFO\e[0m] Setting the author's name and email for this repository"

    if [ -z "$USERNAME" ]; then
        echo
        read -r "USERNAME?Type the name of the repository's author: "
    fi

    if [ -z "$EMAIL" ]; then
        echo
        read -r "EMAIL?Type the email of the repository's author: "
    fi

    if [ ! -z "${USERNAME}" ] && [ ! -z "${EMAIL}" ]; then
        git config user.name "${USERNAME}"
        git config user.email "${EMAIL}"
    else
        echo -e "[\e[31mERROR\e[0m] Missing required information. The repository author not updated."
        echo
        return 1
    fi

    echo -e "[\e[34mINFO\e[0m] This repository author is set with name: $(git config --get user.name)"
    echo -e "[\e[34mINFO\e[0m] This repository author is set with email: $(git config --get user.email)"
    echo
}

# Set the date of a commit
#
# Made with the help of the following resource:
# https://smarterco.de/set-the-username-and-email-in-git-globally-and-per-project/#set-the-usernameemail-for-a-specific-repository
# https://www.cyberciti.biz/faq/bash-remove-whitespace-from-string/
#
set-date()
{
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo
        echo -e "[\e[31mERROR\e[0m] Not inside a Git repository!"
        echo
        return 1
    fi

    if ! git diff --cached --quiet; then
        echo
        echo -e "[\e[31mERROR\e[0m] You have staged changes! Aborting to prevent their inclusion in the amended commit."
        echo
        return 1
    fi

    echo
    echo "This will set a new date for the following commit:"
    echo
    echo -e "\t$(git log -1 --format=%cd --date=format:"%Y-%m-%dT%H:%M:%S")\t$(git log -1 --oneline --no-color --format=%s)"
    echo

    local LIMIT_DATE
    LIMIT_DATE=$(git log -2 --format=%cd --date=format:"%Y-%m-%dT%H:%M:%S" | tail -n1)

    echo "The new date must be in a valid ISO8601 or RFC2822 format and must be later than ${LIMIT_DATE}"
    echo
    echo -e "\t[ISO8601]\t1996-01-23T08:00:00"
    echo -e "\t[RFC2822]\tTue, 23 Jan 1996 08:00:00 +0000"
    echo

    # Zsh uses 'read -r "VARNAME?prompt"' syntax instead of 'read -r -p "prompt" VARNAME'
    read -e -r "NEW_DATE?Type the new commit's date: "
    echo

    # Trim leading/trailing whitespace
    NEW_DATE="${NEW_DATE## }"
    NEW_DATE="${NEW_DATE%% }"
    NEW_DATE=$(echo "$NEW_DATE" | xargs)

    if [[ -z "${NEW_DATE}" ]]; then
        echo -e "[\e[31mERROR\e[0m] No date entered! No changes were made to the last commit's date."
        echo
        return 1
    fi

    if ! date -d "${NEW_DATE}" >/dev/null 2>&1; then
        echo -e "[\e[31mERROR\e[0m] Invalid date format! No changes were made to the last commit's date. Please use a valid RFC2822 or ISO8601 date."
        echo
        return 1
    fi

    if [ "$(date -d "$NEW_DATE" +%s)" -le "$(date -d "$LIMIT_DATE" +%s)" ]; then
        echo -e "[\e[31mERROR\e[0m] Invalid date! No changes were made to the last commit's date. Please provide a date later than $LIMIT_DATE."
        echo
        return 1
    fi

    if GIT_COMMITTER_DATE="${NEW_DATE}" git commit --no-verify --amend --no-edit --date "${NEW_DATE}"; then
        echo
        echo -e "[\e[34mINFO\e[0m] The last commit date is now: $(git log -1 --format=%cd)"
    else
        echo -e "[\e[31mERROR\e[0m] Failed to amend the commit date."
        echo
        return 1
    fi
    echo
}

# List all files changed with a specific commit
#
# Made with the help of the following resource:
#   + https://stackoverflow.com/a/424142
#
changed-files()
{
    if [ "$#" -eq 0 ]; then
        echo "Please add a parameter with the hash of the commit to be checked:"
    else
        git diff-tree --no-commit-id --name-only -r "$1"
    fi
}

# List the lines with TODO in the output of the command
# git diff from the first commit authored by the repos current user
#
# Made with the help of the following resources:
#   + https://www.tecmint.com/assign-linux-command-output-to-variable/
#   + https://stackoverflow.com/a/4262780
#   + https://stackoverflow.com/a/31448684
#   + https://stackoverflow.com/a/10067297
#   + https://stackoverflow.com/a/2798833
#   + https://stackoverflow.com/a/6482403
#
todos()
{
    USERNAME=$(git config user.name)
    FIRST_COMMIT=$(git log --oneline --author="${USERNAME}" --reverse --pretty=format:"%h" | grep -m1 "")

    if [ "$#" -eq 0 ]; then
        git diff "${FIRST_COMMIT}" | grep TODO: | grep +
    else
        git diff "$1" | grep TODO: | grep +
    fi
}
