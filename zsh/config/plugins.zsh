# zinitの初期化
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# zinitの自動補完機能の初期化
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

###################### プラグイン ######################
# サブコマンドの補完
zinit light zsh-users/zsh-completions
# コマンド履歴に基づいて入力補完
zinit light zsh-users/zsh-autosuggestions
# ()や""の自動補完
zinit light hlissner/zsh-autopair
# syntax-highlight
zinit light z-shell/F-Sy-H
# historyを条件検索(Ctrl-R)
zinit light zdharma-continuum/history-search-multi-word
# powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k
