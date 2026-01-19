# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles for Arch Linux (EndeavourOS) with i3 window manager, Zsh shell, Ghostty terminal, and Neovim editor. Japanese language environment with Fcitx5/Mozc input.

## Installation

Configs are installed via symlinks to `$XDG_CONFIG_HOME` (typically `~/.config/`):

```bash
# i3
ln -s $HOME/dotfiles/i3 $XDG_CONFIG_HOME/i3

# Zsh
mkdir -p $HOME/.config/zsh
ln -s $HOME/dotfiles/zsh/.zshenv $HOME/.zshenv
ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.config/zsh/.zshrc
ln -s $HOME/dotfiles/zsh/config $HOME/.config/zsh/config

# Neovim
ln -s $HOME/dotfiles/nvim $XDG_CONFIG_HOME/nvim

# Ghostty
ln -s $HOME/dotfiles/ghostty $XDG_CONFIG_HOME/ghostty

# Rofi
ln -s $HOME/dotfiles/rofi $XDG_CONFIG_HOME/rofi

# Dunst
ln -s $HOME/dotfiles/dunst $XDG_CONFIG_HOME/dunst

# Picom
ln -s $HOME/dotfiles/picom $XDG_CONFIG_HOME/picom

# Git
ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
```

## Architecture

### Modular Configuration Pattern

Each tool uses a modular import/source pattern:

- **Zsh**: `.zshrc` sources files from `config/` directory (base.zsh, aliases.zsh, plugins.zsh, fzf.zsh, p10k.zsh, arch.zsh)
- **Neovim**: `init.lua` requires lua modules; plugin configs are in `plugin/` directory
- **Ghostty**: Single `config` file with sectioned settings (font, theme, window, keybindings)

### Neovim LSP/Tools Setup

Language tools are managed via Mason in `nvim/plugin/lang-tools.lua`:

**LSP Servers**: lua_ls, bashls, jsonls, yamlls, pylsp, gopls, ansiblels, dockerls, terraformls, markdown_oxide

**Formatters**: prettier, stylua, gofumpt, goimports, black, isort, shfmt, yamlfmt, terraform_fmt

**Linters**: golangci-lint, pylint, mypy, markdownlint, hadolint, yamllint, dotenv-linter

Formatting runs automatically on save via null-ls.

### Key Neovim Commands

- `:KeymapHelp` - General keymap reference
- `:LspKeymapHelp` - LSP-specific keymaps
- `:TelescopeHelp` - File search keymaps
- `<Space>h` in nvim-tree - File tree operations

### i3 Scripts

Helper scripts in `i3/scripts/` for volume, brightness, power menu, CPU/memory/disk usage, temperature monitoring, and workspace management.

### Polybar Modules

Custom scripts in `polybar/scripts/` for Docker status, Kubernetes status, audio switching, and floating terminal.

### Desktop Components

- **Rofi**: Application launcher with custom themes (`rofidmenu.rasi`) and power menu (`powermenu.rasi`, `powermenu.sh`)
- **Dunst**: Notification daemon (`dunstrc`)
- **Picom**: Compositor for transparency and effects (`picom.conf`)

## Git Configuration

Based on [How Git core devs configure Git](https://blog.gitbutler.com/how-git-core-devs-configure-git). Key settings:

- `diff.algorithm = histogram` - More accurate diffs
- `diff.colorMoved = plain` - Highlight moved code
- `push.autoSetupRemote = true` - Auto-setup upstream branch
- `fetch.prune = true` - Auto-delete removed remote branches
- `pull.rebase = true` - Rebase on pull
- `commit.verbose = true` - Show diff in commit editor
- `rerere.enabled = true` - Record and reuse conflict resolutions
- `rebase.autoSquash = true` - Auto-squash fixup! commits
- `merge.conflictstyle = zdiff3` - Show merge base in conflicts

**Common aliases**:
- `git cim "msg"` - commit with message
- `git ciamne` - amend commit without editing message
- `git sw` / `git swc` - switch branch / create and switch
- `git dica` - diff cached (staged changes)

## Branch Strategy

Trunk-based development with simple rules:

- **Small changes**: Commit directly to `main`
- **Large/experimental changes**: Create feature branch → PR → merge to `main`

**Branch naming convention**: `<type>-<description>` (kebab-case)

| Type | Usage | Example |
|------|-------|---------|
| `add-` | New feature/config | `add-docker-config` |
| `update-` | Improve existing | `update-zsh-config` |
| `fix-` | Bug fix | `fix-fzf-keybindings` |
| `remove-` | Delete config/feature | `remove-unused-aliases` |

**Commit/PR language**: 日本語で記述

**GitHub Branch Protection (main)**:
- Require pull request: OFF (direct push allowed)
- Allow force pushes: ON
- Allow deletions: OFF

## Secrets Management

Uses [dotenvx](https://dotenvx.com/) for encrypted environment variables in `secrets/` directory.

- `.env.secrets` - Encrypted secrets (safe to commit)
- `.env.keys` - Private keys (NEVER commit, store in password manager)

```bash
# Add secret
dotenvx set KEY "value" -f secrets/.env.secrets

# Load secrets and run command
dotenvx run -f secrets/.env.secrets -- command

# Load into current shell
eval $(dotenvx get -f secrets/.env.secrets --format shell)
```
