autoload -U colors && colors
setopt PROMPT_SUBST

# Function to show context (user@host) only when in SSH
prompt_context() {
  if [[ -n "$SSH_TTY" ]]; then
    echo "%F{yellow}%n@%m%f "
  fi
}

git_prompt_info() {
  local ref
  if ref=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
    echo "%F{magenta} ${ref}%f"
  fi
}

PS1='$(prompt_context)%F{blue}%~%f $(git_prompt_info) %(?.%F{green}✔.%F{red}✖)%f %B❯%b '
