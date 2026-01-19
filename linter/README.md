# Linter / Formatter 設定

Neovim / Cursor / VSCode 共通のリンター・フォーマッター設定ファイル。

## ファイル一覧

| ファイル | 用途 | 対象言語 |
|---------|------|---------|
| `.editorconfig` | インデント・改行コード | 全言語 |
| `pyproject.toml` | Ruff + mypy | Python |
| `.golangci.yml` | golangci-lint | Go |
| `.markdownlint.yaml` | markdownlint | Markdown |
| `.prettierrc` | Prettier | JS/TS/JSON/YAML/Markdown |

## 使用方法

プロジェクトルートに必要な設定をシンボリックリンク：

```bash
# 基本（全プロジェクト共通）
ln -s ~/dotfiles/linter/.editorconfig .editorconfig

# Python プロジェクト
ln -s ~/dotfiles/linter/pyproject.toml pyproject.toml

# Go プロジェクト
ln -s ~/dotfiles/linter/.golangci.yml .golangci.yml

# Markdown を含むプロジェクト
ln -s ~/dotfiles/linter/.markdownlint.yaml .markdownlint.yaml

# Web / JSON / YAML を含むプロジェクト
ln -s ~/dotfiles/linter/.prettierrc .prettierrc
```

## Cursor / VSCode 拡張機能

| 拡張機能 | ID |
|---------|-----|
| EditorConfig | `editorconfig.editorconfig` |
| Ruff | `charliermarsh.ruff` |
| Go | `golang.go` |
| markdownlint | `davidanson.vscode-markdownlint` |
| Prettier | `esbenp.prettier-vscode` |

## Neovim

Mason で自動インストール済み。設定は `nvim/plugin/lang-tools.lua` を参照。

```vim
:MasonInstall ruff mypy golangci-lint markdownlint prettier
```
