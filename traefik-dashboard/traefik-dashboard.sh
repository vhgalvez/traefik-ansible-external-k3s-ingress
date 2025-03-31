#!/bin/bash

echo "🔐 Conectando al dashboard de Traefik en loadbalancer1 (10.17.3.12)..."
echo "🌐 Abre en tu navegador: http://localhost:8080/dashboard/"
echo "🛑 Para salir, presiona Ctrl+C cuando ya no lo necesites."

sudo ssh -i /home/victory/.ssh/id_rsa_key_cluster_openshift -L 8080:127.0.0.1:8080 core@10.17.3.12
