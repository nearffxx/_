" git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
" pip install --user neovim
" cd ~/.config/nvim/bundle/YouCompleteMe && ./install.py --clang-completer --java-completer
set nocompatible
filetype off
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin("~/.config/nvim/bundle")
Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()
filetype plugin indent on


" vim settings
set background=dark
set number
set ss=2
set sw=2
set ts=2
set expandtab

au FileType go set nolist tw=0
au FileType make set noexpandtab
au FileType python set ss=4 ts=4 sw=4 
