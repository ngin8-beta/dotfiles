###################### 履歴設定 ######################
HISTFILE=${XDG_CONFIG_HOME}/.zsh_history
HISTSIZE=100000     # メモリ上の履歴の最大数
SAVEHIST=1000000    # 履歴ファイルに保存する最大数

setopt inc_append_history       # コマンド実行時に履歴ファイルに追加
setopt share_history            # シェル間で履歴をリアルタイムで共有
setopt hist_ignore_all_dups     # 重複した履歴を表示しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合、最初に重複を削除

###################### 補完設定 ######################
setopt auto_param_slash          # ディレクトリ名の補完で末尾に / を自動追加
setopt auto_param_keys           # ()を自動補完
setopt mark_dirs                 # ディレクトリにマッチした場合、末尾に / を付加
setopt auto_menu                 # 補完キー連打で順に補完候補を表示
setopt correct                   # スペルミス訂正
setopt complete_in_word          # 単語の途中でもカーソル位置で補完

###################### その他の設定 ######################
setopt interactive_comments      # コマンドラインで # 以降をコメントとして扱う
setopt magic_equal_subst         # = 以降でも補完できるようにする
setopt print_eight_bit           # 日本語ファイル名を表示可能にする
setopt auto_cd                   # ディレクトリ名だけで cd する
setopt no_beep                   # ビープ音を消す
KEYTIMEOUT=1                     # vimでescが押された後のタイムラグを防ぐ

###################### プロンプト設定 ######################
setopt prompt_subst              # プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt transient_rprompt         # 右プロンプトが一時的に消える
