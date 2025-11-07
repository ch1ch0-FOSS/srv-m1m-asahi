# Fedora Asahi Minimal Install (M1 Mac Mini)

## Purpose

This guide walks you through installing Fedora Asahi on Apple Silicon (M1) for professional, reproducible infrastructure. It distills the official process, with added one-liner tips from real-world experience.

---

## Prerequisites

- Apple M1 Mac Mini (tested on [model])
- 16GB+ USB drive
- Internet access
- Backup any data! (this will wipe your system)

---

## Step-by-Step Install

1. **Download Disk Image**
   - Get latest Fedora Asahi ARM64 image: [https://fedoraproject.org/asahi](https://fedoraproject.org/asahi)

2. **Create Bootable USB**
   - Use [balenaEtcher](https://www.balena.io/etcher/) or, from a Linux/Mac terminal:
     ```
     sudo dd if=Fedora-*-asahi-*.iso of=/dev/sdX bs=4M status=progress
     ```
   - Verify USB is written successfully.

3. **Prepare Mac Mini**
   - Power off. Plug in USB.
   - Hold power to enter recovery, select USB boot (as prompted by Apple).

4. **Install Fedora Asahi**
   - Follow Fedora’s guided installer.
   - Note: Recommended custom partitioning for infra (see [SYSTEM_SETUP.md] for our partitions).
   - Set admin/FEDORA user—use a secure password, write down the username.

5. **Initial Post-Install**
   - Boot into Fedora, verify network
   - Update packages (see `fedora_bootstrap.sh`)
   - Optional: Update firmware if prompted

---

## Tips From Real-World Use

- Sometimes USB boot requires an Apple firmware update; check before starting
- Use the exact Apple keyboard/mouse for early prompts—third-party may fail
- First boot may be slow, but subsequent boots are quick

---

## Troubleshooting

- For stuck boots, see official [Fedora Asahi Troubleshooting](https://fedoraproject.org/asahi/troubleshooting)
- If you hit connection or display bugs, reboot and ensure correct input method selected on login.

---

## References

- [Fedora Asahi Linux main page](https://fedoraproject.org/asahi)
- [Asahi Linux official site](https://asahilinux.org/)
- Your system notes and custom settings: see SYSTEM_SETUP.md

---

*Guide written for ch1ch0's infrastructure portfolio—see [`00-BOOTSTRAP/README.md`](./README.md) for how this fits in full infra pipeline.*

