AliArkCluster – Docker Cluster for ARK: Survival Evolved

Docker image for running a clustered ARK: Survival Evolved server using ARK Server Tools.

This project provides a production-ready Docker setup for managing single or multi-map ARK clusters with:

Automatic installation

Mod management via Ark Server Tools

Scheduled updates and backups

Clean shutdown handling

Optional beta branch support

Optional custom libsteam_api.so injection

Features

No manual steamcmd setup required

Full Ark Server Tools integration

Clean docker stop handling

Cron-based auto updates

Cron-based backups

Persistent cluster sharing

Optional beta branch installation (ARK_BRANCH)

Optional custom Steam API injection (COPY_STEAM_API)

Pull Latest Image

Always pull the latest version:

docker pull alisadco/aliarkcluster:latest

Recommended Docker Compose (Current Setup)

Below is the updated compose configuration using:

Hardcoded Steam API injection from /api

Beta branch support (preaquatica)

Host-mounted persistent storage

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

Steam API Injection (Optional)

If COPY_STEAM_API=1, then at container start:

/api/libsteam_api.so
/api/libsteam_api_o.so


are copied into:

/ark/server/ShooterGame/Binaries/Linux/


This allows you to:

Inject a custom wrapper

Control the Steam API from the host

Update without rebuilding the image

Your /api directory is host-mounted:

/mnt/ssd/apps/ark/api → /api

Beta Branch Support

You can install:

Stable (default) – remove ARK_BRANCH

Beta branch – set ARK_BRANCH to the desired branch, e.g., preaquatica

The container will automatically install and update using:

arkmanager install --beta=<branch>

Volume Structure
/ark

Main server working directory:

/ark/server → Game files

/ark/log → Logs

/ark/backup → Backups

/ark/staging → Download-only staging

/ark/arkmanager.cfg → Ark Server Tools config

/cluster

Shared cluster directory between maps:

/cluster/<clusterid>.Game.ini

/cluster/<clusterid>.GameUserSettings.ini

These files are copied on each startup.

/api

Host-controlled Steam API injection directory:

libsteam_api.so

libsteam_api_o.so

How It Works

Container starts

Ark Server Tools checks installation

Game installs or updates

Optional Steam API injection runs

Server launches

Cron jobs handle updates and backups

Adding More Maps

To expand your cluster:

Duplicate the service

Change:

SERVERMAP

Ports

Volume mount for /ark

Keep the same CLUSTER_ID

Share the same /cluster volume

Important Notes

Always mount /ark to persistent storage

Always mount /cluster for clustered travel

Do not reuse the same /ark volume across maps

Pull the latest image before updating your cluster
