log = hs.logger.new("Logger", "debug")

hs.loadSpoon("TextClipboardHistory")
spoon.TextClipboardHistory:start()
spoon.TextClipboardHistory:bindHotkeys({
  toggle_clipboard = {{"cmd", "shift"}, "h"}
})

log.i("Spoons loaded!")