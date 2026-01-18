<br>
<br>
<br>
<br>
<p align="center">
  <img src="assets/logo.png" alt="Logo" width="400">
</p>

<h1 align="center">Dotfiles</h1>

<div align="center"><p>
<img alt="Commit Activity" src="https://img.shields.io/github/commit-activity/m/v8yte/dotfiles?style=for-the-badge&logo=instatus&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41" />
<img alt="Last Commit" src="https://img.shields.io/github/last-commit/v8yte/dotfiles?style=for-the-badge&logo=instatus&color=ee999f&logoColor=D9E0EE&labelColor=302D41" />
<img src="https://img.shields.io/github/license/v8yte/dotfiles?style=for-the-badge&logo=instatus&color=c69ff5&logoColor=D9E0EE&labelColor=302D41" alt="GitHub License"><br>
<img src="https://img.shields.io/github/watchers/v8yte/dotfiles?style=for-the-badge&logo=bilibili&color=F5E0DC&logoColor=D9E0EE&labelColor=302D41" alt="Codecov coverage">
<img src="https://img.shields.io/github/repo-size/v8yte/dotfiles?color=%23DDB6F2&label=SIZE&logo=instatus&style=for-the-badge&logoColor=D9E0EE&labelColor=302D41" alt="GitHub code size">
</div>

## General

自分が普段使用しているArch Linux(EndeavourOS)のDotFilesを公開しています。

使い慣れたカスタム設定やエイリアス、ツールの設定などが含まれております。自由にカスタマイズしてみてください。

### Environment

