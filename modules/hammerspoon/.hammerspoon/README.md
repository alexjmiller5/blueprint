# Hammerspoon Config

## Helpful Tips

- How to find the Bundle ID of an app on macOS: replace `<path-to-your-app>` (which needs to include the .app on the app name) with the actual path to your application in the following one-liner

```applescript
osascript -e 'tell application "System Events" to get value of property list item "CFBundleIdentifier" of property list file "<path-to-your-app>/Contents/Info.plist"'
```

