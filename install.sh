#!/usr/bin/env bash
# install.sh - one-click bootstrap for GNU Stow dotfiles (macOS/Linux/WSL)
# dir-agnostic, no hardcoded ~/dotfiles
# Usage: ./install.sh [--dry-run] | curl | bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=1
  echo "DRY RUN: no changes will be made"
fi

info()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m!! \033[0m %s\n" "$*"; }
# run() takes display strings on purpose: dry-run echoes the exact command,
# run evals it
# shellcheck disable=SC2294
run()   { if (( DRY_RUN )); then echo "+ $*"; else eval "$@"; fi; }

# --- OS detect - use $OSTYPE (bashism allowed here, this is bash) ---
OSTYPE_VAL="${OSTYPE:-$(uname -s | tr '[:upper:]' '[:lower:]')}"
IS_MAC=0; IS_LINUX=0; IS_WSL=0
case "$OSTYPE_VAL" in
  darwin*) IS_MAC=1 ;;
  linux*)
    IS_LINUX=1
    if grep -qi microsoft /proc/version 2>/dev/null; then IS_WSL=1; fi
    ;;
esac

# --- helpers ---
have() { command -v "$1" >/dev/null 2>&1; }

install_stow() {
  if have stow; then info "stow $(stow --version | head -1) - ok"; return; fi
  info "installing stow..."
  if (( IS_MAC )); then
    if have brew; then run brew install stow
    else warn "brew not found - install Homebrew first: https://brew.sh"; exit 1; fi
  elif (( IS_LINUX )); then
    if have apt-get; then run sudo apt-get update && run sudo apt-get install -y stow
    elif have dnf; then run sudo dnf install -y stow
    elif have pacman; then run sudo pacman -S --noconfirm stow
    else warn "no apt/dnf/pacman - install stow manually"; exit 1; fi
  fi
}

install_oh_my_posh() {
  if have oh-my-posh; then info "oh-my-posh $(oh-my-posh --version 2>&1 | head -1) - ok"; return; fi
  info "installing oh-my-posh to ~/.local/bin..."
  local dest="$HOME/.local/bin"
  run mkdir -p "$dest"
  # upstream installer: https://ohmyposh.dev/docs/installation/linux
  # -d flag picks dest; fallback is ~/bin or ~/.local/bin
  if (( DRY_RUN )); then echo "+ curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $dest"; else
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$dest"
  fi
  # ensure dest in PATH for current session
  export PATH="$dest:$PATH"
}

install_blesh() {
  if [[ -s "$HOME/.local/share/blesh/ble.sh" ]]; then info "ble.sh - ok"; return; fi
  info "installing ble.sh (nightly) to ~/.local/share/blesh..."
  local tmp; tmp=$(mktemp -d)
  if (( DRY_RUN )); then
    echo "+ curl -fsSL https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar -xJ --strip-components=1 -C $tmp"
    echo "+ bash $tmp/ble.sh --install $HOME/.local/share/blesh"
  else
    curl -fsSL https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar -xJ --strip-components=1 -C "$tmp"
    bash "$tmp/ble.sh" --install "$HOME/.local/share/blesh"
    # some installer versions nest modules one level deep - flatten to canonical layout
    if [[ ! -s "$HOME/.local/share/blesh/ble.sh" && -s "$HOME/.local/share/blesh/blesh/ble.sh" ]]; then
      mv "$HOME/.local/share/blesh/blesh" "$HOME/.local/share/blesh/_tmp"
      (shopt -s dotglob nullglob; mv "$HOME/.local/share/blesh/_tmp/"* "$HOME/.local/share/blesh/")
      rmdir "$HOME/.local/share/blesh/_tmp"
    fi
  fi
  rm -rf "$tmp"
}

# --- 1. deps ---
install_stow
install_oh_my_posh
install_blesh

# optional toolchain
# Uncomment to also install (apt = Ubuntu/WSL-Ubuntu, dnf = Fedora/WSL-Fedora):
# have ruff       || run uv tool install ruff
# have shellcheck || (( IS_MAC )) && run brew install shellcheck || { have dnf && run sudo dnf install -y ShellCheck; } || run sudo apt-get install -y shellcheck
# have shfmt      || run go install mvdan.cc/sh/v3/cmd/shfmt@latest
# have aws        || (( IS_MAC )) && run brew install awscli || { have dnf && run sudo dnf install -y awscli; } || run sudo apt-get install -y awscli

install_tfenv() {
  if have tfenv; then info "tfenv - ok"; return; fi
  if [[ -d "$HOME/.tfenv/.git" ]]; then
    export PATH="$HOME/.tfenv/bin:$PATH"
    info "tfenv at ~/.tfenv - ok"
    return
  fi
  info "cloning tfenv to ~/.tfenv (then: tfenv install <version>)..."
  run git clone --depth=1 https://github.com/tfutils/tfenv.git "$HOME/.tfenv"
  export PATH="$HOME/.tfenv/bin:$PATH"
}

install_tpm() {
  if [[ -d "$HOME/.tmux/plugins/tpm/.git" ]]; then info "tpm - ok"; return; fi
  info "cloning tpm to ~/.tmux/plugins/tpm (in tmux: prefix + I to install plugins)..."
  run git clone --depth=1 https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"
}

# --- 2. submodules (nvim) ---
info "syncing submodules..."
run git -C "$DOTFILES_DIR" submodule update --init --recursive

# --- 3. stow - mirror $HOME, no per-OS dirs yet ---
# --no-folding: link files individually so mixed dirs (~/.aws with private
# credentials, ~/.config/ghostty) keep non-stowed files OUTSIDE the repo.
# Conflicts: existing real files (~/.bashrc, ~/.gitconfig, ~/.config/nvim, ...)
# abort stow - move them aside first.
# Keep zsh as fallback; bash is the primary shell
install_tfenv
install_tpm
PACKAGES=(bash git nvim vim ghostty tmux aws bin)
# optional, stow if you use them (kitty occasional, wezterm rarely, vscode = nvim-migration bridge):
# PACKAGES+=(kitty wezterm vscode)
# To include zsh fallback: PACKAGES+=(zsh)

info "stowing: ${PACKAGES[*]} -> $HOME (DOTFILES_DIR=$DOTFILES_DIR)"
for pkg in "${PACKAGES[@]}"; do
  if [[ -d "$DOTFILES_DIR/$pkg" ]]; then
    if (( DRY_RUN )); then run stow -n -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg"
    else run stow -R --no-folding -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg"; fi
  else warn "package $pkg missing at $DOTFILES_DIR/$pkg - skip"; fi
done

# --- 4. verify ---
info "verify: stow -n -v dry-run for each package (should be no-ops)"
for pkg in "${PACKAGES[@]}"; do
  [[ -d "$DOTFILES_DIR/$pkg" ]] || continue
  run stow -n -v -d "$DOTFILES_DIR" -t "$HOME" "$pkg" | head -20 || true
done

info "done. Restart shell or: source ~/.bashrc"
if (( IS_WSL )); then
  info "WSL detected: install a Nerd Font on Windows for prompt glyphs; win32yank.exe enables nvim clipboard"
fi
info "tmux plugins: open tmux, press C-a then Shift-I (TPM installs rose-pine)"
info "zsh fallback: stow -R --no-folding -v -d $DOTFILES_DIR -t $HOME zsh"
info "optional: stow -R --no-folding -v -d $DOTFILES_DIR -t $HOME kitty wezterm"
