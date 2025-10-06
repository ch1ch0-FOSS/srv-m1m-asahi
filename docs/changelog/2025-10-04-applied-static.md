### 2025-10-04: Applied Static IP on end0

**Who:** admin

**What Changed:**
- Set static IPv4 (192.168.1.64/24), gateway (192.168.1.1), and DNS (192.168.1.1, 8.8.8.8) on connection "Wired connection 1" (end0) with nmcli.

**Why:**
- Ensure the server has a persistent, predictable IP and DNS on local network.

**How Verified:**
- Ran `ip a`, `nmcli device show`, and `resolvectl status` to confirm new settings.
