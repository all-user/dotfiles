eval "$(/opt/homebrew/bin/brew shellenv)"

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# ITerm2 Integration
source $HOME/.iterm2_shell_integration.zsh

# -------------------------------------
# 環境変数
# -------------------------------------

# SSHで接続した先で日本語が使えるようにする
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# エディタ
export EDITOR=/opt/homebrew/bin/vim
export VISUAL=/opt/homebrew/bin/vim


# -------------------------------------
# zshのオプション
# -------------------------------------

## 入力しているコマンド名が間違っている場合にもしかして：を出す。
setopt correct

# ビープを鳴らさない
setopt nobeep

## 色を使う
setopt prompt_subst

## ^Dでログアウトしない。
setopt ignoreeof

## バックグラウンドジョブが終了したらすぐに知らせる。
setopt notify

## 直前と同じコマンドをヒストリに追加しない
setopt hist_ignore_dups

# 補完
## タブによるファイルの順番切り替えをしない
unsetopt auto_menu

# cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt auto_pushd

# ディレクトリ名を入力するだけでcdできるようにする
setopt auto_cd

# glob で ^ と ~ を使える様にする
setopt extended_glob

# -------------------------------------
# パス
# -------------------------------------

# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    /opt/homebrew/bin(N-/)
    /opt/homebrew/sbin(N-/)
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# エイリアス
# -------------------------------------

# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける

# -------------------------------------
# その他
# -------------------------------------

# iTerm2のタブ名を変更する
function title {
    echo -ne $*
}

# prezto
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  . "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

autoload -Uz promptinit
promptinit
prompt paradox

# functions
if [ -d $HOME/.dotfiles/def ]; then
  for i in `ls $HOME/.dotfiles/def`; do
    . $HOME/.dotfiles/def/$i
  done
fi

# golang
export GOPATH=$HOME/_go
export PATH=$GOPATH/bin:$PATH

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# kubectl
# if [ $commands[kubectl] ]; then
#   source <(kubectl completion zsh)
# fi

# minikube
# eval $(minikube docker-env)

if [ -f $HOME/.zshlocal ]; then
  source $HOME/.zshlocal
fi

# ghq
export GHQ_ROOT=$HOME/_ghqroot

## 補完機能の強化
autoload -Uz compinit && compinit
