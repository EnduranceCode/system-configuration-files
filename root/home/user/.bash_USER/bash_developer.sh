#!/usr/bin/env bash
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains git related custom bash aliases and functions. Source it from the bash_"${USER}".sh file on the
# ~/.bash_"${USER}" folder, adding the below snippet on the referred bash_"${USER}".sh file.
#
#   if [ -f ~/.bash_"${USER}"/bash_git.sh ]; then
#       source ~/.bash_"${USER}"/bash_git.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Global development command aliases
# + Global development custom bash functions
#   + set-eslint()
# + Projects related custom bash aliases and functions
#
# ----------------------------------------------------------------------------------------------------------------------

# Global development command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias code-dev='clear && echo "[code]" && echo "------" && cd ~/code && ls --group-directories-first -la'

alias npm-global='npm list -g --depth 0'

# Global development related bash functions
# ----------------------------------------------------------------------------------------------------------------------

# Install and config ESLint in a project's root folder to use with VS Code
#
set-eslint()
{
    npm install --save-dev eslint
    npm install --save-dev eslint-config-prettier
    npm install --save-dev prettier
    npm install --save-dev eslint-plugin-prettier

    echo .
    echo "You now must copy the file .eslintrc.json to the root folder of the project"
}

# Projects related custom bash aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

# To enable Projects related bash aliases and functions a file with specific customizations must be sourced here.
# One file per project should be used (The name of the file - bash_project.sh - should be customized for each project)
#
# if [ -f ~/.bash_"${USER}"/bash_project.sh ]; then
#     source ~/.bash_"${USER}"/bash_project.sh
# fi
