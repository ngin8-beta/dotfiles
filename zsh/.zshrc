# ZSH_DIRのパスを正しく設定
ZSH_DIR="${XDG_CONFIG_HOME}/zsh"

# 補完システムの初期化
autoload -Uz compinit
compinit

# bashcompinit (aws等のbash補完を使うため)
autoload -Uz bashcompinit
bashcompinit

# config/*.zsh を読み込む
if [[ -d "$ZSH_DIR" && -r "$ZSH_DIR" && -x "$ZSH_DIR" ]]; then
    for file in ${ZSH_DIR}/config/*.zsh; do
        [[ -r "$file" ]] && source "$file"
    done
fi

# uv (Python package manager)
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"
