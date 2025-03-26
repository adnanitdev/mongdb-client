#!/bin/bash

set -e

CHART_NAME="mongo-backup-restore"
RELEASE_NAME="mongo-job"
NAMESPACE="default"
RESTORE_NAMESPACE=$(yq '.restore.namespace' values.yaml)

echo "[1] Deploying Helm chart..."
helm upgrade --install $RELEASE_NAME . --namespace $NAMESPACE --create-namespace

echo "[2] Waiting for dump pod to be ready..."
kubectl wait --for=condition=Ready pod/mongo-dump --timeout=120s -n $NAMESPACE

echo "[3] Copying dump from mongo-dump pod..."
kubectl cp $NAMESPACE/mongo-dump:/dump ./dump

echo "[4] Copying dump to mongo-restore pod..."
kubectl cp ./dump mongo-restore:/dump -n $RESTORE_NAMESPACE

echo "[5] Restoring dump to destination MongoDB..."
kubectl exec -it mongo-restore -n $RESTORE_NAMESPACE -- \
  mongorestore -v --uri="$(yq '.restore.uri' values.yaml)" \
  --drop /dump --batchSize=100 --numInsertionWorkersPerCollection=4 --maintainInsertionOrder

echo "✅ MongoDB dump and restore completed."
