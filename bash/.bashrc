# ~/.bashrc: executed by bash(1) for non-login shells.
# shellcheck shell=bash
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ble.sh - fish-like autosuggestions + syntax highlighting (replaces zsh-autosuggestions/zsh-syntax-highlighting)
# source with --noattach here, ble-attach at the very bottom (after oh-my-posh) per ble.sh docs
[[ $- == *i* ]] && [ -s "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh" --noattach

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
# Ubuntu: /usr/bin/lesspipe; Fedora: /usr/bin/lesspipe.sh
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
elif [ -x /usr/bin/lesspipe.sh ]; then
    eval "$(lesspipe.sh 2>/dev/null)"
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    # shellcheck source=.bash_aliases
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# locale - en_US.UTF-8 when present (Fedora needs glibc-langpack-en), else C.UTF-8 fallback
if locale -a 2>/dev/null | grep -qi 'en_US.utf8'; then
  export LC_ALL=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LANGUAGE=en_US.UTF-8
else
  export LC_ALL=C.UTF-8
  export LANG=C.UTF-8
fi

# go bin - go install tools (shfmt etc.)
if [ -d "$HOME/go/bin" ]; then
  case ":$PATH:" in
    *":$HOME/go/bin:"*) ;;
    *) export PATH="$HOME/go/bin:$PATH" ;;
  esac
fi

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# sdkman - cross-system Java/Kotlin/Gradle toolchain (portable macOS/Linux/WSL)
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# tfenv - terraform version manager (sdkman-like, install.sh clones to ~/.tfenv)
export TFENV_DIR="$HOME/.tfenv"
if [ -d "$TFENV_DIR/bin" ]; then
  case ":$PATH:" in
    *":$TFENV_DIR/bin:"*) ;;
    *) export PATH="$TFENV_DIR/bin:$PATH" ;;
  esac
fi

# nvim - /opt release layout (Linux/WSL); brew manages PATH on macOS.
# core.editor=nvim (gitconfig) needs it resolvable.
if [ -d "/opt/nvim-linux-x86_64/bin" ]; then
  case ":$PATH:" in
    *":/opt/nvim-linux-x86_64/bin:"*) ;;
    *) export PATH="/opt/nvim-linux-x86_64/bin:$PATH" ;;
  esac
fi

# local bin - keep $HOME portable (macOS/Linux/WSL), for oh-my-posh etc.
export PATH="$HOME/.local/bin:$PATH"

# oh-my-posh prompt - config at ~/.config/ohmyposh/config.json
if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init bash --config "$HOME/.config/ohmyposh/config.json")"
fi

# ble.sh attach - keep LAST (wraps oh-my-posh PROMPT_COMMAND); config in ~/.blerc
[[ ${BLE_VERSION-} ]] && ble-attach

# opencode - portable, deduped
if [ -d "$HOME/.opencode/bin" ]; then
  case ":$PATH:" in
    *":$HOME/.opencode/bin:"*) ;;
    *) export PATH="$HOME/.opencode/bin:$PATH" ;;
  esac
fi
