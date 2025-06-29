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

## 🚀 Coming Soon: `lget` [name subject to change]

---

We plan to include a helper script named `lget` that will allow you to easily search for, fetch, and run scripts from this collection directly from your terminal.

LGet would be inspired by BGet, in fact it would most likely be BGet but written in bash.

Example usage (planned):

```bash
./lget -list           # Lists all available scripts by category
./lget -get test     # Downloads test.sh from novelties/
./lget -run test
```
