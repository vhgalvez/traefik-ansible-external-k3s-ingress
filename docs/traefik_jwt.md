# 📅 Documentación: Configuración del token JWT de Traefik

Esta documentación describe el proceso completo y automatizado para:

- Crear un ServiceAccount para Traefik en Kubernetes
- Generar un token JWT moderno
- Montar un volumen NFS persistente desde el nodo de almacenamiento (`storage1`)
- Guardar el token de forma segura en un volumen compartido

---

## 🔑 Token JWT de Traefik - Propósito

El token JWT es necesario para que Traefik pueda autenticarse con la API de Kubernetes como `Ingress Controller`. Este token se asocia a un ServiceAccount con permisos adecuados (`cluster-admin`).

---

## 🏠 Nodo storage1 - Preparación del volumen NFS

Desde el nodo de almacenamiento (`10.17.4.27`):

1. Se crea la carpeta:
```bash
mkdir -p /srv/nfs/traefik-token
```

2. Se asegura la exportación en `/etc/exports`:
```bash
/srv/nfs/traefik-token 10.17.3.0/24(rw,sync,no_subtree_check)
```

3. Se aplica la exportación:
```bash
exportfs -rav && systemctl restart nfs-server
```

---

## 🚧 Nodo load_balancer - Montaje del token

1. Se crea el directorio de montaje:
```bash
mkdir -p /mnt/traefik-token
```

2. Se monta el NFS desde `storage1`:
```bash
mount -t nfs 10.17.4.27:/srv/nfs/traefik-token /mnt/traefik-token
```

Esto permite acceder al token JWT desde un volumen persistente accesible por Traefik.

---

## ⚖️ Kubernetes (desde master1) - Creación del ServiceAccount y Token

1. Se borra configuración previa (si existía):
```bash
kubectl delete sa traefik-sa -n default --ignore-not-found
kubectl delete clusterrolebinding traefik-sa-crb --ignore-not-found
```

2. Se crea el ServiceAccount:
```bash
kubectl create sa traefik-sa -n default
```

3. Se vincula al rol cluster-admin:
```bash
kubectl create clusterrolebinding traefik-sa-crb \
  --clusterrole=cluster-admin \
  --serviceaccount=default:traefik-sa
```

4. Se genera el token JWT moderno:
```bash
kubectl -n default create token traefik-sa
```

---

## 📁 Almacenamiento del Token JWT

1. Se guarda en `/mnt/traefik-token/traefik.jwt` (accesible por Traefik):
```bash
echo "$TOKEN" > /mnt/traefik-token/traefik.jwt
```

2. Se guarda una copia en el nodo `storage1`:
```bash
echo "$TOKEN" > /srv/nfs/traefik-token/traefik.jwt
```

---

## 📊 Resultado Final

- El token está disponible para Traefik en `/mnt/traefik-token/traefik.jwt`
- El volumen persistente está montado mediante NFS desde `storage1`
- El ServiceAccount tiene acceso completo para gestionar recursos Ingress en Kubernetes
- El sistema está preparado para reinicios automáticos y reusabilidad del token

---

## 💡 Recomendaciones

- Protege el archivo `traefik.jwt` con permisos `0600`
- Revisa periódicamente que el montaje NFS esté activo
- Asegura que el token no se expone por error en logs o backups
- Usa el `token` generado para construir un `kubeconfig` para Traefik si se desea

---

## 🚀 Automatización completa

Todo el proceso anterior está automatizado en el playbook:

```
playbooks/install_traefik.yml
```

Incluye:
- Creación de ServiceAccount
- Generación del token JWT
- Exportación NFS desde storage1
- Montaje de volumen
- Almacenamiento seguro del token
- Creación de kubeconfig personalizado para Traefik
- Despliegue con docker-compose

---

## 📂 Resultado final

| Nodo         | Carpeta creada                | ¿Exportada vía NFS? | ¿Token se guarda aquí? |
|--------------|-------------------------------|-----------------------|--------------------------|
| `storage1`   | `/srv/nfs/traefik-token`      | ✅ Sí               | ✅ Sí                  |
| `load_balancer` | `/mnt/traefik-token` (NFS) | ➖ Montaje NFS       | ✅ Sí (vía copia)      |

---

## 📘️ Conclusión

Este playbook está correctamente preparado para:

- Crear la carpeta del token en storage1.
- Configurarla como exportación NFS.
- Montarla automáticamente en cada balanceador de carga.
- Generar y guardar el `traefik.jwt` desde master1.
- Dejarlo disponible tanto en `storage1` como en los balanceadores de carga.