function set_win_title(){
  echo -ne "\033]0; $(echo $PWD) \007"
}
precmd_functions+=(set_win_title)

typeset -gaU fpath=($fpath $XDG_DATA_HOME/zsh/site-functions)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

HISTFILE=$HISTFILE
HISTSIZE=1000000
SAVEHIST=1000000

autoload -U compinit && compinit
zmodload -i zsh/complist

zstyle ":completion:*" menu select
zstyle ":completion:*" matcher-list "" "m:{a-z}={A-Z}" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"

zle -N history-substring-search-up
zle -N history-substring-search-down

unsetopt beep
setopt autocd
setopt auto_pushd
setopt correct
setopt globdots
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt notify
setopt share_history

bindkey -v
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=default,fg=magenta,underline'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=default,fg=yellow,underline'

# Shell Functions
flakify() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
}

# TODO: only works with vim with line numbers, +
ffl() {
  local search
  if [[ $# -gt 0 ]]; then
    search="$1"
  fi
  rg --color=always --line-number --no-heading --smart-case "$@" "$search" \
    | fzf -d':' --ansi \
      --preview "command bat -p --color=always {1} --highlight-line {2}" \
      --preview-window=:hidden \
      --bind="?:toggle-preview" \
    | awk -F':' '{print $1 " +" $2 }'
}

gwj() {
  local out query
  query="$1"
  match=$(git worktree list | grep "$query")
  if [[ -n "$match" ]]; then
    out=$(
      git worktree list |
      fzf --preview='git log --oneline -n10 {2}' --query "$query" -1 |
      awk '{print $1}'
    )
    cd "$out" || exit
  else
    printf "%s%s\n" "worktree does not exist: " "$query"
  fi
}

gwa() {
  local dir out query
  query="$1"
  match=$(git branch --all | grep "$query")
  if [[ -z "$match" ]]; then
    printf "%s%s\n" "branch does not exist: " "$query"
    dir=$(basename "$query")
  else
    out=$(
      git branch --all |
      fzf --preview='git log --oneline -n10 {2}' --query "$query" -1 |
      awk '{print $nf}'
    )
    dir=$(basename "$out")
  fi
  git worktree add "$dir"
  cd "$dir"
}

tmk() {
  local out query
  query="$1"
  out=$(
    tmux list-sessions -f "#s (#{session_windows} windows)" |
    fzf --query "$query" -1 |
    awk '{print $1}'
  )
  tmux kill-session -t "$out" || exit
}

zt() {
  local query zettel
  query="$1"
  cd "$zettelkasten_dir"
  zettel=$(fd . | fzf --query "$query" -1)
  if [[ -n "$zettel" ]] && [[ "$zettel" == *"journal/20"* ]]; then
    "$editor" "$zettel" -u ./journal/.nvimrc
  elif [[ -n "$zettel" ]]; then
    "$editor" "$zettel"
  fi
  cd - &> /dev/null
}

td() {
  cd "$journal_dir"
  month="$(date '+%y/%m/')"
  today="$(date '+%y/%m/%d')"
  mkdir -p "$month"
  "$editor" "$today"
}

# Aliases
alias ca='$XDG_CACHE_HOME'
alias cat='bat'
alias cf='$XDG_CONFIG_HOME'
alias cp='cp -i'
alias dc='$XDG_DOCUMENTS_DIR'
alias dl='$XDG_DOWNLOAD_DIR'
alias dot='$DOTFILES_DIR'
alias e='$EDITOR'
alias e.='$EDITOR .'
alias erg='$EDITOR $(ffl)'
alias eza='eza '
alias fd='fd -H'
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gc='git commit -v'
alias gca='git commit --amend'
alias gcb='git checkout -b'
alias gcl='git clone'
alias gcm='git commit -m'
alias gco='git switch'
alias gd='git diff'
alias gf='git fetch'
alias glg='git log --stat'
alias gm='git merge'
alias gmv='git mv'
alias gob='go build -v'
alias gof='gofmt -d -s -w .'
alias gog='go generate ./...'
alias gpl='git pull'
alias gps='git push'
alias grb='git rebase'
alias grep='grep -i --color=auto --exclude-dir={.git,node_modules}'
alias grm='git rm'
alias grs='git restore --staged .'
alias gsh='git secret hide'
alias gsr='git secret reveal -f'
alias gst='git status --short --branch'
alias gsw='git show'
alias gw='git worktree'
alias gwc='worktree-clone'
alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove'
# alias journal='$JOURNAL_DIR'
alias la='eza -T -L=3 --group-directories-first'
alias lc='$HOME/.local/'
alias lcb='$HOME/.local/bin/'
alias lcs='$XDG_DATA_HOME'
alias ls='eza -1ar -s=Name --group-directories-first --git --icons=auto'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias ninja="nix run github:b3nj5m1n/xdg-ninja"
alias pro='$PROJECTS_DIR'
alias rails='bin/rails'
alias src='$SOURCES_DIR'
# alias tms='tmux-sessioniser'
alias v='nvim'
alias v.='nvim .'
alias wezterm='flatpak run org.wezfurlong.wezterm'
alias work='$WORK_DIR'

export GPG_TTY="$(tty)"
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
gpgconf --launch gpg-agent

if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

[[ ! -r '/home/richard/.opam/opam-init/init.zsh' ]] || source '/home/richard/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"
