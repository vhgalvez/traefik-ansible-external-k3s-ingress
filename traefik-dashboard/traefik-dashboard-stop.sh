#!/bin/bash

# Script para cerrar el túnel SSH del dashboard de Traefik
PID_FILE="/tmp/traefik_tunnel.pid"

echo "🔌 Cerrando túnel SSH del dashboard de Traefik..."

if [[ -f "$PID_FILE" ]]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null; then
        kill "$PID" && echo "✅ Túnel SSH detenido (PID: $PID)"
    else
        echo "⚠️ No se encontró un proceso activo con PID $PID."
    fi
    rm -f "$PID_FILE"
else
    echo "❌ No se encontró un túnel activo (PID file no existe)."
fi