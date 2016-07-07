#!/usr/bin/env bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +BundleInstall +qall
ln -s vim ~/.vim 
ln -s vimrc/vimrc ~/.vimrc 

