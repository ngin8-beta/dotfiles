export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!**/.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border=sharp --margin=0,1 --color=light'

###################### 便利コマンド ######################
# fd - cd
fcd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fkill - kill
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
  fi
}

# fv - nvim
fv() {
  local file
  file=$(
         rg --files --hidden --follow --glob "!**/.git/*" | fzf \
             --preview 'bat  --color=always --style=header,grid {}' --preview-window=right:60%
     )
  nvim "$file"
}

###################### git 関連 ######################
# fgs (git switch)
fgs() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git switch $(echo "$branch" | sed "s/.* //" )
}

# flog (git log)
flog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(#C0C0C0)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
              (grep -o '[a-f0-9]\{7\}' | head -1 |
              xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
              {}
              FZF-EOF
             "
}

# fadd (git add/diff) Ctrl-d: diff Enter: add
fadd() {
  local out q n addfiles
  while out=$(
      git status --short |
      awk '{if (substr($0,2,1) !~ / /) print $2}' |
      fzf-tmux --multi --exit-0 --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    n=$[$(wc -l <<< "$out") - 1]
    addfiles=(`echo $(tail "-$n" <<< "$out")`)
    [[ -z "$addfiles" ]] && continue
    if [ "$q" = ctrl-d ]; then
      git diff --color=always $addfiles | less -R
    else
      git add $addfiles
    fi
  done
}

###################### docker 関連 ######################
# fdce - dockerコンテナに入る
fdce() {
  local cid
  cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && docker exec -it "$cid" /bin/bash
}

# fdl - dockerのログを取得
fdl() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && docker logs -f --tail=200 "$cid"
}

# fdcre - dockerコンテナ再起動
fdcre() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -m -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && echo $cid | xargs docker container restart
}

# fdcrm - dockerコンテナ削除
fdcrm() {
  local cid
  cid=$(docker ps -a | sed 1d | fzf -m -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && echo $cid | xargs docker container rm -f
}

# fdimgrm - dockerイメージ削除
fdimgrm() {
  local cid
  cid=$(docker image ls -a | sed 1d | fzf -m -q "$1" | awk '{print $1}')
  [ -n "$cid" ] && echo $cid | xargs docker image rm -f
}
