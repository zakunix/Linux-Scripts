# Linux Scripts Collection

This repository contains a collection of Linux shell scripts organized by compatibility with various Linux distributions. These scripts are useful for system maintenance, setup, automation, and utility purposes.

---

## 📂 Directory Structure

- `common/` - Scripts compatible with most Linux distributions.
- `debian-based/` - Scripts tailored for Debian, Ubuntu, and related distributions.
- `redhat-based/` - Scripts for RedHat, CentOS, Fedora, and similar.
- `arch-based/` - Scripts for Arch Linux, Manjaro, and derivatives.
- `suse-based/` - Scripts for openSUSE and SUSE Linux Enterprise.
- `experimental/` - Scripts under testing or development.
- `utils/` - Shared helper scripts and modules.

⚠️ **Disclaimer:** These scripts are for entertainment purposes. Some may be silly, harmless pranks. Use responsibly.
- `novelties/` - Meme or novelty scripts written for fun or amusement.


It is possible that some distro-specific scripts just needs some tweaking to be able to be used in another distro.

---

## 📦 Usage

---

Make scripts executable before running:

```bash
chmod +x script-name.sh
./script-name.sh
```

---

## 🚀 Now Available: `bpkg` (Bash Package Manager)

`bpkg` is a lightweight Bash-based script manager designed to let you easily **fetch**, **run**, **list**, and **manage** scripts from this repository—all from the terminal.

Inspired by [BGet](https://github.com/jahwi/bget), `bpkg` is fully written in Bash and built for Linux.

---

### 🛠️ Example Usage

```bash
./bpkg.sh -list -local               # List all scripts available locally
./bpkg.sh -list -server -usecurl     # List all scripts available from the remote server
./bpkg.sh -get -usesh test           # Download 'test' script using shell method
./bpkg.sh -run test                  # Run the 'test' script from local storage
./bpkg.sh -remove test               # Remove the 'test' script
./bpkg.sh -upgrade -usesh            # Upgrade bpkg to the latest version
```

### ✅ Supported Download Methods
- `usesh`   → Uses the `bin/download.sh` script
- `usecurl` → Uses `curl` directly
- `usejs`   → Uses `bin/download.js` (requires Node.js)
