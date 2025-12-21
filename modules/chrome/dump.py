import json
import os
import subprocess
import sys
from datetime import datetime

# --- CONFIGURATION ---
CHROME_ROOT = os.path.expanduser("~/Library/Application Support/Google/Chrome")

# Backup directory structure: ./backup/{Profile Name}/
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BACKUP_ROOT = os.path.join(SCRIPT_DIR, "backup")

# --- MASTER LIST OF CHROME ACTIONS ---
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
    "kActionTaskManager": "Task Manager",
}


def load_json(path):
    if not os.path.exists(path):
        return None
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except json.JSONDecodeError:
        print(f"⚠️  Warning: Corrupt JSON at {path}")
        return None


def get_profiles():
    """Scans Chrome Root for folders that look like profiles."""
    profiles = []
    if not os.path.exists(CHROME_ROOT):
        print(f"❌ Error: Chrome directory not found at {CHROME_ROOT}")
        return []

    for item in os.listdir(CHROME_ROOT):
        # Profiles are named "Default" or "Profile X"
        if item == "Default" or item.startswith("Profile "):
            full_path = os.path.join(CHROME_ROOT, item)
            prefs = os.path.join(full_path, "Preferences")

            # Only count it if it has a Preferences file (ignoring empty/temp folders)
            if os.path.isdir(full_path) and os.path.exists(prefs):
                profiles.append((item, full_path))

    return sorted(profiles)


def process_profile(profile_name, profile_path):
    print(f"🔄 Processing: {profile_name}...")

    prefs_file = os.path.join(profile_path, "Preferences")
    secure_file = os.path.join(profile_path, "Secure Preferences")

    prefs = load_json(prefs_file)
    secure = load_json(secure_file)

    if not prefs:
        print(f"   ❌ Skipping {profile_name} (Could not read Preferences)")
        return

    # Create profile-specific backup folder
    profile_backup_dir = os.path.join(BACKUP_ROOT, profile_name)
    if not os.path.exists(profile_backup_dir):
        os.makedirs(profile_backup_dir)

    # ==========================================
    # 1. TOOLBAR & UI SETTINGS (toolbar.json)
    # ==========================================

    browser_prefs = prefs.get("browser", {})
    bookmark_prefs = prefs.get("bookmark_bar", {})

    ui_toggles = {
        "show_home_button": browser_prefs.get("show_home_button", False),
        "show_forward_button": browser_prefs.get("show_forward_button", False),
        "show_bookmarks_bar": bookmark_prefs.get("show_on_all_tabs", False),
        "show_incognito_btn": browser_prefs.get("show_incognito_button", False),
    }

    # Extract Actions
    pinned_actions_list = prefs.get("toolbar", {}).get("pinned_actions", [])

    # Sometimes pinned_actions_list can be None in unused profiles
    if pinned_actions_list is None:
        pinned_actions_list = []

    toolbar_report = []

    # Add Pinned items
    for action_id in pinned_actions_list:
        name = KNOWN_ACTIONS.get(action_id, f"Unknown Action ({action_id})")
        toolbar_report.append({"name": name, "id": action_id, "pinned": True})

    # Add Unpinned items
    for action_id, name in KNOWN_ACTIONS.items():
        if action_id not in pinned_actions_list:
            toolbar_report.append({"name": name, "id": action_id, "pinned": False})

    toolbar_data = {
        "metadata": {
            "profile": profile_name,
            "timestamp": datetime.now().isoformat(),
            "type": "toolbar_settings",
        },
        "ui_toggles": ui_toggles,
        "toolbar_actions": toolbar_report,
    }

    with open(
        os.path.join(profile_backup_dir, "toolbar.json"), "w", encoding="utf-8"
    ) as f:
        json.dump(toolbar_data, f, indent=2, ensure_ascii=False)

    # ==========================================
    # 2. EXTENSIONS (extensions.json)
    # ==========================================

    extensions_report = []

    # Some profiles (like basic ones) might not have Secure Preferences or extensions
    if secure:
        pinned_ext_ids = prefs.get("extensions", {}).get("pinned_extensions", [])
        if pinned_ext_ids is None:
            pinned_ext_ids = []

        secure_settings = secure.get("extensions", {}).get("settings", {})

        for ext_id, data in secure_settings.items():
            if isinstance(data, dict) and "manifest" in data:
                manifest = data["manifest"]
                name = manifest.get("name", "Unknown")
                is_enabled = data.get("state", 1) == 1
                is_pinned = ext_id in pinned_ext_ids

                extensions_report.append(
                    {
                        "name": name,
                        "id": ext_id,
                        "enabled": is_enabled,
                        "pinned": is_pinned,
                    }
                )

        extensions_report.sort(key=lambda x: x["name"])

    extensions_data = {
        "metadata": {
            "profile": profile_name,
            "timestamp": datetime.now().isoformat(),
            "type": "extensions_list",
        },
        "extensions": extensions_report,
    }

    with open(
        os.path.join(profile_backup_dir, "extensions.json"), "w", encoding="utf-8"
    ) as f:
        json.dump(extensions_data, f, indent=2, ensure_ascii=False)

    print(
        f"   ✅ Saved: {profile_name} (Exts: {len(extensions_report)}, Actions: {len(toolbar_report)})"
    )


def main():
    print("🔎 Scanning for Chrome Profiles...")
    profiles = get_profiles()

    if not profiles:
        print("❌ No profiles found.")
        return

    print(f"📂 Found {len(profiles)} profiles: {', '.join([p[0] for p in profiles])}")
    print(f"📂 Backups will be saved to: {BACKUP_ROOT}")
    print("---------------------------------------------------")

    for name, path in profiles:
        process_profile(name, path)

    print("---------------------------------------------------")
    print("🎉 All profiles dumped successfully.")

    print("\n🚀 Triggering auto-commit and push...")
    # The git_push.sh script is in the core directory, relative to the project root.
    # SCRIPT_DIR is the 'modules/chrome' directory.
    git_push_script = os.path.abspath(
        os.path.join(SCRIPT_DIR, "..", "..", "core", "git_push.sh")
    )

    if not os.path.exists(git_push_script):
        print(f"   ❌ Error: Git push script not found at {git_push_script}")
        return

    try:
        # Ensure the script is executable
        os.chmod(git_push_script, 0o755)

        # The script handles changing to the repo root and running git commands.
        result = subprocess.run(
            [git_push_script], check=True, capture_output=True, text=True
        )
        print("   ✅ Backup committed and pushed successfully.")
        if result.stdout.strip():
            print("   ---")
            print(result.stdout.strip())
        if result.stderr.strip():
            print("   ---")
            print(result.stderr.strip())

    except subprocess.CalledProcessError as e:
        print(f"   ❌ Git push script failed with exit code {e.returncode}.")
        if e.stdout:
            print("   --- STDOUT ---")
            print(e.stdout)
        if e.stderr:
            print("   --- STDERR ---")
            print(e.stderr)
    except Exception as e:
        print(f"   ❌ An unexpected error occurred: {e}")


if __name__ == "__main__":
    main()
