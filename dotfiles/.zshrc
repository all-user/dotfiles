# Keep only existing, unique command and function search paths.
typeset -U path fpath
path=(
  "$HOME/.local/bin"
  /opt/homebrew/bin
  /opt/homebrew/sbin
  $path
)
fpath=(${^fpath}(N-/))

# Default tools and repository location.
export EDITOR=nvim
export VISUAL=nvim
export GHQ_ROOT="$HOME/_ghqroot"

# Persist and share command history between sessions.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt auto_cd auto_pushd hist_find_no_dups hist_ignore_dups
setopt no_beep notify prompt_subst pushd_ignore_dups share_history

# Use Zsh's native completion system.
autoload -Uz compinit
compinit

# Enable vi editing, with prefix history search on Ctrl-P/Ctrl-N.
bindkey -v
KEYTIMEOUT=1
autoload -Uz history-beginning-search-backward history-beginning-search-forward
zle -N history-beginning-search-backward
zle -N history-beginning-search-forward
bindkey -M viins '^P' history-beginning-search-backward
bindkey -M viins '^N' history-beginning-search-forward

# Show the directory, Git branch/change state, and failed exit status.
autoload -Uz vcs_info
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats '%b%c%u'
precmd() {
  vcs_info
  if [[ -n "$vcs_info_msg_0_" ]]; then
    git_prompt=" %F{yellow}${vcs_info_msg_0_}%f"
  else
    git_prompt=
  fi
}
PROMPT='%(?..%F{red}%?%f )%F{cyan}%~%f${git_prompt}
%# '

# Activate the pinned tools installed by mise.
if [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# Use fzf for history, file selection, and ghq repository navigation.
if (( $+commands[fzf] )); then
  export FZF_ALT_C_COMMAND='ghq list -p'
  source <(fzf --zsh)
  bindkey -M emacs -r '\ec'
  bindkey -M viins -r '\ec'
  bindkey -M vicmd -r '\ec'
  bindkey -M viins '^]' fzf-cd-widget
fi

# Load pinned interactive plugins without a plugin manager.
plugin_dir="$HOME/.local/share/zsh/plugins"
[[ -r "$plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
  source "$plugin_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -r "$plugin_dir/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] &&
  source "$plugin_dir/zsh-history-substring-search/zsh-history-substring-search.zsh"
[[ -r "$plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source "$plugin_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
unset plugin_dir

# Search history by substring with the arrow keys in vi insert mode.
if (( $+widgets[history-substring-search-up] )); then
  for key in '^[[A' '\eOA'; do
    bindkey -M viins "$key" history-substring-search-up
  done
  for key in '^[[B' '\eOB'; do
    bindkey -M viins "$key" history-substring-search-down
  done
fi

# Load optional credentials and machine-local settings when present.
[[ -r "$HOME/.config/op/plugins.sh" ]] && source "$HOME/.config/op/plugins.sh"
[[ -r "$HOME/.zshlocal" ]] && source "$HOME/.zshlocal"
