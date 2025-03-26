# MongoDB Backup & Restore Helm Chart

This Helm chart automates the process of MongoDB backup (using `mongodump`) and restore (using `mongorestore`) between two MongoDB instances.

## 📁 Project Structure

```
mongo-backup-restore/
├── templates/
│   ├── mongo-dump-pod.yaml       # Pod that performs mongodump
│   └── mongo-restore-pod.yaml    # Pod used for restoring data
├── values.yaml                   # Source and destination MongoDB URIs
├── Chart.yaml                    # Helm chart definition
├── deploy-mongo-backup-restore.sh # Bash script to automate the process
```

## 🔧 Configuration

Edit the `values.yaml` file to specify the source and destination MongoDB connection strings:

```yaml
source:
  uri: "mongodb://<user>:<password>@<source-host>:27017/"

restore:
  namespace: "ferretdb"
  uri: "mongodb://<user>:<password>@<target-host>:27017/?socketTimeoutMS=300000&connectTimeoutMS=300000"
```

## 🚀 Usage

1. Make sure `helm`, `kubectl`, and `yq` are installed.
2. Deploy and run the backup/restore process:

```bash
chmod +x deploy-mongo-backup-restore.sh
./deploy-mongo-backup-restore.sh
```

## 📝 Notes

- The dump pod writes data to `/dump` and keeps running so you can copy files.
- The restore pod just runs with mongodb client to connect to target database later and dump the data.
- You can extend this with Kubernetes Jobs for fully automated lifecycle.

## 📦 Requirements

- Helm 3+
- Kubernetes cluster
- MongoDB access
- `yq` installed (`brew install yq` or `apt install yq`)
