---
name: home-server
description: Manage Bernardo's Arch Linux home server at 192.168.0.242. Use this skill whenever the user mentions the server, asks about Docker, Jellyfin, qBittorrent, Samba, storage, mounts, services, or anything related to the home server setup. Also trigger for SSH, systemctl, disk management, or network questions in the context of the server.
---

# Home Server Management Skill

## Server Overview

- **OS**: Arch Linux
- **IP**: 192.168.0.242
- **SSH**: `ssh -i ~/.ssh/homeserver root@192.168.0.242`
- **User**: root (and `berni` with sudo)
- **Shell**: bash (root), zsh (berni)

> SSH key is at `~/.ssh/homeserver` on berni's local machine. Password auth works interactively but not from non-TTY tools — always use `-i ~/.ssh/homeserver`.

## Hardware

| Disk | Device | Size | Role |
|------|--------|------|------|
| OS drive | `/dev/sdb` | 465.8G | OS, home, logs |
| Media drive | `/dev/sda` | 931.5G (1TB) | Media storage (`/srv/media`) |

### Disk Layout

**sdb (OS drive)**
- `sdb1` → `/boot` (FAT32, 1G)
- `sdb2` → `/`, `/home`, `/var/log`, `/var/cache/pacman/pkg` (btrfs, 464.8G)

**sda (Media drive)** — formatted 2026-06-06, was a Windows machine (EliteOS NTFS, wiped)
- `sda1` → `/srv/media` (btrfs, 931.5G)
- UUID: `b550d84c-978e-4cc9-b180-046af558787a`

## Services

| Service | Port | Access | Status |
|---------|------|--------|--------|
| Jellyfin | 8096 | `http://192.168.0.242:8096` | Docker |
| qBittorrent | 8080 | `http://192.168.0.242:8080` | systemd |
| Samba | 445 | `smb://192.168.0.242/media` | systemd |
| SSH | 22 | `ssh root@192.168.0.242` | systemd |
| Cockpit | 9090 | `http://192.168.0.242:9090` | systemd |

## Media Storage

- **Samba share root**: `/srv/media`
- **Samba share name**: `media`
- **Permissions**: `nobody:nobody`, `chmod 777` + **default POSIX ACLs** so all new content inherits `777` (see below)

### Media Structure
```
/srv/media/
├── anime/
│   ├── [Cerberus] Saiki Kusuo no Psi Nan S1 + S2 + Special/
│   │   ├── Season 01/
│   │   ├── Season 02/
│   │   └── Specials/
│   ├── ChainsawManReze/
│   ├── ghibli/
│   └── jujutsu_kaisen/
├── drama/
├── manga/
├── movies/
└── music/
```

## Docker Setup

Compose file: `/root/jellyfin/docker-compose.yml`

```yaml
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    restart: unless-stopped
    ports:
      - 8096:8096
    volumes:
      - ./config:/config
      - ./cache:/cache
      - /srv/media:/media
```

### Common Docker Commands
```bash
cd /root/jellyfin
docker compose up -d       # start
docker compose down        # stop
docker compose logs -f     # logs
docker exec jellyfin ls /media  # verify mounts
```

## Samba Config

File: `/etc/samba/smb.conf`

```ini
[global]
workgroup = WORKGROUP

[media]
path = /srv/media
browseable = yes
writable = yes
guest ok = yes
force user = nobody
force group = nobody
create mask = 0777
directory mask = 0777
```

Restart: `systemctl restart smb nmb`

## Network (Local Machine - berni's Arch desktop)

Samba mount in `/etc/fstab`:
```
//100.107.216.118/media /mnt/media cifs guest,uid=1000,gid=1000,_netdev,nofail,x-systemd.requires=tailscaled.service 0 0
```

> Uses the Tailscale IP (not local IP) so it works remotely too. `nofail` prevents shutdown hangs if server is off. `x-systemd.requires=tailscaled.service` ensures the share is unmounted before Tailscale stops, avoiding the hard hang on shutdown that requires a force power-off.

