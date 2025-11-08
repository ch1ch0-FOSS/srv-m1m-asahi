# Infrastructure Architecture

## Hardware & Storage
- **Compute:** Apple M1 Mac mini (16GB RAM, 256GB SSD – OS only)
- **Storage:** External SSD 7.28 TiB (mounted at /mnt/data – all persistent data)

## Data-Device Separation
- OS and logs live on M1 SSD (can be wiped & reinstalled)
- All user/service data lives on external SSD (survives OS reinstall)
- Data loss: Minimal risk (external SSD is backed up daily)
- Recovery time: ~30 minutes (OS + services restart)

## Services Architecture
| Service | Port | Data Location | User |
|---------|------|---------------|------|
| Forgejo | 3100 | /mnt/data/srv/forgejo/ | git |
| Syncthing | 8384 | /mnt/data/srv/syncthing/ | root |
| Vaultwarden | 8000 | /mnt/data/srv/vaultwarden/ | root |
| Ollama | 11434 | /mnt/data/srv/ollama/ | ollama |

