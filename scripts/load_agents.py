import os
import subprocess
import yaml

# Go up one level from this script to find the repo root
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(SCRIPT_DIR)

AGENTS_DIR = os.path.expanduser("~/Library/LaunchAgents")
SETTINGS_PATH = os.path.join(REPO_ROOT, "settings.yaml")

def run_launchctl(command, plist_path):
    subprocess.run(
        ["launchctl", command, plist_path], 
        stderr=subprocess.DEVNULL, 
        stdout=subprocess.DEVNULL
    )

with open(SETTINGS_PATH, "r") as f:
    config = yaml.safe_load(f)

for module, enabled in config.get("modules", {}).items():
    # Plists are expected at repo_root/modules/<module>/...
    src_plist = os.path.join(REPO_ROOT, "modules", module, f"com.alexmiller.blueprint.{module}.plist")
    dest_plist = os.path.join(AGENTS_DIR, f"com.alexmiller.blueprint.{module}.plist")

    if enabled:
        if os.path.exists(src_plist):
            print(f"  [+] Activating: {module}")
            
            with open(src_plist, "r") as template:
                content = template.read()
            
            # Replace placeholder with the calculated repo root
            content = content.replace("{{ROOT}}", REPO_ROOT)
            
            with open(dest_plist, "w") as dest:
                dest.write(content)
            
            run_launchctl("unload", dest_plist)
            run_launchctl("load", dest_plist)
        else:
            print(f"  [!] Missing plist for: {module}")
            
    else:
        if os.path.exists(dest_plist):
            print(f"  [-] Deactivating: {module}")
            run_launchctl("unload", dest_plist)
            os.remove(dest_plist)

print("✅ Blueprint configuration updated.")