Mount manually: `sudo mount -a`

## qBittorrent

- Service: `qbittorrent-nox@root`
- Default download path: configure to `/srv/media` for unified storage
- Web UI: `http://192.168.0.242:8080` (user: `admin`)

```bash
systemctl status qbittorrent-nox@root
systemctl restart qbittorrent-nox@root
journalctl -u qbittorrent-nox@root | grep -i password  # find generated password
```

## Common Tasks

### Check service status
```bash
systemctl status smb jellyfin qbittorrent-nox@root
```

### Fix media permissions
```bash
chown -R nobody:nobody /srv/media
chmod -R 777 /srv/media
```

### Durable permissions (default ACLs) — "can't move/delete folders over Samba"
**Symptom**: from berni's desktop, some folders can't be moved, renamed, or deleted.
**Cause**: Samba's `force user = nobody` + `create mask 0777` only cover files created *through the share*. Content created *directly on the server as root* (qBittorrent downloads, `yay` builds, manual root ops) lands as `root:root 755`, which the guest CIFS mount (mapped to `nobody`) cannot modify.
**Durable fix** (applied 2026-07-21): a **default POSIX ACL** on `/srv/media` so every new file/dir inherits `rwx` for user/group/other regardless of creator:
```bash
chown -R nobody:nobody /srv/media   # normalize existing
chmod -R 777 /srv/media
setfacl -R -m d:u::rwx,d:g::rwx,d:o::rwx /srv/media   # default ACL for future content
```
Verify the default ACL is still present:
```bash
getfacl -d /srv/media           # should list user::rwx group::rwx other::rwx
```
The `+` in `ls -la` (e.g. `drwxrwxrwx+`) confirms an ACL is attached. btrfs mounts with `acl` by default, so no mount-option change is needed.

### Move downloads to media
```bash
mv /root/jellyfin/media/anime/* /srv/media/anime/
```

### Organize series for Jellyfin
```bash
cd "/srv/media/anime/Show Name"
mkdir 'Season 01' 'Season 02'
mv *1x*.mkv 'Season 01/'
mv *2x*.mkv 'Season 02/'
```

### Check disk usage
```bash
df -h
lsblk -f
```

### Fix stale CIFS mount on local machine
If `/mnt/media` shows "Stale file handle" and won't unmount even with `sudo umount -f -l /mnt/media`:
- The kernel has a zombie CIFS mount from when Samba was down
- `lsof`, `fuser`, `umount -f`, `umount -l` all fail
- **Only fix: reboot the local machine** — fstab remounts it cleanly on startup

### Mount media disk (sda1)
```bash
mount /dev/sda1 /srv/media
```

fstab entry for persistence:
```
UUID=b550d84c-978e-4cc9-b180-046af558787a  /srv/media  btrfs  rw,relatime,compress=zstd:3,space_cache=v2  0 0
```

## Installed Packages of Note
- `docker`, `docker-compose`
- `samba`
- `qbittorrent-nox`
- `networkmanager`
- `openssh`
- `neovim` + LazyVim
- `eza` (ls replacement with icons)
- **`rsync` is NOT installed** — use `cp -a` for copying files
- **`parted` is NOT installed** — use `fdisk` for partitioning

## Notes
- SSH root login enabled (`PermitRootLogin yes`, `PasswordAuthentication yes`)
- systemd-networkd configured for `enp2s0`
- zram swap active (3.8G)
- Cockpit web console available at port 9090
- `/var/log` is on sdb2 — if disk is full, log to `/tmp` instead (tmpfs, always has space)
- Jellyfin config at `/root/jellyfin/config/` (~434MB total, 373MB metadata)

## Media Structure (actual, as of 2026-06-06)
```
/srv/media/
├── animeMovies/
├── animeShows/
├── books/
├── drama/
├── manga/
├── movies/
├── music/
└── series/
```
