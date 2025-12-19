test 1

# Load my PS1 variable
source ~/.zsh_prompt

# Aliases
source ~/.aliases

# Functions
source ~/.functions

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
autoload -Uz compinit && compinit

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/alexmiller/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/alexmiller/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/alexmiller/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/alexmiller/google-cloud-sdk/completion.zsh.inc'; fi

# Set 1Password as my default ssh authenticator
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

# Export cherri-secrets to path
export PATH="/Users/alexmiller/Desktop/personal-software-projects/sandbox/ios-shortcuts/scripts:$PATH"
