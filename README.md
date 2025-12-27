# blueprint

## Setup

- Create a GitHub deploy key for the launchagents set to read/write for this repository and add it to your GitHub account.

```bash
ssh-keygen -t ed25519 -f ~/.ssh/blueprint_deploy_key -C "blueprint-automation" -N ""
cat ~/.ssh/blueprint_deploy_key.pub | pbcopy
```

- Add the copied public key to your GitHub account
  - Go to your Blueprint Repository on GitHub.
  - Navigate to Settings > Deploy keys.
  - Click Add deploy kney.
  - Title: Mac Automation (Push)
  - Key: Paste the key you just copied.
  - IMPORTANT: Check the box ☑️ Allow write access. (Without this, it can only pull, not push).
  - Click Add key.

## Helpful commands

- Unload all launch agents with a specific keyword in the name

```bash
launchctl list | grep "<keyword>" | awk '{print $3}' | xargs -I {} launchctl remove {}
```

- List all non-Apple launch agents

```bash
launchctl list | grep -v "com.apple"
```

## Installation

### Homebrew

```bash
brew install blueprint
```

### From Source

- TODO: Instructions for installing from source

## Usage

`blueprint [MODULES] [FLAGS]`

| Flag | Description |
| :--- | :--- |
| `--dump` | **Backup**: Syncs System → Repo. |
| `--restore` | **Restore**: Syncs Repo → System. (Overwrites local files!) |
| `--load-agents` | **Automate**: Generates & loads LaunchAgents for background watching. |
| `--all` | Targets all enabled modules in `settings.yaml`. |
| `--no-git` | Skips the auto-git push step (useful for testing). |

### Examples

1. Manual Backup (All Modules)

```bash
blueprint --all --dump
```

2. Restore Specific Configs (e.g., on a new machine)

```Bash
blueprint zsh vscode karabiner --restore
```

1. Reload Automation Agents Updates ~/Library/LaunchAgents based on settings.yaml and cleans up stale agents.

```Bash
blueprint --all --load-agents
```

4. Dump Single App w/o Git Push

```Bash
blueprint raycast --dump --no-git
```

- Configuration ( settings.yaml )
Define modules in blueprint/settings.yaml.

```YAML
modules:
  zsh:
    enabled: true
    # 1. Watch: Paths that trigger an auto-backup when modified
    watch:
      - "~/.zshrc"
    # 2. Copy: Explicit file/folder sync (Recursive rsync for dirs)
    copy:
      - { src: "~/.zshrc", dest: "backup/.zshrc" }

  dock:
    enabled: true
    # 3. App Name: Auto-resolves Bundle ID & exports "safe" XML plist
    app_name: "Dock"

  scripts:
    enabled: true
    # 4. Script: Runs a custom script (path relative to repo root)
    script: "scripts/dump_custom.sh"
```
