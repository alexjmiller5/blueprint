# Manual Setup Steps

These steps I haven't figured out how to automate yet

## Restore the Modules you'd like to use

- Choose only one profile for 

## Disable SIP for `yabai` CLI

- Longer instructions on [the yabai wiki](https://github.com/asmvik/yabai/wiki/Disabling-System-Integrity-Protection)
- Reboot into recovery mode
- Open terminal from the utilities menu
- Run `csrutil enable --without fs --without debug --without nvram`
- Reboot
- Run `sudo nvram boot-args=-arm64e_preview_abi`
- Reboot
- Verify by running `csrutil status` in terminal
  - It should say `System Integrity Protection status: disabled` or `System Integrity Protection status: unknown (Custom Configuration)` if SIP is only partially disabled

## Finder

- Set the following order of the finder sidebar favorites
  - Macintosh HD
  - Applications
  - Downloads
  - Desktop
  - Documents
  - alexmiller

## Chrome PWAs

- Manually set every PWA to open supported links in Chrome instead of the PWA in the settings of each PWA

## Tab Copy

- Write down the settings for Tab Copy extension because they can't be exported (maybe take a sreenshot and put it here?)

## Hammerspoon

- Run `hs.ipc.cliInstall("/opt/homebrew")` in the Hammerspoon console to install the `hs` command line tool (assuming you installed Hammerspoon via Homebrew).