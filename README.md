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

- Load the LaunchAgents to enable automatic dumps.

```bash
cd <path-to-blueprint-repo>
just load_agents
```

## Usage

### Running one off Dumps

- Run the below commands.

```bash
cd <path-to-blueprint-repo>
find ./modules -name "dump.sh" -print0 | xargs -0 -I {} sh -c 'echo "Running {}..."; bash "{}"; echo "----------------"'
```

### Enabling automatic Dumps

- First, select the modules which you like to have automatically dumped by editing the `settings.yaml` at the root of this repository and setting true for the modules you want to enable automatic dumps for and false for the ones you don't. Then, run the below commands.

```bash
cd <path-to-blueprint-repo>
./install.sh
```
