import os
import sys
import yaml
import shutil
import subprocess
import argparse
from datetime import datetime


def expand_path(path):
    """Expands ~ to full user path."""
    return os.path.expanduser(path)


def run_git_push(repo_root):
    """Triggers the existing bash git_push script."""
    push_script = os.path.join(repo_root, "core", "git_push.sh")
    if os.path.exists(push_script):
        # We run this check=False so a git error doesn't crash the watcher
        subprocess.run([push_script], check=False)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--module", required=True)
    parser.add_argument("--repo-root", required=True)
    args = parser.parse_args()

    settings_path = os.path.join(args.repo_root, "settings.yaml")

    if not os.path.exists(settings_path):
        print(f"❌ Settings file not found: {settings_path}")
        sys.exit(1)

    with open(settings_path, "r") as f:
        config = yaml.safe_load(f)

    module_conf = config.get("modules", {}).get(args.module)
    defaults = config.get("defaults", {})

    if not module_conf:
        print(f"❌ Module {args.module} not found in settings.")
        sys.exit(1)

    module_dir = os.path.join(args.repo_root, "modules", args.module)
    print(
        f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] 🔄 Syncing {args.module}..."
    )

    # 1. Handle File Copying (The new standardized way)
    if "copy" in module_conf:
        for item in module_conf["copy"]:
            src = expand_path(item["src"])
            dest = os.path.join(module_dir, item["dest"])

            if os.path.exists(src):
                # Create destination directory if it doesn't exist
                os.makedirs(os.path.dirname(dest), exist_ok=True)

                # Check if it's a directory or file
                if os.path.isdir(src):
                    # Remove existing dest dir to ensure clean sync
                    if os.path.exists(dest):
                        shutil.rmtree(dest)
                    shutil.copytree(src, dest)
                else:
                    shutil.copy2(src, dest)

                print(f"   ✅ Copied: {src}")
            else:
                print(f"   ⚠️ Source not found: {src}")

    # 2. Handle Custom Scripts (Legacy/Complex way)
    if "script" in module_conf:
        script_name = module_conf["script"]
        script_path = os.path.join(module_dir, script_name)

        if os.path.exists(script_path):
            print(f"   🏃 Running script: {script_name}")

            # Determine interpreter based on extension
            if script_name.endswith(".py"):
                cmd = ["/usr/bin/python3", script_path]
            else:
                cmd = ["/bin/bash", script_path]

            # Run script inside the module directory
            subprocess.run(cmd, cwd=module_dir, check=False)
        else:
            print(f"   ❌ Script defined but not found: {script_path}")

    # 3. Git Push (Global Default)
    if defaults.get("git_push", True):
        run_git_push(args.repo_root)


if __name__ == "__main__":
    main()
