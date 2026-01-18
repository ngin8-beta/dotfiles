###################### 遅延読み込み ######################
# 起動時間を短縮するため、重い補完は初回使用時に読み込む

# kubectl - 初回使用時に補完を読み込む
if command -v kubectl &>/dev/null; then
    kubectl() {
        unfunction kubectl
        source <(command kubectl completion zsh)
        command kubectl "$@"
    }
fi

# aws - 初回使用時に補完を読み込む
if command -v aws &>/dev/null; then
    aws() {
        unfunction aws
        if [[ -x /usr/local/bin/aws_completer ]]; then
            complete -C '/usr/local/bin/aws_completer' aws
        fi
        command aws "$@"
    }
fi

# go - 初回使用時に補完を読み込む
if command -v go &>/dev/null && [[ -x "$HOME/go/bin/gocomplete" ]]; then
    go() {
        unfunction go
        complete -C "$HOME/go/bin/gocomplete" go
        command go "$@"
    }
fi

# helm - 初回使用時に補完を読み込む
if command -v helm &>/dev/null; then
    helm() {
        unfunction helm
        source <(command helm completion zsh)
        command helm "$@"
    }
fi

# terraform - 初回使用時に補完を読み込む
if command -v terraform &>/dev/null; then
    terraform() {
        unfunction terraform
        complete -o nospace -C terraform terraform
        command terraform "$@"
    }
fi
