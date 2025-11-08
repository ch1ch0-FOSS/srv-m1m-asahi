# Operational Procedures

## Daily
- Check /mnt/data mount: `mount | grep /mnt/data`
- Verify services: `systemctl status forgejo syncthing vaultwarden ollama`

## Weekly  
- Review disk usage: `du -sh /mnt/data/*`
- Check logs: `sudo journalctl -u forgejo -n 100`

## Monthly
- Test disaster recovery (dry-run)
- Update documentation if procedures change
- Review backup sizes

## Quarterly
- Review FHS guide for compliance
- Test full system backup/restore

