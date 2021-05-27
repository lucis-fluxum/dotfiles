# Silly Mac, see https://stackoverflow.com/a/41054093
export GPG_TTY=$(tty)

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
alias backup="~/.dotfiles/backup.sh"
alias update="~/.dotfiles/update_tools.sh"
alias ppldb="docker exec -it adhoc_co_postgres_1 psql -U postgres adhoc_co_development"
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"

# QPP Auth
auth_db_var() {
    rg "^DB_$2=(.+)\$" --color never -N -r '$1' .$1.env | tr -d '[:space:]'
}
alias devdb='PGPASSWORD="$(auth_db_var dev PASSWORD)" /usr/local/opt/postgresql@12/bin/psql -h $(auth_db_var dev HOST) -U $(auth_db_var dev USERNAME) -p $(auth_db_var dev PORT)'
alias impdb='PGPASSWORD="$(auth_db_var imp PASSWORD)" psql -h $(auth_db_var imp HOST) -U $(auth_db_var imp USERNAME) -p $(auth_db_var imp PORT)'
alias devpredb='PGPASSWORD="$(auth_db_var devpre PASSWORD)" psql -h $(auth_db_var devpre HOST) -U $(auth_db_var devpre USERNAME) -p $(auth_db_var devpre PORT)'
alias proddb='PGPASSWORD="$(auth_db_var prod PASSWORD)" psql -h $(auth_db_var prod HOST) -d $(auth_db_var prod DATABASE_NAME) -U $(auth_db_var prod USERNAME) -p $(auth_db_var prod PORT)'

setopt histignoredups
alias history="history 1"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE

export EDITOR=nvim

export PATH="/usr/local/sbin:$PATH"

# rbenv config
eval "$(/usr/local/bin/rbenv init - --path)"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

# rust config
export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH="$HOME/.rustup/toolchains/stable-$(arch)-unknown-linux-gnu/lib/rustlib/src/rust/library"

# pyenv config
eval "$(/usr/local/bin/pyenv init --path)"
eval "$(/usr/local/bin/pyenv init -)"

# nodenv config
eval "$(/usr/local/bin/nodenv init -)"

# postgres
export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

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
