###################### ファイル操作 ######################
# ls -> eza (exa's maintained fork)
alias ls='eza --color=auto --icons --sort=Name'
alias la='eza -la --icons --sort=Name'
alias ll='eza -l --icons --sort=Name'
alias lt='eza --tree --level=2 --icons --sort=Name'

# 実行前確認
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# mkdir with parents
alias mkdir='mkdir -pv'

###################### エディタ ######################
alias v='nvim'
alias vim='nvim'

###################### システム ######################
# top -> btop
alias top='btop'

# clear
alias c='clear'

# disk usage
alias df='df -h'
alias du='du -h'
alias dud='du -d 1'

# grep
alias grep='grep --color=auto'

###################### ネットワーク ######################
alias ports='ss -tulanp'               # 開いているポートと使用中のプロセスを表示
alias myip='curl -s http://ipinfo.io/ip'  # 自分のグローバルIP
alias localip="ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1"

###################### Git ######################
alias g='git'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gsw='git switch'

###################### Docker ######################
alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpsa='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'

###################### Kubernetes ######################
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kga='kubectl get all'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias klf='kubectl logs -f'

###################### zoxide (smarter cd) ######################
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'      # cdをzに置き換え
    alias cdi='zi'    # インタラクティブモード
fi
