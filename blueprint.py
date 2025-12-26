import os
import sys
import yaml
import shutil
import argparse
import subprocess
import plistlib
import tempfile
from datetime import datetime

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.dirname(SCRIPT_DIR)
SETTINGS_PATH = os.path.join(SCRIPT_DIR, "settings.yaml")
AGENTS_DIR = os.path.expanduser("~/Library/LaunchAgents")
SSH_KEY_PATH = os.path.expanduser("~/.ssh/blueprint_deploy_key")


def run_cmd(cmd, cwd=None, ignore_error=False, capture_output=False):
    """Generic wrapper for subprocess to keep main logic clean."""
    try:
        result = subprocess.run(
            cmd,
            cwd=cwd,
            check=not ignore_error,
            stdout=subprocess.PIPE if capture_output else None,
            stderr=subprocess.PIPE if capture_output else None,
            text=True,
        )
        return result.stdout.strip() if capture_output and result.stdout else None
    except subprocess.CalledProcessError as e:
        if not ignore_error:
            print(f"❌ Command failed: {' '.join(cmd)}")
            if e.stderr:
                print(f"   Error: {e.stderr.strip()}")
        return None


def git_push():
    """Handles the git add/commit/push logic."""
    print("🐙 Checking for Git changes...")

    status = run_cmd(
        ["git", "status", "--porcelain"],
        cwd=REPO_ROOT,
        capture_output=True,
        ignore_error=True,
    )
    if not status:
        print("   No changes to push.")
        return

    print("   Changes detected. Committing...")
    run_cmd(["git", "add", "."], cwd=REPO_ROOT)

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    commit_msg = f"Auto-backup: {timestamp}"

    run_cmd([
        "/usr/bin/env",
        "GIT_AUTHOR_NAME=Blueprint Bot",
        "GIT_AUTHOR_EMAIL=bot@blueprint.local",
        "GIT_COMMITTER_NAME=Blueprint Bot",
        "GIT_COMMITTER_EMAIL=bot@blueprint.local",
        "git",
        "-c", "commit.gpgsign=false",
        "commit",
        "-m", commit_msg
    ], cwd=REPO_ROOT)

    ssh_cmd = f"ssh -i {SSH_KEY_PATH} -o IdentitiesOnly=yes"
    print("   Pushing to origin...")
    run_cmd(
        ["git", "-c", f"core.sshCommand={ssh_cmd}", "push", "origin", "main"],
        cwd=REPO_ROOT,
    )
    print("✅ Git push successful.")


def get_bundle_id(app_name):
    """Uses osascript to find Bundle ID. (Best way on macOS)"""
    cmd = ["osascript", "-e", f'id of app "{app_name}"']
    return run_cmd(cmd, capture_output=True, ignore_error=True)


def sync_path(src, dest, is_directory):
    """
    Copies src to dest.
    - Dirs: Uses rsync (for delta syncing and mirroring).
    - Files: Uses shutil (native Python).
    """
    src = os.path.expanduser(src)
    dest = os.path.expanduser(dest)

    if not os.path.exists(src):
        print(f"   ⚠️ Source not found: {src}")
        return

    os.makedirs(os.path.dirname(dest), exist_ok=True)

    if is_directory:
        # Use rsync for directories (Performance + Mirroring)
        # Adding trailing slash to src ensures content copy, not folder-inside-folder
        src_clean = src.rstrip("/") + "/"
        cmd = ["rsync", "-av", "--delete", src_clean, dest]

        # We suppress output unless there's an error to keep CLI clean
        res = subprocess.run(
            cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
        )
        if res.returncode == 0:
            print(f"   📂 Synced Dir: {src} -> {dest}")
        else:
            print(f"   ❌ rsync failed: {res.stderr}")
    else:
        # Use native Python for files
        try:
            shutil.copy2(src, dest)
            print(f"   📄 Synced File: {src} -> {dest}")
        except Exception as e:
            print(f"   ❌ Copy failed: {e}")


