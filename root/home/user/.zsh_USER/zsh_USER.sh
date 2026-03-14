#!/usr/bin/env zsh
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains all the necessary zsh shell configurations. To be able to use this file, it must be stored
# in the following folder:
#
#   ~/.zsh_"${USER}"
#
# Be aware that ${USER} holds the system-defined variable USER value (the current user's name). If the folder mentioned
# above doesn't exist, create it and set the right folder permissions with the following commands:
#
#   mkdir ~/.zsh_"${USER}"
#   chmod 700 ~/.zsh_"${USER}"
#
# Source it from the ~/.zshrc file on the home folder, adding the below snippet
# to the end of the referred ~/.zshrc file.
#
#   if [ -f ~/.zsh_"${USER}/zsh_"${USER}.sh ]; then
#       . ~/.zsh_"${USER}/zsh_"${USER}.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Command prompt customization
# + Generic custom zsh aliases and functions
# + Git related custom zsh aliases and functions
# + Developer related custom zsh aliases and functions
#
# ----------------------------------------------------------------------------------------------------------------------

# Command prompt customization
# ----------------------------------------------------------------------------------------------------------------------

# color codes from https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
# colors!
#
# shellcheck disable=SC2034
black="%F{black}"
red="%F{red}"
green="%F{green}"
yellow="%F{yellow}"
blue="%F{blue}"
magenta="%F{magenta}"
cyan="%F{cyan}"
white="%F{white}"
brightBlack="%F{brightblack}"
brightRed="%F{brightred}"
brightGreen="%F{brightgreen}"
brightYellow="%F{brightyellow}"
brightBlue="%F{brightblue}"
brightMagenta="%F{brightmagenta}"
brightCyan="%F{brightcyan}"
brightWhite="%F{brightwhite}"
reset="%f%b"

# Enable parameter expansion and command substitution in the prompt
#
# IMPORTANT NOTE:
# When using oh-my-zsh or a similar framework, this option is always set by the framework,
# so it should be removed from this file to avoid redundancy.
#
setopt PROMPT_SUBST

# Load vcs_info for git integration
#
# IMPORTANT NOTE:
# When using oh-my-zsh or a similar framework, this command and the zstyle configuration block below it should be
# removed from this file. oh-my-zsh does NOT use vcs_info — it uses its own internal git inspection functions
# (e.g. git_prompt_info()). These settings will have no effect and will be overridden by the active theme.
#
autoload -Uz vcs_info

# Configure vcs_info to show git branch and dirty state
# '%b'  expands to the current branch name
# '%u'  expands to unstaged changes indicator (requires check-for-changes)
# '%c'  expands to staged changes indicator (requires check-for-changes)
#
#
# IMPORTANT NOTE:
# See the note above on 'autoload -Uz vcs_info'. These zstyle rules should be removed together with the vcs_info block
# when using oh-my-zsh or a similar framework.
#
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'

# Run vcs_info before each prompt render
#
# IMPORTANT NOTE:
# When using oh-my-zsh or a similar framework, this bare precmd() definition must be removed. oh-my-zsh registers
# its own prompt hooks via 'add-zsh-hook precmd'. Defining a bare precmd() function replaces ALL hooks registered
# that way, silently breaking the active theme.
#
precmd() {
    vcs_info
}

# Custom the Zsh prompt
#
# '%m'              adds the hostname up to the first '.'
# '%n'              adds the name of the current user to the prompt
# '%1~'             adds the name of the current directory (trailing component only)
# '${vcs_info_msg_0_}'  adds git-related stuff (branch + dirty state)
#
# Further reading in https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
#
# IMPORTANT NOTE:
# When using oh-my-zsh or a similar framework, this line must be removed. The active theme always sets PROMPT after
# this file is sourced, overwriting this value entirely.
#
export PROMPT="${brightMagenta}[%m]${reset}:${green}%n${reset}:${red}%1~${yellow}\${vcs_info_msg_0_} ${reset}"$'\n'"${red}%# ${reset}"

# Initialize ZSH completion system
# Enables tab completion for all commands (git, npm, system commands, custom functions, etc.).
#
# IMPORTANT NOTE:
# When using oh-my-zsh or a similar framework, this command is always run by the framework,
# so it should be removed from this file to avoid issues with tab completion.
#
autoload -Uz compinit && compinit

# Generic custom zsh aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

if [ -f ~/.zsh_"${USER}"/zsh_generic.sh ]; then
    # shellcheck disable=SC1090
    source ~/.zsh_"${USER}"/zsh_generic.sh
fi

# Git related custom zsh aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

if [ -f ~/.zsh_"${USER}"/zsh_git.sh ]; then
    # shellcheck disable=SC1090
    source ~/.zsh_"${USER}"/zsh_git.sh
fi

# Developer related custom zsh aliases and functions
# ----------------------------------------------------------------------------------------------------------------------

if [ -f ~/.zsh_"${USER}"/zsh_developer.sh ]; then
    # shellcheck disable=SC1090
    source ~/.zsh_"${USER}"/zsh_developer.sh
fi
