# Incident Response Plan

**Version:** 1.0  
**Last Updated:** 2025-11-08  
**Review Cycle:** Quarterly  
**On-Call Admin:** ch1ch0  

---

## Purpose

This document defines procedures for responding to system failures, security incidents, and operational emergencies on srv-m1m-asahi infrastructure.

---

## Incident Classification

| Severity | Description | Response Time | Examples |
|----------|-------------|---------------|----------|
| **P0 (Critical)** | Complete system outage | Immediate | OS failure, data corruption, security breach |
| **P1 (High)** | Major service disruption | <15 min | Single service down, disk full |
| **P2 (Medium)** | Degraded performance | <1 hour | High CPU, slow response times |
| **P3 (Low)** | Minor issues | <24 hours | Non-critical warnings, cosmetic bugs |

---

## P0: Critical Incident Response

### Symptoms
- All services unreachable
- OS won't boot
- Data corruption detected
- Security breach confirmed

### Immediate Actions (0-5 minutes)

1. **Assess Situation**
   ```bash
   # Can you SSH into system?
   ssh sysadmin@192.168.1.64
   
   # If yes, check services
   systemctl status forgejo syncthing vaultwarden ollama
   
   # Check disk space
   df -h
   
   # Check system logs
   sudo journalctl -xe -n 100
   ```

2. **Document Incident**
   - Timestamp of discovery
   - Symptoms observed
   - Actions taken
   - Update `incident-log.txt`

3. **Determine Scope**
   - Is OS accessible?
   - Is external SSD mounted?
   - Can users access data?

### Recovery Actions (5-30 minutes)

#### If OS is accessible:
```bash
# Restart failed services
sudo systemctl restart forgejo syncthing vaultwarden ollama

# Check logs for errors
sudo journalctl -u forgejo -n 50
sudo journalctl -u syncthing -n 50
sudo journalctl -u vaultwarden -n 50
sudo journalctl -u ollama -n 50

# Verify data integrity
ls -la /mnt/data/srv/
df -h /mnt/data
```

#### If OS is not accessible:
- Follow **restore-procedure.md** → Scenario 1
- Estimated recovery: 30 minutes

### Post-Incident Actions (30-60 minutes)

1. **Verify Recovery**
   ```bash
   # Test all services
   curl http://localhost:3100  # Forgejo
   curl http://localhost:8384  # Syncthing
   curl http://localhost:8000  # Vaultwarden
   
   # Check data accessibility
   ls /mnt/data/home/
   ```

2. **Root Cause Analysis**
   - Review logs
   - Identify trigger
   - Document findings

3. **Prevent Recurrence**
   - Update runbooks
   - Add monitoring
   - Schedule follow-up

---

## P1: High Priority Incident Response

### Symptoms
- Single service down
- Disk space critically low (>90%)
- Performance severely degraded

### Immediate Actions (0-15 minutes)

1. **Identify Affected Service**
   ```bash
   systemctl status forgejo syncthing vaultwarden ollama
   ```

2. **Check Common Causes**
   ```bash
   # Disk space
   df -h
   
   # Memory usage
   free -h
   
   # CPU usage
   top -bn1 | head -20
   
   # Service logs
   sudo journalctl -u <service> -n 100
   ```

3. **Quick Fixes**
   
   **Disk Space Issue:**
   ```bash
   # Clean old backups
   find /mnt/data/backups -mtime +7 -exec rm -rf {} \;
   
   # Clean package cache
   sudo dnf clean all
   
   # Clean logs
   sudo journalctl --vacuum-time=7d
   ```
   
   **Service Crashed:**
   ```bash
   sudo systemctl restart <service>
   sudo systemctl status <service>
   ```

### Post-Resolution

- Document incident in `incident-log.txt`
- Update monitoring thresholds
- Schedule preventive maintenance

---

## P2: Medium Priority Incident Response

### Symptoms
- Slow web UI response
- High CPU usage
- Increased error rates

### Response Actions (0-60 minutes)

1. **Gather Metrics**
   ```bash
   # CPU usage by process
   top -bn1 | head -20
   
   # Memory usage
   free -h
   
   # Disk I/O
   iostat -x 2 5
   
   # Network connections
   ss -tulpn | grep LISTEN
   ```

2. **Identify Bottleneck**
   - CPU-bound? (Ollama inference, compilation)
   - Memory-bound? (Large repos, many connections)
   - Disk I/O-bound? (Backup running, sync activity)

