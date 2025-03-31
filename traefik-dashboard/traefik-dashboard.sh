#!/bin/bash

# Script para exponer el dashboard de Traefik localmente
# a través de túnel SSH en segundo plano (background)

REMOTE_USER=core
REMOTE_IP=10.17.3.12
SSH_KEY="/home/victory/.ssh/id_rsa_key_cluster_openshift"
LOCAL_PORT=8080
REMOTE_PORT=8080
PID_FILE="/tmp/traefik_tunnel.pid"

echo "⬆️ Abriendo túnel SSH en segundo plano (localhost:$LOCAL_PORT → $REMOTE_IP:$REMOTE_PORT)..."

# Verifica si ya hay un túnel activo
if [ -f "$PID_FILE" ] && kill -0 $(cat "$PID_FILE") 2>/dev/null; then
  echo "🟡 Ya hay un túnel SSH activo en localhost:${LOCAL_PORT} (PID: $(cat $PID_FILE))"
else
  ssh -i "$SSH_KEY" -N -L ${LOCAL_PORT}:127.0.0.1:${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_IP} &
  echo $! > "$PID_FILE"
  echo "✅ Túnel SSH iniciado en segundo plano (PID: $(cat $PID_FILE))"
fi

echo "🌐 Puedes acceder al dashboard en: http://localhost:${LOCAL_PORT}/dashboard/"