#!/usr/bin/env bash
set -euo pipefail

VM_NAME="PrivacyLab"

echo "[+] PrivacyLab Reset Script"
echo "[+] This will restore the VM to a clean state"
echo ""

# Check if VM exists
if ! VBoxManage list vms | grep -q "\"$VM_NAME\""; then
    echo "❌ VM '$VM_NAME' not found. Please run the installer first."
    exit 1
fi

# Check if VM is running
if VBoxManage list runningvms | grep -q "\"$VM_NAME\""; then
    echo "[!] VM is currently running. Shutting down..."
    VBoxManage controlvm "$VM_NAME" poweroff || true
    sleep 3
fi

echo "[+] Restoring CleanState snapshot..."
VBoxManage snapshot "$VM_NAME" restore CleanState

echo ""
echo "✅ VM has been reset to clean state"
echo ""
echo "Next steps:"
echo "1. Start VM: VBoxManage startvm \"$VM_NAME\""
echo "2. Work in the VM"
echo "3. Reset again when done: ./reset-vm.sh"
echo ""
echo "Remember: Always reset after each session!"
