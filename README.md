# blueprint

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

- [ ] check the ~/.config directory for more stuff to save
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
