# 🚀 SNI Spoof MJA

<p align="center">
  <img src="https://img.shields.io/badge/Linux-Supported-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Systemd-Service-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Auto-Update-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/Golang-Installer-cyan?style=for-the-badge">
</p>

---

# ✨ Features

* ✅ Automatic Installation
* ✅ Auto Install Golang
* ✅ Auto Create Systemd Service
* ✅ Auto Start After Reboot
* ✅ Professional Manager Menu
* ✅ Config Editor
* ✅ Service Restart
* ✅ Service Status
* ✅ Live Logs Viewer
* ✅ Backup Config
* ✅ Restore Config
* ✅ Auto Update
* ✅ Full Uninstall
* ✅ Dedicated Linux User
* ✅ Colored Terminal Menu

---

# ⚡ One-Line Install

```bash
bash <(curl -Ls https://raw.githubusercontent.com/majid-abbasi/sni-spoof.mja/main/install.sh)
```
#⚡ Local Installation
---
Upload this file to your server:

sni-spoof-mja.tar.gz

Then run:

tar -xzf sni-spoof-mja.tar.gz
cd sni-spoof-mja
chmod +x install.sh
sudo ./install.sh
---
---
# 📦 Repository Structure

```text
sni-spoof-mja/
├── install.sh
├── config.json
├── sni-spoof-mja
└── README.md
```

---

# 🎮 Manager Menu

After installation run:

```bash
mja
```

---

# 🖥️ Manager Options

```text
1) Edit Config
2) Restart Program
3) Service Status
4) View Logs
5) Backup Config
6) Restore Config
7) Auto Update
8) Remove Program
9) Exit
```

---

# 🔧 Service Commands

## Service Status

```bash
systemctl status sni-spoof-mja
```

## Restart Service

```bash
systemctl restart sni-spoof-mja
```

## Stop Service

```bash
systemctl stop sni-spoof-mja
```

## View Logs

```bash
journalctl -u sni-spoof-mja -f
```

---

# 📂 Installation Path

```text
/etc/sni-spoof-mja
```

---

# 🔄 Auto Update

Update directly from GitHub using:

```bash
mja
```

Then select:

```text
7) Auto Update
```

---

# ❌ Uninstall

Open manager:

```bash
mja
```

Then select:

```text
8) Remove Program
```

---

# 🛡️ Requirements

* Ubuntu / Debian
* CentOS
* AlmaLinux
* Rocky Linux
* Arch Linux

---

# 👨‍💻 Developer

GitHub:

```text
https://github.com/majid-abbasi
```

---

# ⭐ Support

If this project helped you, give it a ⭐ on GitHub.
