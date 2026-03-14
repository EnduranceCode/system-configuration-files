#!/usr/bin/env zsh
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains developer related custom zsh aliases and functions. Source it from the zsh_"${USER}".sh file on
# the ~/.zsh_"${USER}" folder, adding the below snippet on the referred zsh_"${USER}".sh file.
#
#   if [ -f ~/.zsh_"${USER}"/zsh_developer.sh ]; then
#       source ~/.zsh_"${USER}"/zsh_developer.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Global development command aliases
# + Global development custom zsh functions
#   + set-eslint()
# + Projects related custom zsh aliases and functions
#
# ----------------------------------------------------------------------------------------------------------------------

# Global development command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias code-dev='clear && echo "[code]" && echo "------" && cd ~/code && ls --group-directories-first -la'

alias npm-global='npm list -g --depth 0'

# Global development related zsh functions
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

# Projects related custom zsh aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

# To enable Projects related zsh aliases and functions a file with specific customizations must be sourced here.
# One file per project should be used (The name of the file - zsh_project.sh - should be customized for each project)
#
# if [ -f ~/.zsh_"${USER}"/zsh_project.sh ]; then
#     source ~/.zsh_"${USER}"/zsh_project.sh
# fi
