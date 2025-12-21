import json
import os
import sys
import psutil  # You may need to install this: uv pip install psutil

# --- CONFIGURATION ---
PROFILE_PATH = os.path.expanduser("~/Library/Application Support/Google/Chrome/Profile 1")
PREFS_FILE = os.path.join(PROFILE_PATH, "Preferences")
INPUT_FILE = "chrome_full_state.json"

def is_chrome_running():
    """Checks if Google Chrome is currently running."""
    for proc in psutil.process_iter(['name']):
        if proc.info['name'] == 'Google Chrome':
            return True
    return False

def load_json(path):
    if not os.path.exists(path):
        print(f"❌ Error: File not found at {path}")
        sys.exit(1)
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)

def save_json(path, data):
    # Atomic write to prevent corruption
    temp_path = path + ".tmp"
    with open(temp_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, separators=(',', ':')) # Compact JSON is standard for Chrome
    os.replace(temp_path, path)

def main():
    if is_chrome_running():
        print("⚠️  WARNING: Google Chrome is running!")
        print("   Restoring settings while Chrome is open usually fails because")
        print("   Chrome will overwrite your changes when it closes.")
        user_input = input("   Please Quit Chrome (Cmd+Q) and press ENTER to continue... ")

    print(f"📂 Loading State from: {INPUT_FILE}")
    state = load_json(INPUT_FILE)
    
    print(f"📂 Reading Preferences: {PREFS_FILE}")
    prefs = load_json(PREFS_FILE)

    # 1. RESTORE UI TOGGLES
    # We update the boolean flags based on your dump
    toggles = state.get("ui_toggles", {})
    
    # Helper to safely set nested keys
    if "browser" not in prefs: prefs["browser"] = {}
    if "bookmark_bar" not in prefs: prefs["bookmark_bar"] = {}
    if "account_values" not in prefs: prefs["account_values"] = {}
    if "browser" not in prefs["account_values"]: prefs["account_values"]["browser"] = {}

    # Set Home Button
    show_home = toggles.get("show_home_button", False)
    prefs["browser"]["show_home_button"] = show_home
    prefs["account_values"]["browser"]["show_home_button"] = show_home # Sync override
    print(f"   👉 Set Home Button: {show_home}")

    # Set Forward Button
    show_fwd = toggles.get("show_forward_button", True)
    prefs["browser"]["show_forward_button"] = show_fwd
    prefs["account_values"]["browser"]["show_forward_button"] = show_fwd
    print(f"   👉 Set Forward Button: {show_fwd}")

    # Set Bookmarks Bar
    show_bookmarks = toggles.get("show_bookmarks_bar", False)
    prefs["bookmark_bar"]["show_on_all_tabs"] = show_bookmarks
    print(f"   👉 Set Bookmarks Bar: {show_bookmarks}")

    # 2. RESTORE TOOLBAR ACTIONS
    # We reconstruct the 'pinned_actions' list from your report
    toolbar_report = state.get("toolbar_actions", [])
    
    # Filter for only the items marked "pinned": true
    actions_to_pin = [item["id"] for item in toolbar_report if item.get("pinned")]
    
    # Update Local Toolbar
    if "toolbar" not in prefs: prefs["toolbar"] = {}
    prefs["toolbar"]["pinned_actions"] = actions_to_pin
    
    # Update Account Synced Toolbar (to prevent cloud overwrite)
    if "toolbar" not in prefs["account_values"]: prefs["account_values"]["toolbar"] = {}
    prefs["account_values"]["toolbar"]["pinned_actions"] = actions_to_pin
    
    print(f"   👉 Restored {len(actions_to_pin)} Pinned Actions (Translate, Downloads, etc.)")

    # 3. RESTORE PINNED EXTENSIONS
    extensions_report = state.get("extensions", [])
    pinned_exts = [ext["id"] for ext in extensions_report if ext.get("pinned")]
    
    if "extensions" not in prefs: prefs["extensions"] = {}
    prefs["extensions"]["pinned_extensions"] = pinned_exts
    print(f"   👉 Restored {len(pinned_exts)} Pinned Extensions")

    # 4. WRITE TO DISK
    save_json(PREFS_FILE, prefs)
    print("---------------------------------------------------")
    print("✅ Restore Complete.")
    print("   Open Chrome to see your restored interface.")

if __name__ == "__main__":
    main()