# 🦕 AliArkCluster – Docker Cluster for ARK: Survival Evolved

> Docker image for running a clustered ARK: Survival Evolved server using ARK Server Tools.

This project provides a production-ready Docker setup for managing single or multi-map ARK clusters with automatic installation, mod management, scheduled updates/backups, clean shutdown handling, and optional beta branch + custom Steam API support.

---

## ✨ Features

- No manual `steamcmd` setup required
- Full [ARK Server Tools](https://github.com/FezVrasta/ark-server-tools) integration
- Clean `docker stop` handling
- Cron-based auto updates
- Cron-based backups
- Persistent cluster sharing
- Optional beta branch installation (`ARK_BRANCH`)
- Optional custom Steam API injection (`COPY_STEAM_API`)

---

## 🐳 Pull Latest Image

Always pull the latest version before deploying:

```bash
docker pull alisadco/aliarkcluster:latest
```

---

## 🚀 Recommended Docker Compose

Below is the recommended configuration using hardcoded Steam API injection from `/api`, beta branch support (`preaquatica`), and host-mounted persistent storage.

```yaml
services:
  island:
    image: alisadco/aliarkcluster:latest
    deploy:
      mode: global
    environment:
      CRON_AUTO_UPDATE: "0 */3 * * *"
      CRON_AUTO_BACKUP: "0 */1 * * *"
      UPDATEONSTART: 0
      BACKUPONSTART: 1
      BACKUPONSTOP: 1
      WARNONSTOP: 1
      USER_ID: 7774
      GROUP_ID: 7774
      TZ: "ET"
      MAX_BACKUP_SIZE: 500
      SERVERMAP: "TheIsland"
      SESSION_NAME: "Alisadco ARK Cluster TheIsland"
      MAX_PLAYERS: 15
      RCON_ENABLE: "True"
      QUERY_PORT: 15000
      GAME_PORT: 15002
      RCON_PORT: 15003
      SERVER_PVE: "True"
      SERVER_PASSWORD: "123123"
      ADMIN_PASSWORD: "adminTheIsland123"
      SPECTATOR_PASSWORD: "spectatorTheIsland123"
      CLUSTER_ID: "alisadco"
      GAME_USERSETTINGS_INI_PATH: "/cluster/alisadco.GameUserSettings.ini"
      GAME_INI_PATH: "/cluster/alisadco.Game.ini"
      KILL_PROCESS_TIMEOUT: 300
      COPY_STEAM_API: 1
      ARK_BRANCH: preaquatica
    volumes:
      - /mnt/ssd/apps/ark/data_island:/ark
      - /mnt/ssd/apps/ark/cluster:/cluster
      - /mnt/ssd/apps/ark/api:/api
    ports:
      - "15000-15003:15000-15003/udp"
```

---

## 💉 Steam API Injection (Optional)

When `COPY_STEAM_API=1`, the container copies the following files at startup:

| Source | Destination |
|--------|-------------|
| `/api/libsteam_api.so` | `/ark/server/ShooterGame/Binaries/Linux/` |
| `/api/libsteam_api_o.so` | `/ark/server/ShooterGame/Binaries/Linux/` |

This allows you to inject a custom wrapper, control the Steam API from the host, and update without rebuilding the image. Your `/api` directory is host-mounted:

```
/mnt/ssd/apps/ark/api  →  /api
```

---

## 🔀 Beta Branch Support

| Mode | Configuration |
|------|--------------|
| Stable (default) | Remove `ARK_BRANCH` |
| Beta branch | Set `ARK_BRANCH` to desired branch (e.g., `preaquatica`) |

The container automatically installs and updates using:

```bash
arkmanager install --beta=<branch>
```

---

## 📁 Volume Structure

### `/ark` — Main Server Working Directory

| Path | Description |
|------|-------------|
| `/ark/server` | Game files |
| `/ark/log` | Server logs |
| `/ark/backup` | Backups |
| `/ark/staging` | Download-only staging |
| `/ark/arkmanager.cfg` | ARK Server Tools config |

### `/cluster` — Shared Cluster Directory

Shared between all maps in your cluster. Contains:

```
/cluster/<clusterid>.Game.ini
/cluster/<clusterid>.GameUserSettings.ini
```

These files are copied into each server on every startup.

### `/api` — Steam API Injection Directory

Host-controlled directory containing:

```
libsteam_api.so
libsteam_api_o.so
```

---

## ⚙️ How It Works

```
1. Container starts
2. ARK Server Tools checks installation
3. Game installs or updates
4. Optional Steam API injection runs
5. Server launches
6. Cron jobs handle updates and backups
```

---

## 🗺️ Adding More Maps

To expand your cluster, duplicate the service block and change the following:

- `SERVERMAP`
- Port mappings
- Volume mount for `/ark`

Keep the **same** `CLUSTER_ID` and **share** the same `/cluster` volume across all services.

---

## ⚠️ Important Notes

- Always mount `/ark` to persistent storage
- Always mount `/cluster` for clustered dino/character travel
- **Do not** reuse the same `/ark` volume across different maps
- Always pull the latest image before updating your cluster

---

## 📜 License

This project is maintained by [alisadco](https://hub.docker.com/r/alisadco/aliarkcluster).
