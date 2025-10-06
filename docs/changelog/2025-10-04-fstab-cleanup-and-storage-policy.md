### 2025-10-04: fstab Cleanup and Storage Policy Applied

**Who:** admin

**What Changed:**
- Removed duplicate `/dev/sdc1 /mnt/data btrfs ...` entry from `/etc/fstab`.
- Confirmed mounts for `/mnt/data` (primary data) and `/mnt/fastdata` (compute/scratch).
- Set strict group-based permissions: `/mnt/data` for file/app storage; `/mnt/fastdata` for m1m compute workload use.

**Why:**
- Eliminate mount conflicts, reinforce FHS, and enforce strong data/compute separation for reliability and performance.

**How Verified:**
- Ran `sudo mount -a` and `findmnt -T /mnt/data /mnt/fastdata` to confirm clean mount points.
- Checked ownership/permissions for both directories.

**Recommendations:**
- Create subfolders for specific services or workflows under `/mnt/data` and `/mnt/fastdata` as needed.
- Review storage utilization and permissions quarterly.
