#!/usr/bin/env pwsh

# PrivacyLab Pay & Go Installer - Windows PowerShell Variant

$VM_NAME = "PrivacyLab"
$RAM = 4096
$CPUS = 2
$DISK_MB = 20480
$ISO_URL = "https://tails.net/tails-amd64-latest.iso"
$ISO_PATH = "$env:USERPROFILE\Downloads\tails.iso"

# ASCII Pipeline Display
function Show-Pipeline {
    Write-Host ""
    Write-Host "╔══════════════════════════════════════════════════════════════╗"
    Write-Host "║                    PRIVACYLAB PIPELINE                       ║"
    Write-Host "╠══════════════════════════════════════════════════════════════╣"
    Write-Host "║ User initiates VM install                                     ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║  Download & run installer                                     ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║   VirtualBox / VM setup                                       ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║  Hardened VM created                                          ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║   Snapshot CleanState taken                                   ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║      1-Click Start                                            ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║    User works in VM                                           ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║    Finished session?                                          ║"
    Write-Host "║        │                                                      ║"
    Write-Host "║        ▼                                                      ║"
    Write-Host "║ Snapshot Restore → Back to clean VM                           ║"
    Write-Host "╚══════════════════════════════════════════════════════════════╝"
    Write-Host ""
}

# Post-installatie instructies
function Show-Instructions {
    Write-Host ""
    Write-Host "==========================================="
    Write-Host "✅ PrivacyLab Pay & Go is klaar voor gebruik"
    Write-Host ""
    Write-Host "Volgende stappen:"
    Write-Host "1. Start de VM: VBoxManage startvm `"PrivacyLab`""
    Write-Host "2. Werk in de VM zoals gewenst"
    Write-Host "3. Na gebruik: VBoxManage snapshot `"PrivacyLab`" restore CleanState"
    Write-Host ""
    Write-Host "Do's ✅:"
    Write-Host "- Reset VM na elke sessie"
    Write-Host "- Houd host OS up-to-date"
    Write-Host "- Gebruik NAT-only netwerk"
    Write-Host ""
    Write-Host "Don'ts ❌:"
    Write-Host "- Geen echte accounts gebruiken"
    Write-Host "- Geen downloads openen op host"
    Write-Host "- Geen USB of shared folders activeren"
    Write-Host "- Geen crypto wallets of gevoelige accounts gebruiken"
    Write-Host ""
    Write-Host "Flow overzicht:"
    Write-Host "User → Installer → VM Setup → Snapshot CleanState → Start VM → Work → Reset VM → Repeat"
    Write-Host "==========================================="
}

Write-Host "[+] PrivacyLab Pay & Go Installer (Windows)"
Write-Host "[+] Checking VirtualBox installation"

# Check if VirtualBox is installed
try {
    $vboxVersion = & VBoxManage --version
    Write-Host "[+] VirtualBox found: $vboxVersion"
} catch {
    Write-Host "❌ VirtualBox not found. Please install VirtualBox first from https://www.virtualbox.org/"
    exit 1
}

Write-Host "[+] Downloading Tails ISO"
if (-not (Test-Path $ISO_PATH)) {
    try {
        Invoke-WebRequest -Uri $ISO_URL -OutFile $ISO_PATH
        Write-Host "[+] ISO downloaded successfully"
    } catch {
        Write-Host "❌ Failed to download ISO. Please check your internet connection."
        exit 1
    }
} else {
    Write-Host "[+] ISO already exists, skipping download"
}

Write-Host "[+] Creating VM"
# Check if VM already exists
$existingVM = & VBoxManage list vms | Select-String $VM_NAME
if ($existingVM) {
    Write-Host "[!] VM '$VM_NAME' already exists. Removing old VM..."
    try {
        & VBoxManage unregistervm $VM_NAME --delete
    } catch {
        Write-Host "[!] Could not remove existing VM, continuing..."
    }
}

& VBoxManage createvm --name $VM_NAME --register

& VBoxManage modifyvm $VM_NAME `
  --memory $RAM `
  --cpus $CPUS `
  --nic1 nat `
  --audio none `
  --clipboard disabled `
  --draganddrop disabled `
  --usb off

Write-Host "[+] Creating disk"
$diskPath = "$env:USERPROFILE\$VM_NAME.vdi"
if (Test-Path $diskPath) {
    Remove-Item $diskPath
}

& VBoxManage createmedium disk --filename $diskPath --size $DISK_MB

& VBoxManage storagectl $VM_NAME --name "SATA" --add sata --controller IntelAhci

& VBoxManage storageattach $VM_NAME `
  --storagectl "SATA" `
  --port 0 --device 0 `
  --type hdd `
  --medium $diskPath

& VBoxManage storageattach $VM_NAME `
  --storagectl "SATA" `
  --port 1 --device 0 `
  --type dvddrive `
  --medium $ISO_PATH

Write-Host "[+] Taking snapshot"
& VBoxManage snapshot $VM_NAME take CleanState

Write-Host "[+] Installation complete!"
Show-Pipeline
Show-Instructions
