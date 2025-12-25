#!/bin/bash

# Directory Setup
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"

# 1. Dump User Data (No sudo needed)
USER_DUMP=$(/usr/bin/sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access")

# 2. Dump System Data (NEEDS SUDO)
# We check if we can read it first; if not, we might prompt for sudo or fail gracefully
if [ -r "/Library/Application Support/com.apple.TCC/TCC.db" ]; then
    SYSTEM_DUMP=$(/usr/bin/sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access")
else
    # Try with sudo if readable check failed
    echo "⚠️  Need sudo to read System TCC database for Accessibility permissions..."
    SYSTEM_DUMP=$(sudo /usr/bin/sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access")
fi

# 3. Combine Dumps
FULL_DUMP="${USER_DUMP}
${SYSTEM_DUMP}"

# 4. Process with Python
echo "$FULL_DUMP" | python3 -c '
import sys

SERVICE_MAP = {
    "kTCCServiceLiverpool": "iCloud/CloudKit",
    "kTCCServiceUbiquity": "iCloud Drive",
    "kTCCServiceSystemPolicyAllFiles": "Full Disk Access",
    "kTCCServiceSystemPolicyDesktopFolder": "Desktop Folder",
    "kTCCServiceSystemPolicyDocumentsFolder": "Documents Folder",
    "kTCCServiceSystemPolicyDownloadsFolder": "Downloads Folder",
    "kTCCServiceSystemPolicyRemovableVolumes": "Removable Volumes",
    "kTCCServiceSystemPolicyNetworkVolumes": "Network Volumes",
    "kTCCServiceAppleEvents": "Automation",
    "kTCCServiceAccessibility": "Accessibility",
    "kTCCServicePostEvent": "Input Monitoring",
    "kTCCServiceMicrophone": "Microphone",
    "kTCCServiceCamera": "Camera",
    "kTCCServiceListenEvent": "Input Monitoring (Listen)",
    "kTCCServiceScreenCapture": "Screen Recording"
}

unique_entries = set()

for line in sys.stdin:
    line = line.strip()
    if not line: continue
    
    parts = line.split("|")
    if len(parts) < 3: continue

    raw_service = parts[0]
    client = parts[1]
    auth_val = parts[2]

    # Clean Service Name
    if raw_service in SERVICE_MAP:
        service = SERVICE_MAP[raw_service]
    else:
        service = raw_service.replace("kTCCService", "").replace("SystemPolicy", "")

    # Clean Auth Status
    if auth_val == "2":
        status = "✅ Allowed"
    elif auth_val == "0":
        status = "❌ Denied"
    else:
        status = f"❓ Unknown ({auth_val})"

    unique_entries.add((client, service, status))

print(f"{to_str(len(unique_entries))} unique permissions found.\n")
print(f"{0:<60} | {1:<30} | {2}".format("APPLICATION (ID)", "PERMISSION", "STATUS"))
print("-" * 115)

for entry in sorted(list(unique_entries), key=lambda x: (x[0].lower(), x[1])):
    print(f"{entry[0]:<60} | {entry[1]:<30} | {entry[2]}")

def to_str(num):
    return str(num)
' > "$BACKUP_DIR/tcc_readable_dump.txt"

# 5. Git Push
"$REPO_ROOT/core/git_push.sh"