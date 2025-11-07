# Forgejo Troubleshooting Guide

## Service fails to start

- Check status: `sudo systemctl status forgejo`
- View logs: `journalctl -u forgejo -n 100`
- Common: `app.ini` path wrong, DB down, file perms

## Can't clone/push via SSH

- Is `DISABLE_SSH` set to `false` in config?
- Port open in firewall?
- Public key added to user profile?

## Database connection errors

- Verify MariaDB process up: `sudo systemctl status mariadb`
- Test manual login: `mysql -u forgejo -p`
- Confirm user/DB/password in `app.ini` and DB match

## Permission denied issues

- Fix with: `sudo chown -R git:git /var/lib/forgejo`
- Ensure systemd unit runs as "git" user

## Web UI not accessible

- Is `DOMAIN` and `ROOT_URL` correct?
- Check firewall, confirm `systemctl status forgejo` returns "active (running)"

---

If these steps fail, check [Forgejo docs](https://forgejo.org/docs) and open an issue.

