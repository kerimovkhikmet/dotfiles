# dotfiles

dotfiles, managed with [GNU Stow](https://www.gnu.org/software/stow/) - one top-level package per tool, mirrored to `$HOME`.

## Install

```sh
git clone --recurse-submodules git@github.com:kerimovkhikmet/dotfiles.git ~/Development/github.com/kerimovkhikmet/dotfiles
cd ~/Development/github.com/kerimovkhikmet/dotfiles
./install.sh
```

The script installs `stow`, `oh-my-posh`, and `ble.sh` (apt/dnf/brew/tarball), clones `tfenv` + `tpm`, then stows the core packages with `--no-folding`. Preview changes first: `./install.sh --dry-run`.

## Layout

| Package | Links | Notes |
| --- | --- | --- |
| `bash` | `~/.bashrc`, `~/.profile`, `~/.bash_aliases`, `~/.blerc`, `~/.config/ohmyposh/` | oh-my-posh prompt + ble.sh autosuggestions, context-gated segments |
| `zsh` | `~/.zshrc`, `~/.config/spaceship/` | oh-my-zsh + spaceship fallback |
| `git` | `~/.gitconfig`, `~/.config/git/`, `~/.pre-commit-config.yaml` | conventional commit template, global hooks (lint + commit-msg), `credential.helper=os` |
| `nvim` | `~/.config/nvim/` | [kickstart.nvim](https://github.com/kerimovkhikmet/kickstart.nvim) submodule - requires nvim ≥ 0.12 |
| `vim` | `~/.vimrc` | minimal shim, nvim is primary |
| `ghostty` | `~/.config/ghostty/` | Rose Pine Moon |
| `tmux` | `~/.config/tmux/tmux.conf` | C-a prefix, TPM + rose-pine, `prefix+f` sessionizer |
| `kitty`, `wezterm` | `~/.config/...` | same theme, occasional/rarely used |
| `aws` | `~/.aws/config` | template only - `~/.aws/credentials` stays private |
| `bin` | `~/.local/bin/` | `git-credential-os`, `tmux-sessionizer` |
| `vscode` | `~/.config/Code/User/settings.json` | VSCodeVim bridge for the nvim migration |

## Post-install

- `exec bash` - oh-my-posh prompt, ble.sh, git aliases (`gco`, `gst`, ...)
- tmux: press `C-a` then `Shift-I` to install plugins via TPM
- optional packages: `stow -R --no-folding kitty wezterm vscode zsh`

## Hooks (global)

Commits are checked on every repo of the machine, via `core.hooksPath = ~/.config/git/hooks` (set in the stowed `~/.gitconfig`):

- `pre-commit` hook - lint/format via [pre-commit](https://pre-commit.com). The config is the dotfiles [`git/.pre-commit-config.yaml`](git/.pre-commit-config.yaml), stowed to `~/.pre-commit-config.yaml`. Requires `uv tool install pre-commit` once per machine. A repo with its own `.pre-commit-config.yaml` runs its own config instead.
- `commit-msg` hook - lint via [commitlint](https://commitlint.js.org): requires `npm install -g @commitlint/cli` once; skipped silently when absent. Accepts both `JIRA-1: Subject` and `type(scope): Subject` headers, capital after colon, body wrap 72.

Both are skipped if their binary is missing, and bypassed per-commit with `git commit --no-verify`.

## Platforms

macOS, Linux, and WSL (Ubuntu + Fedora). One clone per machine - never share a checkout via `/mnt/c` (breaks stow symlinks). On WSL, Windows Terminal needs a Nerd Font installed on the Windows side for prompt glyphs.