|                |                         Value                         |
| -------------- | :---------------------------------------------------: |
| **OS**         |   Arch Linux([EndeavourOS](https://endeavouros.com/)) |
| **Languages**  |                         ja_JP                         |

### Managed Configurations

| Category             | Tool                                        |
| -------------------- | :-----------------------------------------: |
| **Window Manager**   | [i3](https://i3wm.org/)                     |
| **Status Bar**       | [Polybar](https://github.com/polybar/polybar) |
| **Shell**            | [Zsh](https://zsh.org/)                     |
| **Terminal**         | [Ghostty](https://ghostty.org/)             |
| **Editor**           | [Neovim](https://neovim.io/)                |
| **Launcher**         | [Rofi](https://github.com/davatorium/rofi)  |
| **Notifications**    | [Dunst](https://dunst-project.org/)         |
| **Compositor**       | [Picom](https://github.com/yshui/picom)     |
| **Version Control**  | [Git](https://git-scm.com/)                 |
| **Secrets**          | [dotenvx](https://dotenvx.com/)             |

## i3wm

### Installation

```
ln -s $HOME/dotfiles/i3 $XDG_CONFIG_HOME/i3
```

### Usage

整備中

## Zsh

### Installation

```
mkdir -p $HOME/.config/zsh
ln -s $HOME/dotfiles/zsh/.zshenv $HOME/.zshenv
ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.config/zsh/.zshrc
ln -s $HOME/dotfiles/zsh/config $HOME/.config/zsh/config
```

### 必要なツール

#### 必須

```bash
# Arch Linux / EndeavourOS
pacman -S zsh eza zoxide fzf bat fd ripgrep neovim btop git
```

| ツール | 説明 | エイリアス |
| ------ | ---- | ---------- |
| [eza](https://github.com/eza-community/eza) | モダンなls | `ls`, `la`, `ll`, `lt` |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | スマートcd | `cd`/`z`, `cdi`/`zi` |
| [fzf](https://github.com/junegunn/fzf) | ファジーファインダー | `fcd`, `fv`, `fgs`, `flog` |
| [bat](https://github.com/sharkdp/bat) | catの代替 | fzfプレビュー |
| [fd](https://github.com/sharkdp/fd) | findの代替 | fzf検索 |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | grepの代替 | fzf検索 |
| [neovim](https://neovim.io/) | エディタ | `v`, `vim` |
| [btop](https://github.com/aristocratos/btop) | システムモニター | `top` |

#### オプション（使用時に遅延読み込み）

```bash
# 必要に応じてインストール
pacman -S kubectl helm terraform
yay -S aws-cli-v2
```

| ツール | 説明 |
| ------ | ---- |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/) | Kubernetes CLI |
| [helm](https://helm.sh/) | Kubernetes パッケージマネージャー |
| [terraform](https://www.terraform.io/) | IaC ツール |
| [aws-cli](https://aws.amazon.com/cli/) | AWS CLI |
| [go](https://go.dev/) | Go言語 |
| [docker](https://www.docker.com/) | コンテナ |

### 主なエイリアス

| カテゴリ | エイリアス |
| -------- | ---------- |
| Git | `g`, `ga`, `gc`, `gd`, `gs`, `gsw`, `gl`, `gp`, `gpl` |
| Docker | `d`, `dc`, `dcu`, `dcd`, `dps` |
| Kubernetes | `k`, `kgp`, `kgs`, `kgd`, `kga`, `kl` |
| fzf | `fcd`(cd), `fv`(vim), `fgs`(git switch), `flog`(git log) |

## Neovim

### Installation

```
ln -s $HOME/dotfiles/nvim $XDG_CONFIG_HOME/nvim
```

### Usage

基本的な使い方は`KeymapHelp`で参照することができます。
Telescope(ファイル検索)は`TelescopeHelp`で参照することができます。
ファイルツリー上で`<Space> + h`入力でファイルツリーの操作方法を表示できます。

## Ghostty

### Installation

```
ln -s $HOME/dotfiles/ghostty $XDG_CONFIG_HOME/ghostty
```

## Rofi

### Installation

```
ln -s $HOME/dotfiles/rofi $XDG_CONFIG_HOME/rofi
```

## Dunst

### Installation

```
ln -s $HOME/dotfiles/dunst $XDG_CONFIG_HOME/dunst
```

## Picom

### Installation

```
ln -s $HOME/dotfiles/picom $XDG_CONFIG_HOME/picom
```

## Git

### Installation

```
ln -s $HOME/dotfiles/.gitconfig $HOME/.gitconfig
```

### 設定内容

[How Git core devs configure Git](https://blog.gitbutler.com/how-git-core-devs-configure-git) を参考に、Gitコア開発者が推奨する設定を適用しています。

| セクション | 設定 | 効果 |
| ---------- | ---- | ---- |
| `diff` | `algorithm = histogram` | より正確な差分アルゴリズム |
| `diff` | `colorMoved = plain` | 移動したコードを色分け表示 |
| `push` | `autoSetupRemote = true` | 上流ブランチを自動設定 |
| `fetch` | `prune = true` | 削除されたリモートブランチを自動削除 |
| `pull` | `rebase = true` | pull時にリベースを使用 |
| `commit` | `verbose = true` | コミット時にdiff全体を表示 |
| `rerere` | `enabled = true` | コンフリクト解決を記録・再利用 |
| `rebase` | `autoSquash = true` | fixup!コミットを自動スカッシュ |
| `rebase` | `autoStash = true` | リベース前に自動stash |
| `merge` | `conflictstyle = zdiff3` | コンフリクト時にマージベースも表示 |
| `branch` | `sort = -committerdate` | ブランチを最新コミット順にソート |
| `help` | `autocorrect = prompt` | コマンドのタイプミスを確認 |

## Secrets

[dotenvx](https://dotenvx.com/) を使用して暗号化されたシークレットを管理しています。

### Installation

```bash
curl -sfS "https://dotenvx.sh/install.sh?directory=$HOME/.local/bin" | sh
```

### Usage

```bash
# シークレットを追加
cd ~/dotfiles/secrets
dotenvx set API_KEY "your-api-key" -f .env.secrets

# 暗号化
dotenvx encrypt -f .env.secrets

# 環境変数として読み込んで実行
dotenvx run -f .env.secrets -- your-command

# シェルに読み込む
eval $(dotenvx get -f .env.secrets --format shell)
```

### ファイル構成

| ファイル | 説明 | Git |
| -------- | ---- | --- |
| `secrets/.env.secrets` | 暗号化済み | ✅ コミット可 |
| `secrets/.env.keys` | 秘密鍵 | ❌ コミット禁止 |

秘密鍵(`.env.keys`)は1Passwordなどのパスワードマネージャーで管理してください。

## License

[MIT]()
