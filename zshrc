# Silly Mac, see https://stackoverflow.com/a/41054093
GPG_TTY=$(tty)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# User specific aliases and functions
alias rm="rm -v"
alias vim=nvim
alias gits="git submodule"
alias ls="exa --git --group-directories-first -lgh"

EDITOR=nvim

# rbenv config
eval "$(/usr/local/bin/rbenv init -)"

# rust config
PATH="$HOME/.cargo/bin:$PATH"
RUST_SRC_PATH="$HOME/.rustup/toolchains/stable-$(arch)-unknown-linux-gnu/lib/rustlib/src/rust/library"

# pyenv config
eval "$(/usr/local/bin/pyenv init -)"

# nodenv config
eval "$(/usr/local/bin/nodenv init -)"

# yarn config
PATH="$HOME/.yarn/bin:$PATH"

export EDITOR PATH RUST_SRC_PATH GPG_TTY

# Load Homebrew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Load powerlevel10k theme. To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autojump config
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
