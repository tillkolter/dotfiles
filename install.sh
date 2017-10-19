#!/bin/bash

ask_for_confirmation() {
  print_question "$1 (y/n) "
  read -n 1
  printf "\n"
}

answer_is_yes() {
  [[ "$REPLY" =~ ^[Yy]$ ]] \
    && return 0 \
    || return 1
}

print_question() {
  # Print output in yellow
  printf "\e[0;33m  [?] $1\e[0m"
}

print_success() {
  # Print output in green
  printf "\e[0;32m  [✔] $1\e[0m\n"
}

install_vundle() {
    printf "\e[0;33m Checking Vundle installation\e[0m\n"

    [ ! -d ~/.vim/bundle ] && mkdir -p ~/.vim/bundle

    # Install Vundle if does not exist
    if [[ -d "~/.vim/bundle/Vundle.vim" ]]; then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        vim -c 'PluginInstall' -c 'qa!'
    else
        printf "\e[0;33m  [✔] Vundle already installed\e[0m\n"
    fi
}

# Warn user this script will overwrite current dotfiles
while true; do
 read -p "Warning: this will overwrite your current dotfiles. Continue? [y/n] " yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
  esac
done

# Get the dotfiles directory's absolute path
SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"


dir=~/dotfiles                        # dotfiles directory
dir_backup=~/dotfiles_old             # old dotfiles backup directory

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# Create dotfiles_old in homedir
echo -n "Creating $dir_backup for backup of any existing dotfiles in ~..."
mkdir -p $dir_backup
echo "done"

# Change to the dotfiles directory
echo -n "Changing to the $dir directory..."
cd $dir
echo "done"

#
# Actual symlink stuff
#



declare -a FILES_TO_SYMLINK=(

  'shell/shell_aliases'
#  'shell/shell_config'
#  'shell/shell_exports'
#  'shell/shell_functions'
  'shell/bash_profile'
  'shell/bashrc'
  'git/gitconfig'
  'git/gitignore'
  'vim/vimrc'
)


# Move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files

for i in ${FILES_TO_SYMLINK[@]}; do
  echo "Moving any existing dotfiles from ~ to $dir_backup"
  mv ~/.${i##*/} ~/dotfiles_old/
done

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

  local i=''
  local sourceFile=''
  local targetFile=''

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  for i in ${FILES_TO_SYMLINK[@]}; do

    sourceFile="$(pwd)/$i"
    targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

    if [ ! -e "$targetFile" ]; then
      eval "ln -fs $sourceFile $targetFile"  # "$targetFile -> $sourceFile"
    elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
      print_success "$targetFile -> $sourceFile"
    else
      ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
      if answer_is_yes; then
        rm -rf "$targetFile"
        execute "ln -fs $sourceFile $targetFile" "$targetFile -> $sourceFile"
      else
        print_error "$targetFile ->  $sourceFile"
      fi
    fi

  done

  unset FILES_TO_SYMLINK
  install_vundle
}

main

