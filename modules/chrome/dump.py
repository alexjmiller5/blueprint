import json
import os
import sys
from datetime import datetime

# --- CONFIGURATION ---
# We use Profile 1 as verified by your logs
PROFILE_PATH = os.path.expanduser("~/Library/Application Support/Google/Chrome/Profile 1")
PREFS_FILE = os.path.join(PROFILE_PATH, "Preferences")
SECURE_FILE = os.path.join(PROFILE_PATH, "Secure Preferences")
OUTPUT_FILE = "chrome_full_state.json"

# --- MASTER LIST OF CHROME ACTIONS ---
# These are the internal IDs for the buttons shown in your "Customize Chrome" screenshot.
# We use this to report "False" for items you don't have pinned.
KNOWN_ACTIONS = {
    "kActionTabSearch": "Tab Search",
    "kActionPrint": "Print",
    "kActionShowTranslate": "Translate",
    "kActionSendTabToSelf": "Send to your devices",
    "kActionQrCodeGenerator": "Create QR Code",
    "media_router_action": "Cast",
    "kActionSidePanelShowReadingList": "Reading List",
    "kActionSidePanelShowBookmarks": "Bookmarks (Side Panel)",
    "kActionSidePanelShowHistory": "History (Side Panel)",
    "kActionShowDownloads": "Downloads",
    "kActionDevTools": "Developer Tools",
    "kActionShowChromeLabs": "Chrome Labs",
    "kActionCopyLink": "Copy Link",
    "kActionSidePanelShowReadAnything": "Reading Mode",
    "kActionTaskManager": "Task Manager"
}

def load_json(path):
    if not os.path.exists(path):
        print(f"❌ Error: File not found at {path}")
        sys.exit(1)
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def main():
    print(f"📂 Reading Profile 1...")
    prefs = load_json(PREFS_FILE)
    secure = load_json(SECURE_FILE)

    # 1. EXTRACT UI TOGGLES (Booleans)
    # Using the paths verified in your scan
    # Note: .get() defaults to False if the setting is missing (which usually means Off/Default)
    browser_prefs = prefs.get("browser", {})
    bookmark_prefs = prefs.get("bookmark_bar", {})
    
    # "Show Home" wasn't in your scan, which implies it's False/Default. 
    # We grab it safely anyway.
    ui_toggles = {
        "show_home_button": browser_prefs.get("show_home_button", False),
        "show_forward_button": browser_prefs.get("show_forward_button", False),
        "show_bookmarks_bar": bookmark_prefs.get("show_on_all_tabs", False),
        "show_incognito_btn": browser_prefs.get("show_incognito_button", False) # Often implicit
    }

    # 2. EXTRACT TOOLBAR ACTIONS (The "Customize Chrome" List)
    # Your scan confirmed this lives at 'toolbar.pinned_actions'
    pinned_actions_list = prefs.get("toolbar", {}).get("pinned_actions", [])
    
    # We build a complete report of ON vs OFF
    toolbar_report = []
    
    # First, add everything currently pinned (preserving your order)
    for action_id in pinned_actions_list:
        name = KNOWN_ACTIONS.get(action_id, f"Unknown Action ({action_id})")
        toolbar_report.append({
            "name": name,
            "id": action_id,
            "pinned": True
        })
        
    # Second, check the Master List for anything MISSING (Unpinned/Off)
    for action_id, name in KNOWN_ACTIONS.items():
        if action_id not in pinned_actions_list:
            toolbar_report.append({
                "name": name,
                "id": action_id,
                "pinned": False
            })

    # 3. EXTRACT EXTENSIONS
    pinned_ext_ids = prefs.get("extensions", {}).get("pinned_extensions", [])
    secure_settings = secure.get("extensions", {}).get("settings", {})
    
    extensions_report = []
    for ext_id, data in secure_settings.items():
        # Safety check: ensure it's a dict and has a manifest
        if isinstance(data, dict) and "manifest" in data:
            manifest = data["manifest"]
            name = manifest.get("name", "Unknown")
            
            # Chrome State: 1 = Enabled, 0 = Disabled
            is_enabled = data.get("state", 1) == 1
            is_pinned = ext_id in pinned_ext_ids
            
            extensions_report.append({
                "name": name,
                "id": ext_id,
                "enabled": is_enabled,
                "pinned": is_pinned
            })
    
    extensions_report.sort(key=lambda x: x["name"])

    # 4. BUILD FINAL JSON
    full_state = {
        "metadata": {
            "profile": "Profile 1",
            "timestamp": datetime.now().isoformat()
        },
        "ui_toggles": ui_toggles,
        "toolbar_actions": toolbar_report,
        "extensions": extensions_report
    }

    # Save to disk
    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(full_state, f, indent=2)

    print(f"✅ Dump Complete: {OUTPUT_FILE}")
    print("---------------------------------------------------")
    print(f"🎚  UI Toggles Captured:  {len(ui_toggles)}")
    print(f"📌 Pinned Items Found:   {len(pinned_actions_list)}")
    print(f"⚪ Unpinned Items Found: {len(toolbar_report) - len(pinned_actions_list)}")
    print(f"🧩 Extensions Processed: {len(extensions_report)}")

if __name__ == "__main__":
    main()