# PrivacyLab Pay & Go - Disposable Research VM

**Veilig experimenteren, zero setup, één klik opstarten, elke sessie schoon.**

---

## 🎯 Wat is PrivacyLab?

PrivacyLab is een **geïsoleerde, disposable VM** die speciaal is ontworpen voor veilig onderzoek en experimenteren. Alles draait in een volledig gesandboxde omgeving die na elke sessie wordt gereset naar een schone staat.

### Belangrijkste kenmerken

- ✅ **Volledig geïsoleerd**: Alles draait in een disposable VM
- ✅ **Snel**: Installatie en start binnen 5 minuten
- ✅ **Resetbaar**: Eén commando → volledige clean snapshot
- ✅ **Veilig**: Geen gedeelde mappen, clipboard of USB, NAT-only netwerk
- ✅ **Pay & Go**: Eenmalige aankoop, direct aan de slag

---

## 📦 Productinhoud

```
PrivacyLab-PayAndGo.zip
├── README.md                  # Deze handleiding
├── privacylab-install.sh       # Install script Linux/macOS
├── privacylab-install.ps1      # Install script Windows
├── tails.iso                   # Hardened VM image (Tails OS)
├── reset-vm.sh                 # Snapshot restore script
└── diagram.txt                 # ASCII pipeline diagram
```

---

## 🚀 Installatie

### Linux/macOS

1. Pak het ZIP-pakket uit
2. Open terminal en navigeer naar de map
3. Run het install script:

```bash
chmod +x privacylab-install.sh
./privacylab-install.sh
```

### Windows

1. Pak het ZIP-pakket uit
2. Open PowerShell als Administrator
3. Navigeer naar de map en run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\privacylab-install.ps1
```

Het script zal:
- VirtualBox installeren (indien nodig)
- Tails ISO downloaden
- VM aanmaken met veilige defaults
- Snapshot "CleanState" maken

---

## 🔄 Gebruik

### VM starten

**Linux/macOS:**
```bash
VBoxManage startvm "PrivacyLab"
```

**Windows:**
```powershell
VBoxManage startvm "PrivacyLab"
```

### VM resetten na gebruik

**Linux/macOS:**
```bash
VBoxManage snapshot "PrivacyLab" restore CleanState
```

**Windows:**
```powershell
VBoxManage snapshot "PrivacyLab" restore CleanState
```

### Of gebruik het reset script

```bash
chmod +x reset-vm.sh
./reset-vm.sh
```

---

## 📋 Pipeline Overzicht

```
User initiates VM install
        │
        ▼
  Download & run installer
        │
        ▼
   VirtualBox / VM setup
        │
        ▼
  Hardened VM created
        │
        ▼
   Snapshot CleanState taken
        │
        ▼
      1-Click Start
        │
        ▼
    User works in VM
        │
        ▼
    Finished session?
        │
        ▼
 Snapshot Restore → Back to clean VM
```

**Flow: start → werk → reset → repeat**

---

## ✅ Do's & Don'ts

### Do's ✅

- Gebruik de VM voor experimenten en onderzoek
- Reset VM na elke sessie
- Houd host OS up-to-date
- Gebruik NAT-only netwerk
- Werk binnen de Tails OS omgeving

### Don'ts ❌

- **Geen echte accounts gebruiken** (email, social media, etc.)
- **Geen downloads openen op de host**
- **Geen USB's of gedeelde folders activeren**
- **Geen crypto wallets of gevoelige accounts gebruiken**
- **Geen persoonlijke informatie invoeren in de VM**

---

## 🔐 Waarom is dit veilig?

### Isolatie
- Volledig geïsoleerde VM met NAT-only netwerk
- Geen gedeelde mappen, clipboard of USB
- Geen audio of andere onnodige interfaces

### Disposable
- Snapshot restore = geen persistente data
- Elke sessie begint schoon
- Malware kan niet persistenteren

### Simpel
- Minder configuratie = minder fouten
- Geen complexe monitoring of logging
- Minimalistische attack surface

---

## 🛠 VM Specificaties

- **OS**: Tails (The Amnesic Incognito Live System)
- **RAM**: 4GB
- **CPU**: 2 cores
- **Disk**: 20GB dynamisch
- **Netwerk**: NAT only
- **Features uitgeschakeld**: Clipboard, USB, shared folders, audio

---

## ⚠️ Belangrijke Opmerkingen

### Legaal gebruik
PrivacyLab is ontworpen voor:
- Journalistiek onderzoek
- OSINT (Open Source Intelligence)
- Security awareness training
- Educatieve doeleinden
- Privacy onderzoek

### Geen illegaliteit
Dit product faciliteert geen illegale activiteiten en is niet ontworpen voor opsporingsontwijking.

### Eigen verantwoordelijkheid
Gebruik op eigen risico. Volg altijd de lokale wetgeving en richtlijnen.

---

## 🆘 Support

### Veelgestelde vragen

**Q: Kan ik bestanden downloaden in de VM?**
A: Ja, maar open deze nooit op je host machine. Reset de VM na elke sessie.

**Q: Werkt dit op alle systemen?**
A: Linux, macOS en Windows met VirtualBox.

**Q: Moet ik VirtualBox handmatig installeren?**
A: Nee, het install script doet dit automatisch.

**Q: Kan ik de VM configuratie aanpassen?**
A: Niet aanbevolen. De huidige configuratie is geoptimaliseerd voor veiligheid.

---

Voor vragen of support:
- Productdocumentatie: deze README
- Technische issues: check installatie output

---

**PrivacyLab 2 Go - Veilig experimenteren, zonder compromis.**
