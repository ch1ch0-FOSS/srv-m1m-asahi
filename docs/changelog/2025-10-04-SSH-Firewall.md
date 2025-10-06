### 2025-10-04: SSH & Firewall Hotfix Applied

**By:** admin

**What changed:**
- Updated /etc/ssh/sshd_config:
    - Enforced key-only login (`PasswordAuthentication no`)
    - Disabled root SSH (`PermitRootLogin no`)
    - Restricted login to ch1ch0 and admin (`AllowUsers`)
    - Limited auth attempts (`MaxAuthTries 3`, `MaxSessions 3`)
- Reloaded sshd service.
- firewalld audited and updated:
    - Only enabled ssh, http, https, mdns (for local hostname discovery), dhcpv6-client (for IPv6), and port 3000/tcp (Forgejo).
    - Disabled telnet and ftp.
- Verified all changes from a test client.

**Why:**
- To fully harden remote access in line with current best-practice Linux security.

**Recommendations:**
- Review `mdns` and `3000/tcp` exposure if public network not needed.
- Regularly audit this setup to ensure compliance and minimal external access.
