import os
import subprocess
import yaml
import plistlib
import sys

# Paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(SCRIPT_DIR)
SETTINGS_PATH = os.path.join(REPO_ROOT, "settings.yaml")
AGENTS_DIR = os.path.expanduser("~/Library/LaunchAgents")
SYNC_HANDLER = os.path.join(REPO_ROOT, "core", "sync_handler.py")


def get_bundle_id(app_name):
    """Uses osascript to find the Bundle ID of an installed app."""
    try:
        cmd = f'id of app "{app_name}"'
        result = subprocess.check_output(
            ["osascript", "-e", cmd], stderr=subprocess.DEVNULL
        )
        return result.decode("utf-8").strip()
    except subprocess.CalledProcessError:
        print(f"   ⚠️ Could not resolve Bundle ID for '{app_name}'. Is it installed?")
        return None


def generate_plist_content(module_name, config, defaults):
    label = f"com.alexmiller.blueprint.{module_name}"

    # 1. Determine WatchPaths
    watch_paths = []

    # A. Explicit Paths
    if "watch" in config:
        watch_paths.extend([os.path.expanduser(p) for p in config["watch"]])

    # B. Auto-detected App Preference Paths
    if "app_name" in config:
        bundle_id = get_bundle_id(config["app_name"])
        if bundle_id:
            plist_path = os.path.expanduser(f"~/Library/Preferences/{bundle_id}.plist")
            watch_paths.append(plist_path)

    if not watch_paths and "interval" not in config:
        print(f"   ⚠️ Skipping {module_name}: No watch paths or interval found.")
        return None

    # 2. Build Plist Dictionary
    plist = {
        "Label": label,
        "ProgramArguments": [
            "/usr/bin/python3",
            SYNC_HANDLER,
            "--module",
            module_name,
            "--repo-root",
            REPO_ROOT,
        ],
        "StandardOutPath": f"/tmp/{label}.out.log",
        "StandardErrorPath": f"/tmp/{label}.err.log",
    }

    # Add WatchPaths or StartInterval
    if watch_paths:
        plist["WatchPaths"] = watch_paths
        plist["ThrottleInterval"] = config.get("throttle", defaults.get("throttle", 60))
    elif "interval" in config:
        plist["StartInterval"] = config["interval"]
        plist["RunAtLoad"] = True

    return plist


def main():
    print(f"⚙️  Reading settings from: {SETTINGS_PATH}")

    with open(SETTINGS_PATH, "r") as f:
        full_config = yaml.safe_load(f)

    modules = full_config.get("modules", {})
    defaults = full_config.get("defaults", {})

    for module, config in modules.items():
        plist_filename = f"com.alexmiller.blueprint.{module}.plist"
        dest_plist = os.path.join(AGENTS_DIR, plist_filename)

        # Unload existing (clean slate)
        if os.path.exists(dest_plist):
            subprocess.run(
                ["launchctl", "unload", dest_plist], stderr=subprocess.DEVNULL
            )

        # Skip if disabled
        if not config.get("enabled", False):
            if os.path.exists(dest_plist):
                print(f"   [-] Deactivated: {module}")
                os.remove(dest_plist)
            continue

        print(f"   [+] Configuring: {module}")

        plist_data = generate_plist_content(module, config, defaults)

        if plist_data:
            with open(dest_plist, "wb") as f:
                plistlib.dump(plist_data, f)

            # Load the new agent
            subprocess.run(["launchctl", "load", dest_plist], stderr=subprocess.DEVNULL)

    print("\n✅ Blueprint configuration updated.")


if __name__ == "__main__":
    main()
