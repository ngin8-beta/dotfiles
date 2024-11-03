# ZSH_DIRのパスを正しく設定
ZSH_DIR="${XDG_CONFIG_HOME}/zsh"

# 補完システムの初期化
autoload -Uz compinit
compinit

# aws cli の補完
autoload bashcompinit
bashcompinit
complete -C '/usr/local/bin/aws_completer' aws

# Go 補完
# go install github.com/posener/complete/v2/gocomplete@latest
# COMP_INSTALL=1 $HOME/go/bin/gocomplete
complete -C $HOME/go/bin/gocomplete go

# zshがディレクトリで、読み取り、実行が可能なとき
if [ -d "$ZSH_DIR" ] && [ -r "$ZSH_DIR" ] && [ -x "$ZSH_DIR" ]; then
    for file in ${ZSH_DIR}/*/*.zsh; do
        # 読み取り可能ならば実行する
        if [ -r "$file" ]; then
            source "$file"
        else
            echo "Error: Cannot read $file"
        fi
    done
else
    echo "Error: ${ZSH_DIR} is not accessible."
fi
