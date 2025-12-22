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
  - Click Add deploy key.
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

## TODO

- [x] check the ~/.config directory for more stuff to save
- [ ] add a tmux module
- [ ] add instructions here for how to use this project - specifically talk about how if you were to clonse this repo onto a new mac the steps you'd have to take and it one order to use all the restore scripts to restore your settings.
- [ ] figure out a way to export my gmail settings (filters, themes, hotkeys, for setting up new google accounts quickly)
- [ ] use my justfile for restoring and manually dumping certain modules (eventually turn this into a gui for myself so I don't have to manage all my sync via code)
- [ ] add the full hs config directory to this repo for hammerspoon settings
- [ ] copy my hs code form my work computer here
- [ ] Figure out how to remove the MANUAL_STEPS.md file and integrate its content into modules, remove some of it and hopefully automate some of it
- [ ] add the commands from this readme to the justfile and make them into just commands and edit the readme to agree witht he just commands
- [ ] change the name of the install.sh script to something more accurrate
- [ ] do an audit of all my modules for their usefulness
- [ ] add a section to this readme for dependecies - pretty sure all i can think of now are just and python (for the install script)
- [ ] add two sections to this readme for the biggest use cases - running dumps and restoring settings on a new mac, and setting up automatic dumps on a new mac
- [ ] add justfile runners for dumping and restoring individual modules
- [ ] either complete all these tasks for move them to the dotfiles project in notion to be completed at a later time
- [ ] abstract the file copying logic to the yaml file where all you need for a module is a list of source paths and it does the watching and dumping/restoring automatically
- [ ] add a module for tmux
- [ ] add a module for ghostty
- [ ] Design the watchers for plists to automatically get the bundle id and plist file path from the app name just like I did with the dumpers because rn it's hardcoded not sure the best way this can be dyniamcally designed though because the dumpers was easy since it's a bash script
- [ ] write the git commits to include the module name when automatic dumps happen
- [ ] Eventually consider seeing if fswatch is advanced enough so that instead of having a different watcher for each module I can have one watcher that watches all the relevant paths and figures out which module it belongs to and triggers the relevant dump script
- [ ] Codify what my menu bar looks like as it's own module (or maybe in the macos settings)
- [ ] change all my apps to be installed via brew where it's easier to manage them using brew
- [ ] create a script to delete a module which removes the modules code folder AND remoces the launchagent from `~/Library/LaunchAgents` because that gets leftover from the launctl thing - maybe I should use the unload command? Does that remove the file for launchagents?
- [ ] figure out how to unload the launchagent texts.com screenshot I put in my desktop
- [ ] modifiy the git push in the core install script to only add the relevant module folder instead of the entire repo when an automatic dump happens
- [ ] Redact my tailscale network DNS name from the config ssh module
- [ ] I really need to centralize the plist creation to be better at DRY and the file duplication / copying code for backing up certain modules
- [ ] in the settings.yaml, put the throttle intervals, filepaths to watch, and files to copy, and the path to the dumping script for each module instead of hardcoding them in the plist files
- [ ] Consider adding the `sudo xattr -d com.apple.quarantine /Applications/Visual\ Studio\ Code.app` command to the homebrew restore script for all the installations because then I won't have to click open the app even though it's downloaded from the internet
- [ ] Add a notion module with the plist file and make sure it captures this setting: Disable “Use Command Search” in Settings > Preferences to disable global hotkeys for searching Notion and asking Notion AI
- [ ] add error and stdout to the launchagent plists as follows (use the keepalive tag too just gotta figure out what it does exactly first):

```xml
   1 │ <?xml version="1.0" encoding="UTF-8"?>
   2 │ <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList
     │ -1.0.dtd">
   3 │ <plist version="1.0">
   4 │     <dict>
   5 │         <key>Label</key>
   6 │         <string>com.alexmiller.auto-sync-zshrc</string>
   7 │         <key>ServiceDescription</key>
   8 │         <string>Auto sync zsh configs to git repository</string>
   9 │         <key>ProgramArguments</key>
  10 │         <array>
  11 │             <string>zsh</string>
  12 │             <string>-c</string>
  13 │             <string>/Users/alexmiller/code/zsh-backup/sync_zshrc.sh</string>
  14 │         </array>
  15 │         <key>StandardOutPath</key>
  16 │         <string>/Users/alexmiller/code/logs/com.alexmiller.sync-zshrc.stdout</string>
  17 │         <key>StandardErrorPath</key>
  18 │         <string>/Users/alexmiller/code/logs/com.alexmiller.sync-zshrc.stderr</string>
  19 │         <key>WorkingDirectory</key>
  20 │         <string>/Users/alexmiller/code/zsh-backup</string>
  21 │         <key>KeepAlive</key>
  22 │         <true/>
  23 │      </dict>
  24 │   </plist>
```

- [ ] add this my macos module somehow? Need to run some kinda script to set all finder defaults to have larger icons, be in a list and always show and calcuate the size of folders
- [ ] Test and build out all of the restore scripts - they are mostly untested - could also standardize them the same wanna i wanna standardize the dump scripts