3. **Mitigate**
   - Restart heavy services
   - Reschedule background jobs
   - Optimize configs

### Post-Resolution

- Document performance issue
- Review capacity planning
- Consider hardware upgrades

---

## P3: Low Priority Incident Response

### Symptoms
- Cosmetic bugs
- Non-critical warnings in logs
- Minor configuration issues

### Response Actions (0-24 hours)

1. **Document Issue**
   - Add to backlog
   - Assign priority
   - Schedule fix

2. **Plan Maintenance**
   - Group with other minor fixes
   - Schedule during low-traffic window
   - Test in non-production first

---

## Security Incident Response

### Indicators of Compromise
- Unexpected SSH login attempts
- Unknown processes running
- Unauthorized file changes
- Unusual network traffic

### Immediate Actions

1. **Isolate System**
   ```bash
   # Block external access (if needed)
   sudo firewall-cmd --panic-on
   
   # Disconnect from network (if severe)
   sudo ip link set eth0 down
   ```

2. **Preserve Evidence**
   ```bash
   # Snapshot logs
   sudo journalctl > /tmp/incident-$(date +%Y%m%d-%H%M%S).log
   
   # List active connections
   ss -tulpn > /tmp/connections-$(date +%Y%m%d-%H%M%S).txt
   
   # List running processes
   ps auxf > /tmp/processes-$(date +%Y%m%d-%H%M%S).txt
   ```

3. **Investigate**
   ```bash
   # Check for unauthorized users
   cat /etc/passwd | grep -v "nologin"
   
   # Check SSH logs
   sudo grep "Failed password" /var/log/auth.log | tail -50
   
   # Check for suspicious processes
   ps auxf | grep -v "^\[" | grep -v "root"
   
   # Check file integrity
   sudo find /etc -type f -mtime -1
   ```

4. **Contain Threat**
   ```bash
   # Change all passwords
   sudo passwd sysadmin
   sudo passwd ch1ch0
   
   # Rotate SSH keys
   ssh-keygen -t ed25519 -C "new-key@ch1ch0.me"
   
   # Restart services
   sudo systemctl restart sshd
   ```

5. **Notify**
   - Document incident
   - Report to authorities (if required)
   - Update security procedures

---

## Communication Plan

### Internal Communication

During an incident:
- Update `incident-log.txt` in real-time
- Use secure channel (Signal, encrypted email)
- Provide status updates every 30 minutes

### External Communication

If services are publicly accessible:
- Post status update on ch1ch0.me
- Notify users via email
- Update social media

---

## Incident Log Template

```
Incident ID: INC-YYYYMMDD-HHMMSS
Severity: P0 / P1 / P2 / P3
Reported By: <name>
Reported At: <timestamp>

Description:
<What happened?>

Impact:
<What services/users affected?>

Actions Taken:
1. <First action>
2. <Second action>
...

Resolution:
<How was it resolved?>

Root Cause:
<Why did it happen?>

Prevention:
<How to prevent in future?>

Resolved At: <timestamp>
Resolved By: <name>
```

---

## Post-Incident Review

Within 48 hours of resolution:

1. **Document Incident**
   - Update incident log
   - Add to knowledge base
   - Share with team (if applicable)

2. **Root Cause Analysis**
   - Identify trigger
   - Identify contributing factors
   - Identify systemic issues

3. **Action Items**
   - Update runbooks
   - Improve monitoring
   - Schedule training

4. **Update Procedures**
   - Revise incident response plan
   - Update recovery procedures
   - Test changes

---

## Escalation Path

| Level | Contact | Scope |
|-------|---------|-------|
| **L1** | ch1ch0 (primary admin) | All incidents |
| **L2** | Backup admin (if applicable) | P0/P1 incidents |
| **L3** | External consultant | Security breaches, data loss |

---

## Tools & Resources

| Tool | Purpose | Location |
|------|---------|----------|
| **Logs** | System diagnostics | `sudo journalctl -xe` |
| **Monitoring** | Service health | `systemctl status` |
| **Backup** | Data recovery | `/mnt/data/backups/` |
| **Runbooks** | Operational procedures | `srv-m1m-asahi/` repo |
| **Recovery** | Disaster recovery | `restore-procedure.md` |

---

## Training & Drills

- **Monthly:** Recovery drill (see MONTHLY-TEST-LOG.md)
- **Quarterly:** Incident response tabletop exercise
- **Annually:** Full disaster recovery simulation

---

**This plan is reviewed quarterly and updated based on lessons learned from incidents and drills.**