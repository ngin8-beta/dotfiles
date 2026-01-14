#!/usr/bin/env zsh

# --------------------------------
# exclude directories from fzf
# --------------------------------
EXCLUDE_DIRS=(
	".git"
	".npm"
	"node_modules"
	"vendor"
)

build_rg_globs() {
	local -a globs=()
	for dir in "${EXCLUDE_DIRS[@]}"; do
		globs+=(--glob "!**/${dir}/*")
	done
	echo "${globs[@]}"
}

build_find_excludes() {
	local -a excludes=()
	for dir in "${EXCLUDE_DIRS[@]}"; do
		excludes+=(-not -path "*/${dir}/*")
	done
	echo "${excludes[@]}"
}

# --------------------------------
# fzf default command
# --------------------------------
if command -v rg >/dev/null 2>&1; then
	export FZF_DEFAULT_COMMAND="rg --files --hidden --follow $(build_rg_globs) 2>/dev/null"
else
	export FZF_DEFAULT_COMMAND="find -L . -type f $(build_find_excludes) 2>/dev/null"
fi

export FZF_DEFAULT_OPTS='--height 40% --reverse --border=sharp --margin=0,1 --color=light'

# --------------------------------
# fzf helper commands
# --------------------------------
# fcd - cd (EXCLUDE_DIRS適用)
fcd() {
	local dir
	local -a find_cmd=(find "${1:-.}" -type d)

	# 隠しディレクトリを除外
	find_cmd+=(-not -path '*/\.*')

	# EXCLUDE_DIRSを除外
	for d in "${EXCLUDE_DIRS[@]}"; do
		find_cmd+=(-not -path "*/${d}/*")
	done

	dir=$("${find_cmd[@]}" 2>/dev/null | fzf +m) || return
	cd "$dir" || return
}

# fkill - kill
fkill() {
	local pids
	pids=$(ps -ef | sed 1d | fzf --multi | awk '{print $2}')
	[ -n "$pids" ] && echo "$pids" | xargs kill -${1:-9}
}

# fv - vim (複数ファイル対応)
fv() {
	local -a files
	local -a search_cmd
	local preview_cmd

	if command -v rg >/dev/null 2>&1; then
		search_cmd=(rg --files --hidden --follow --color=never)
		for dir in "${EXCLUDE_DIRS[@]}"; do
			search_cmd+=(--glob "!**/${dir}/*")
		done
	else
		search_cmd=(find -L . -type f)
		for dir in "${EXCLUDE_DIRS[@]}"; do
			search_cmd+=(-not -path "*/${dir}/*")
		done
	fi

	if command -v bat >/dev/null 2>&1; then
		preview_cmd='bat --color=always --style=header,grid {}'
	else
		preview_cmd='cat {}'
	fi

	files=("${(@f)$("${search_cmd[@]}" 2>/dev/null | fzf --preview "$preview_cmd" --preview-window=right:60% -m)}") || return
	[ ${#files[@]} -eq 0 ] && return

	"${EDITOR:-vim}" "${files[@]}"
}

###################### git 関連 ######################
# fgs (git switch) - リモートブランチ対応
fgs() {
	local branches branch
	# -a: ローカル+リモート、--list: ローカルのみ
	branches=$(git branch -a --sort=-committerdate 2>/dev/null) || return
	[ -z "$branches" ] && {
		echo "No branches found."
		return 1
	}

	branch=$(echo "$branches" | fzf +m --preview 'git log --oneline --graph --color=always {-1} -- 2>/dev/null | head -20') || return
	branch=$(echo "$branch" | sed 's/^[* ]*//' | sed 's/remotes\/origin\///')

	git switch "$branch"
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
			fzf-tmux --multi --exit-0 --expect=ctrl-d
	); do
		q=$(head -1 <<<"$out")
		n=$(($(wc -l <<<"$out") - 1))
		addfiles=($(echo $(tail "-$n" <<<"$out")))
		[[ -z "$addfiles" ]] && continue
		if [ "$q" = ctrl-d ]; then
			git diff --color=always $addfiles | less -R
		else
			git add $addfiles
		fi
	done
}

###################### docker 関連 ######################
# fdce - dockerコンテナに入る (シェル指定可能、デフォルト: sh)
fdce() {
	local cid
	local shell="${2:-/bin/sh}"
	cid=$(docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" |
		sed 1d |
		fzf -q "$1" --preview 'docker inspect {1} | jq -C ".[0] | {Name, Image: .Config.Image, Cmd: .Config.Cmd, Ports: .NetworkSettings.Ports}"' |
		awk '{print $1}')
	[ -n "$cid" ] && docker exec -it "$cid" "$shell"
}

# fdl - dockerのログを取得
fdl() {
	local cid
	cid=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" |
		sed 1d |
		fzf -q "$1" --preview 'docker logs --tail 30 {1} 2>&1' |
		awk '{print $1}')
	[ -n "$cid" ] && docker logs -f --tail=200 "$cid"
}

# fdcre - dockerコンテナ再起動
fdcre() {
	local cid
	cid=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" |
		sed 1d |
		fzf -m -q "$1" --preview 'docker inspect {1} | jq -C ".[0] | {Name, State, Image: .Config.Image}"' |
		awk '{print $1}')
	[ -n "$cid" ] && echo $cid | xargs docker container restart
}

# fdcrm - dockerコンテナ削除
fdcrm() {
	local cid
	cid=$(docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" |
		sed 1d |
		fzf -m -q "$1" --preview 'docker inspect {1} | jq -C ".[0] | {Name, State, Image: .Config.Image}"' |
		awk '{print $1}')
	[ -n "$cid" ] && echo $cid | xargs docker container rm -f
}

# fdimgrm - dockerイメージ削除
fdimgrm() {
	local iid
	iid=$(docker image ls -a --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}" |
		sed 1d |
		fzf -m -q "$1" --preview 'docker image inspect {1} | jq -C ".[0] | {Id, RepoTags, Size, Created}"' |
		awk '{print $1}')
	[ -n "$iid" ] && echo $iid | xargs docker image rm -f
}

# fdcu - docker compose up (fuzzy検索で指定のdocker-compose.ymlを起動)
fdcu() {
	local compose_file dir
	local -a search_paths=("${1:-.}")

	# docker-compose.yml, docker-compose.yaml, compose.yml, compose.yaml を検索
	compose_file=$(find "${search_paths[@]}" -maxdepth 5 \
		\( -name "docker-compose.yml" -o -name "docker-compose.yaml" \
		   -o -name "compose.yml" -o -name "compose.yaml" \) \
		2>/dev/null |
		fzf --preview 'cat {}' \
			--header 'docker-compose.ymlを選択')

	[ -z "$compose_file" ] && return

	dir=$(dirname "$compose_file")
	echo "Starting: $compose_file"
	(cd "$dir" && docker compose up -d)
}

# fdcd - docker compose down (fuzzy検索で指定のdocker-compose.ymlを停止)
fdcd() {
	local compose_file dir
	local -a search_paths=("${1:-.}")

	compose_file=$(find "${search_paths[@]}" -maxdepth 5 \
		\( -name "docker-compose.yml" -o -name "docker-compose.yaml" \
		   -o -name "compose.yml" -o -name "compose.yaml" \) \
		2>/dev/null |
		fzf --preview 'cat {}' \
			--header 'docker-compose.ymlを選択')

	[ -z "$compose_file" ] && return

	dir=$(dirname "$compose_file")
	echo "Stopping: $compose_file"
	(cd "$dir" && docker compose down)
}