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

### Configuration
|                            | Configuration                                                                         |
|----------------------------|:-------------------------------------------------------------------------------------:|
| **OS**                     | Arch Linux([EndeavourOS](https://endeavouros.com/))                                   |
| **Window manager**         | [i3](https://i3wm.org/)                                                               |
| **Shell**                  | [Zsh](https://zsh.org/)                                                               |
| **Terminal**               | [Alacritty](https://alacritty.org/)                                                   |
| **Text editor**            | [Neovim](https://neovim.io/)                                                          |
| **Input method framework** | [Fcitx5](https://github.com/fcitx/fcitx5) with [Mozc](https://www.google.co.jp/ime/)  |
| **Browser**                | [Brave](https://brave.com/ja/)                                                        |
| **File manager**           | [Thunar](https://docs.xfce.org/xfce/thunar/start)                                     |
| **Mailer**                 | [Neomutt](https://neomutt.org/)                                                       |
| **Languages**              | ja_JP                                                                                 |

## i3wm
### Instration
```
ln -s $HOME/dotfiles/i3/ $XDG_CONFIG_HOME/i3/
```
### Usage
整備中
## Zsh
### Instration
```
mkdir -p $HOME/.config/zsh
ln -s $HOME/dotfiles/zsh/.zshenv $HOME/.zshenv
ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.config/zsh/.zshrc
ln -s $HOME/dotfiles/zsh/config $HOME/.config/zsh/config
```
### Usage
整備中
## Neovim
### Instration
```
ln -s $HOME/dotfiles/nvim/ $XDG_CONFIG_HOME/nvim/
```
### Usage
基本的な使い方は`KeymapHelp`で参照することができます。
Telescope(ファイル検索)は`TelescopeHelp`で参照することができます。
ファイルツリー上で<Space> + h入力でファイルツリーの操作方法を表示できます。
## License
[MIT]()
