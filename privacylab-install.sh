#!/usr/bin/env bash
set -euo pipefail

VM_NAME="PrivacyLab"
RAM=4096
CPUS=2
DISK=20480
ISO_URL="https://download.tails.net/tails/stable/tails-amd64-7.5/tails-amd64-7.5.iso"
ISO="$HOME/tails.iso"

# ASCII Pipeline Display
display_pipeline() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    PRIVACYLAB PIPELINE                       ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║ User initiates VM install                                     ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║  Download & run installer                                     ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║   VirtualBox / VM setup                                       ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║  Hardened VM created                                          ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║   Snapshot CleanState taken                                   ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║      1-Click Start                                            ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║    User works in VM                                           ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║    Finished session?                                          ║"
    echo "║        │                                                      ║"
    echo "║        ▼                                                      ║"
    echo "║ Snapshot Restore → Back to clean VM                           ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Post-installatie instructies
display_instructions() {
    echo ""
    echo "==========================================="
    echo "✅ PrivacyLab Pay & Go is klaar voor gebruik"
    echo ""
    echo "Volgende stappen:"
    echo "1. Start de VM: VBoxManage startvm \"PrivacyLab\""
    echo "2. Werk in de VM zoals gewenst"
    echo "3. Na gebruik: VBoxManage snapshot \"PrivacyLab\" restore CleanState"
    echo ""
    echo "Do's ✅:"
    echo "- Reset VM na elke sessie"
    echo "- Houd host OS up-to-date"
    echo "- Gebruik NAT-only netwerk"
    echo ""
    echo "Don'ts ❌:"
    echo "- Geen echte accounts gebruiken"
    echo "- Geen downloads openen op host"
    echo "- Geen USB of shared folders activeren"
    echo "- Geen crypto wallets of gevoelige accounts gebruiken"
    echo ""
    echo "Flow overzicht:"
    echo "User → Installer → VM Setup → Snapshot CleanState → Start VM → Work → Reset VM → Repeat"
    echo "==========================================="
}

echo "[+] PrivacyLab Pay & Go Installer"
echo "[+] Installing VirtualBox"

if ! command -v VBoxManage &> /dev/null; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if ! command -v brew &> /dev/null; then
            echo "❌ Homebrew required. Please install Homebrew first."
            exit 1
        fi
        brew install --cask virtualbox
    else
        sudo apt update -y
        sudo apt install -y virtualbox curl
    fi
fi

echo "[+] Downloading Tails ISO"
if [ ! -f "$ISO" ]; then
    curl -L -o "$ISO" "$ISO_URL"
else
    echo "[+] ISO already exists, skipping download"
fi

echo "[+] Creating VM"
if VBoxManage list vms | grep -q "\"$VM_NAME\""; then
    echo "[!] VM '$VM_NAME' already exists. Removing old VM..."
    VBoxManage unregistervm "$VM_NAME" --delete || true
fi

VBoxManage createvm --name "$VM_NAME" --register

VBoxManage modifyvm "$VM_NAME" \
  --memory $RAM \
  --cpus $CPUS \
  --nic1 nat \
  --audio none \
  --clipboard disabled \
  --draganddrop disabled \
  --usb off

echo "[+] Creating disk"
if [ -f "$HOME/$VM_NAME.vdi" ]; then
    rm "$HOME/$VM_NAME.vdi"
fi

VBoxManage createmedium disk --filename "$HOME/$VM_NAME.vdi" --size $DISK

VBoxManage storagectl "$VM_NAME" --name "SATA" --add sata --controller IntelAhci

VBoxManage storageattach "$VM_NAME" \
  --storagectl "SATA" \
  --port 0 --device 0 \
  --type hdd \
  --medium "$HOME/$VM_NAME.vdi"

VBoxManage storageattach "$VM_NAME" \
  --storagectl "SATA" \
  --port 1 --device 0 \
  --type dvddrive \
  --medium "$ISO"

echo "[+] Taking snapshot"
VBoxManage snapshot "$VM_NAME" take CleanState

echo "[+] Installation complete!"
display_pipeline
display_instructions
