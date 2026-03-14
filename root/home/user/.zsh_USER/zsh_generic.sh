#!/usr/bin/env zsh
#
# FILE CONTENT ---------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------------
#
# This files contains generic custom zsh aliases and functions. Source it from the zsh_"${USER}".sh file on the
# ~/.zsh_"${USER}" folder, adding the below snippet on the referred zsh_"${USER}".sh file.
#
#   if [ -f ~/.zsh_"${USER}"/zsh_generic.sh ]; then
#       source ~/.zsh_"${USER}"/zsh_generic.sh
#   fi
#
# ----------------------------------------------------------------------------------------------------------------------
#
# Table of Contents
# -----------------
#
# + Global Command aliases
# + Global Custom zsh functions
#   + path()
#
# ----------------------------------------------------------------------------------------------------------------------

# Global command aliases
# ----------------------------------------------------------------------------------------------------------------------

alias ld='ls --group-directories-first -la'

# Global custom zsh functions
# ----------------------------------------------------------------------------------------------------------------------

# List PATH variables on a formatted mode as explained on the nixCraft blog
# https://www.cyberciti.biz/faq/howto-print-path-variable/
#
function path()
{
    old=$IFS
    IFS=:
    printf "%s\n" "$PATH"
    IFS=$old
}