def handle_plist(app_name, repo_path, direction):
    """
    Handles Plist Dump/Restore using native plistlib for converting format.
    """

    bundle_id = get_bundle_id(app_name)

    if not bundle_id:
        print(f"   ⚠️ Could not resolve Bundle ID for '{app_name}'")
        return

    plist_filename = f"{bundle_id}.plist"
    repo_file = os.path.join(repo_path, plist_filename)

    if direction == "dump":
        # System -> Repo
        # We export to a temp file, then load/clean with plistlib, then save to repo
        with tempfile.NamedTemporaryFile(delete=False) as tmp:
            temp_path = tmp.name

        # 'defaults export' is reliable for getting current system state
        run_cmd(["defaults", "export", bundle_id, temp_path], ignore_error=True)

        if os.path.getsize(temp_path) > 0:
            try:
                # Load (handles binary or XML)
                with open(temp_path, "rb") as f:
                    data = plistlib.load(f)

                # Dump to Repo (Always XML for readability)
                with open(repo_file, "wb") as f:
                    plistlib.dump(data, f)

                print(f"   ⚙️  Dumped Plist: {app_name} -> {repo_file}")
            except Exception as e:
                print(f"   ❌ Plist parsing failed for {app_name}: {e}")
            finally:
                os.remove(temp_path)
        else:
            print(f"   ⚠️ Defaults export empty for {bundle_id}")

    elif direction == "restore":
        # Repo -> System
        if not os.path.exists(repo_file):
            print(f"   ⚠️ Backup not found: {repo_file}")
            return

        print(f"   ♻️  Restoring {app_name}...")

        if app_name not in ["Finder", "Dock"]:
            run_cmd(["killall", app_name], ignore_error=True)

        # 'defaults import' is safer than writing files directly because of cfprefsd
        run_cmd(["defaults", "import", bundle_id, repo_file])
        run_cmd(["killall", "cfprefsd"], ignore_error=True)

        if app_name == "Dock":
            run_cmd(["killall", "Dock"])
        elif app_name == "Finder":
            run_cmd(["killall", "Finder"])
        else:
            run_cmd(["open", "-a", app_name], ignore_error=True)


def process_modules(modules, config, mode):
    print(f"\n🚀 Starting {mode.upper()} process...\n")

    for module_name in modules:
        mod_conf = config["modules"].get(module_name)
        if not mod_conf:
            continue
        if not mod_conf.get("enabled", True):
            continue

        print(f"[{module_name}]")

        # 1. Standard Files/Dirs
        if "copy" in mod_conf:
            for item in mod_conf["copy"]:
                sys_path = os.path.expanduser(item["src"])
                # We assume 'dest' in yaml is relative to repo root
                repo_path = os.path.join(REPO_ROOT, item["dest"])

                is_dir = (
                    os.path.isdir(sys_path)
                    if os.path.exists(sys_path)
                    else (not os.path.splitext(sys_path)[1])
                )

                if mode == "dump":
                    sync_path(sys_path, repo_path, is_dir)
                elif mode == "restore":
                    sync_path(repo_path, sys_path, is_dir)

        # 2. Plists
        if "app_name" in mod_conf:
            plist_repo_dir = os.path.join(REPO_ROOT, "backup", "plists")
            os.makedirs(plist_repo_dir, exist_ok=True)
            handle_plist(mod_conf["app_name"], plist_repo_dir, mode)

        # 3. Custom Scripts
        script_key = "restore_script" if mode == "restore" else "script"
        if script_key in mod_conf:
            script_name = mod_conf[script_key]
            script_path = os.path.join(REPO_ROOT, "scripts", script_name)

            if os.path.exists(script_path):
                print(f"   🏃 Running {script_key}: {script_name}")
                interpreter = (
                    "/usr/bin/python3" if script_name.endswith(".py") else "/bin/bash"
                )
                subprocess.run([interpreter, script_path], cwd=REPO_ROOT, check=False)


