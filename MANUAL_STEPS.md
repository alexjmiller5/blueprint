# Manual Setup Steps

These steps I haven't figured out how to automate yet

## Disable SIP for `yabai` CLI

- Reboot into recovery mode
- Open terminal from the utilities menu
- Run `csrutil enable --without fs --without debug --without nvram`
- Reboot
- Run `sudo nvram boot-args=-arm64e_preview_abi`
- Reboot
- Verify by running `csrutil status` in terminal
  - It should say "System Integrity Protection status: disabled (Custom Configuration),"

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
