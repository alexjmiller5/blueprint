# zsh config location
export ZSH_CONFIG="$HOME/.config/zsh"

# Set history file to zsh config directory
export HISTFILE="$ZSH_CONFIG/.zsh_history"

# Load my PS1 variable
source $ZSH_CONFIG/zsh_prompt.zsh

# Aliases
source $ZSH_CONFIG/aliases.zsh

# Functions
source $ZSH_CONFIG/functions.zsh

# Load profile
if [[ -f "$ZSH_CONFIG/profile.zsh" ]]; then
    source "$ZSH_CONFIG/profile.zsh"
fi

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# MySQL
export PATH=${PATH}:/usr/local/mysql/bin

# Add Docker Desktop for Mac (docker)
export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"

# Deno
export DENO_INSTALL="/Users/alexmiller/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Node
export PATH="/usr/local/opt/node@20/bin:$PATH"
export NODE_EXTRA_CA_CERTS=~/ca-certificates.crt

# Enable auotcomplete for more git, docker, and more than just basic terminal commands
autoload -Uz compinit
compinit -d "$ZSH_CONFIG/.zcompdump"

# Set 1Password as my default ssh authenticator
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