def generate_agents(modules, config, defaults):
    """
    1. Generates/Updates agents for the targeted 'modules'.
    2. Scans LaunchAgents folder and removes ANY 'blueprint' agent
       that is no longer valid (deleted from yaml, disabled, or empty).
    """
    print("\n⚙️  Configuring Launch Agents...")

    for module_name in modules:
        mod_conf = config["modules"].get(module_name)

        if not mod_conf or not mod_conf.get("enabled", True):
            continue

        watch_paths = []
        if "watch" in mod_conf:
            watch_paths.extend([os.path.expanduser(p) for p in mod_conf["watch"]])

        if "app_name" in mod_conf:
            bid = get_bundle_id(mod_conf["app_name"])
            if bid:
                watch_paths.append(
                    os.path.expanduser(f"~/Library/Preferences/{bid}.plist")
                )

        if not watch_paths and "interval" not in mod_conf:
            continue

        label = f"com.alexmiller.blueprint.{module_name}"
        plist_path = os.path.join(AGENTS_DIR, f"{label}.plist")

        plist_content = {
            "Label": label,
            "ProgramArguments": [
                "/usr/bin/python3",
                os.path.abspath(__file__),
                "--dump",
                module_name,
            ],
            "StandardOutPath": f"/tmp/{label}.out.log",
            "StandardErrorPath": f"/tmp/{label}.err.log",
        }

        if watch_paths:
            plist_content["WatchPaths"] = watch_paths
            plist_content["ThrottleInterval"] = mod_conf.get(
                "throttle", defaults.get("throttle", 30)
            )
        elif "interval" in mod_conf:
            plist_content["StartInterval"] = mod_conf["interval"]

        if os.path.exists(plist_path):
            run_cmd(["launchctl", "unload", plist_path], ignore_error=True)

        with open(plist_path, "wb") as f:
            plistlib.dump(plist_content, f)

        run_cmd(["launchctl", "load", plist_path], ignore_error=True)
        print(f"   [+] Loaded Agent: {module_name}")

    print("   🧹 Checking for stale agents...")
    prefix = "com.alexmiller.blueprint."

    installed_agents = [
        f
        for f in os.listdir(AGENTS_DIR)
        if f.startswith(prefix) and f.endswith(".plist")
    ]

    for filename in installed_agents:
        curr_name = filename[len(prefix) : -6]

        should_exist = False

        if curr_name in config["modules"]:
            mod_conf = config["modules"][curr_name]

            is_enabled = mod_conf.get("enabled", True)
            has_trigger = (
                "watch" in mod_conf or "interval" in mod_conf or "app_name" in mod_conf
            )

            if is_enabled and has_trigger:
                should_exist = True

        if not should_exist:
            plist_path = os.path.join(AGENTS_DIR, filename)
            print(f"   [-] Removing stale agent: {curr_name}")
            run_cmd(["launchctl", "unload", plist_path], ignore_error=True)
            os.remove(plist_path)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("modules", nargs="*", help="Specific modules")
    parser.add_argument("--all", action="store_true", help="All modules")
    parser.add_argument("--dump", action="store_true", help="System -> Repo")
    parser.add_argument("--restore", action="store_true", help="Repo -> System")
    parser.add_argument(
        "--load-agents", action="store_true", help="Update LaunchAgents"
    )
    parser.add_argument("--no-git", action="store_true", help="Skip Git push")

    args = parser.parse_args()

    if not os.path.exists(SETTINGS_PATH):
        print(f"❌ Settings not found: {SETTINGS_PATH}")
        sys.exit(1)

    with open(SETTINGS_PATH, "r") as f:
        full_config = yaml.safe_load(f)

    all_modules = list(full_config.get("modules", {}).keys())
    defaults = full_config.get("defaults", {})

    target_modules = all_modules if args.all else args.modules

    # Default to all if loading agents and no specific modules given
    if args.load_agents and not target_modules:
        target_modules = all_modules

    if not target_modules and not args.load_agents:
        parser.print_help()
        sys.exit(0)

    if args.dump:
        process_modules(target_modules, full_config, "dump")
        if not args.no_git and defaults.get("git_push", True):
            git_push()

    if args.restore:
        process_modules(target_modules, full_config, "restore")

    if args.load_agents:
        generate_agents(target_modules, full_config, defaults)
