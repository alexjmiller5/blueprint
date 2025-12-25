#!/bin/bash

# Directory Setup
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
mkdir -p "$BACKUP_DIR"

# 1. Dump User Data (No sudo needed)
USER_DUMP=$(/usr/bin/sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access")

# 2. Dump System Data (NEEDS SUDO)
# We check if we can read it first; if not, we try sudo
if [ -r "/Library/Application Support/com.apple.TCC/TCC.db" ]; then
    SYSTEM_DUMP=$(/usr/bin/sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access")
else
    echo "⚠️  Need sudo to read System TCC database (Accessibility permissions)..."
    SYSTEM_DUMP=$(sudo /usr/bin/sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "SELECT service, client, auth_value FROM access")
fi

# 3. Combine Dumps
FULL_DUMP="${USER_DUMP}
${SYSTEM_DUMP}"

# 4. Process with Python -> CSV
echo "$FULL_DUMP" | python3 -c '
import sys
import csv

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
        status = "Allowed"
    elif auth_val == "0":
        status = "Denied"
    else:
        status = f"Unknown ({auth_val})"

    unique_entries.add((client, service, status))

# Write CSV to stdout
writer = csv.writer(sys.stdout)
writer.writerow(["Application", "Permission", "Status"])

# Sort by Application Name, then Service
for entry in sorted(list(unique_entries), key=lambda x: (x[0].lower(), x[1])):
    writer.writerow(entry)
' > "$BACKUP_DIR/tcc_permissions.csv"

# 5. Git Push
# "$REPO_ROOT/core/git_push.sh"