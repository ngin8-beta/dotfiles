# ==================================================
# パスの拡張設定
# ==================================================
export PATH="/usr/local/bin:$HOME/.local/bin:$PATH"
# zshの設定ファイルのパスを設定
export ZDOTDIR=${HOME}/.config/zsh

# ==================================================
# XDGベースディレクトリ設定
# ==================================================
# データファイルの保存場所を定義
export XDG_DATA_HOME=$HOME/.local/share/
# 設定ファイルの保存場所を定義
export XDG_CONFIG_HOME=$HOME/.config/
# 状態ファイルの保存場所を定義
export XDG_STATE_HOME=$HOME/.local/state/
# キャッシュデータの保存場所を定義
export XDG_CACHE_HOME=$HOME/.cache/

# ==================================================
# ビルドパフォーマンスの最適化
# ==================================================
# マルチコアプロセッサを活用してビルド速度を向上させる
export MAKEFLAGS="-j$(nproc)"
# コンパイラのキャッシュを利用して再コンパイルを高速化
export CCACHE_DIR=$HOME/.ccache
export PATH="/usr/lib/ccache:$PATH"

# ==================================================
# ネットワーク設定
# ==================================================
## プロキシサーバーを通じてインターネットに接続する場合の設定
#export HTTP_PROXY="http://your-proxy-address:port"
#export HTTPS_PROXY="http://your-proxy-address:port"
#export NO_PROXY="localhost,127.0.0.1,localaddress,.localdomain.com"

# ==================================================
# 地域設定と文字コード
# ==================================================
# システムのロケールを日本語に設定
export LANG=ja_JP.UTF-8
# コマンドラインツールでの文字表示をUTF-8に設定
export LESSCHARSET=utf-8

# ==================================================
# セキュリティ設定
# ==================================================
# SSHクライアントの設定ファイルの場所を指定
export SSH_CONFIG=$HOME/.ssh/config
# GPGの秘密鍵や公開鍵が格納されているディレクトリを指定
export GNUPGHOME=$HOME/.gnupg

# ==================================================
# 開発ツールのパス設定
# ==================================================
# Go言語の実行可能ファイルのディレクトリをPATHに追加
export PATH=$PATH:$GOPATH/bin
## Node.jsのグローバルパッケージの場所を指定
#export NODE_PATH=$HOME/.node_modules_global/lib/node_modules
## Pythonの仮想環境のデフォルト保存場所を設定
#export WORKON_HOME=$HOME/.virtualenvs

# ==================================================
# Go言語開発環境の設定
# ==================================================
# Go言語のワークスペースパスを設定
export GOPATH=$(go env GOPATH)
# Goのプロジェクトファイルのルートディレクトリを設定
export GHQ_ROOT=$GOPATH/pkg/mod
