" vim - Stow package vim/.vimrc -> ~/.vimrc (minimal shim, nvim is primary)
" nvim config lives at ~/.config/nvim; this .vimrc is fallback
" when nvim is not available (remote servers, minimal installs).
" Keep POSIX sh compatible, no hardcoded $HOME.

set nocompatible
filetype plugin indent on
syntax on

" --- behavior - keep $HOME portable ---
set encoding=utf-8
set hidden
set history=1000
set undofile
set undodir=$HOME/.vim/undo//
set directory=$HOME/.vim/swap//
set backupdir=$HOME/.vim/backup//
" create dirs if missing (silent)
if !isdirectory(expand("$HOME/.vim/undo")) | call mkdir(expand("$HOME/.vim/undo"), "p", 0700) | endif
if !isdirectory(expand("$HOME/.vim/swap")) | call mkdir(expand("$HOME/.vim/swap"), "p", 0700) | endif
if !isdirectory(expand("$HOME/.vim/backup")) | call mkdir(expand("$HOME/.vim/backup"), "p", 0700) | endif

" --- ui - match nvim/ghostty Rose Pine sensibly, not hardcoded ---
set number
set relativenumber
set cursorline
set showcmd
set ruler
set laststatus=2
set background=dark
" use 256 colors if available (ghostty/kitty/tmux true color)
if &t_Co >= 256 | set termguicolors | endif

" --- editing - sane defaults for macOS/Linux/WSL ---
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent
set ignorecase
set smartcase
set incsearch
set hlsearch
set mouse=a
set clipboard=unnamedplus,unnamed
set backspace=indent,eol,start

" --- leader - same as nvim default (<Space>) ---
let mapleader = " "
let maplocalleader = " "

" --- shim - if nvim is installed, prefer it for `vim` invocation ---
" Note: this .vimrc is only for `vim`; `nvim` ignores it and uses init.lua.
" To make `vim` exec `nvim` when available, add to shell rc:
"   command -v nvim >/dev/null && alias vim=nvim
" Keeping alias out of .vimrc avoids recursion.

" --- portable - no hardcoded /home/khikmetkerimov ---
