# Traefik Kubernetes Ingress Controller con Ansible

Este repositorio contiene configuraciones y scripts para implementar y gestionar un balanceador de carga eficiente basado en **Traefik** utilizando **Docker Compose** dentro de un entorno Kubernetes. El objetivo principal es facilitar la instalación y configuración de **Traefik** como proxy inverso y balanceador de carga en un nodo dedicado (`loadbalancer1`), optimizado para gestionar nodos maestros, trabajadores y otros servicios de red.

## Características

- **Balanceador de Carga**: Implementación de Traefik para gestionar el tráfico hacia los nodos del clúster Kubernetes.
- **Proxy Inverso**: Soporte para enrutar peticiones a servicios específicos dentro del clúster.
- **Configuración Modular**: Incluye plantillas para archivos de configuración (`traefik.toml` y `docker-compose.yml`).
- **Compatibilidad con Certificados SSL**: Integración de Let’s Encrypt para certificados automáticos.
- **Gestión Simplificada**: Uso de Ansible para instalar y configurar todo el entorno.

## Requisitos Previos

Antes de usar este repositorio, asegúrate de cumplir con los siguientes requisitos:

1. **Nodo LoadBalancer**:
   - Rocky Linux 9 o equivalente.
   - Conexión SSH habilitada.
   - Docker y Docker Compose instalados (el repositorio incluye su instalación automatizada).
   
2. **Clúster Kubernetes**:
   - Nodos maestros y trabajadores configurados.
   - Servicio DNS en funcionamiento (por ejemplo, FreeIPA).

3. **Dependencias**:
   - Ansible instalado en tu máquina de control.
   - Acceso SSH configurado hacia el nodo `loadbalancer1`.

## Instalación y Uso

1. **Clonar el Repositorio**:

   ```bash
   sudo git clone https://github.com/vhgalvez/kubernetes-infra-automation.git
   cd kubernetes-infra-automation
   ```

2. **Configurar el Inventario**:

   Edita el archivo `inventory/hosts.ini` para incluir los detalles del nodo `loadbalancer1` y otros nodos relevantes.

   ```ini
   [loadbalancer]
   loadbalancer1 ansible_host=10.17.3.12 ansible_user=core ansible_ssh_private_key_file=/ruta/a/tu/clave_privada
   loadbalancer2 ansible_host=10.17.3.13 ansible_user=core ansible_ssh_private_key_file=/ruta/a/tu/clave_privada
   ```

3. **Ejecutar el Playbook**:

   Usa el siguiente comando para instalar y configurar Traefik:

   ```bash
   sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install.yml
   ```


### 2️⃣ Instalar y Configurar Traefik con los Certificados

Una vez que los certificados estén listos, puedes instalar y configurar **Traefik** con el siguiente playbook:

```bash
sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_traefik.yml
```
### Resetear el entorno de Traefik


Si necesitas reiniciar el entorno de Traefik, puedes usar el siguiente comando:

```bash
sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/reset_traefik_env.yml
```

### 3️⃣ Verificar el Estado de Traefik

Una vez finalizada la ejecución, accede al dashboard de Traefik para verificar la configuración:

```
http://loadbalancer1.cefaslocalserver.com:8080/dashboard/
```

## Personalización

- **Configuración de Traefik**:
  Modifica las plantillas en `templates/traefik.toml.j2` y `templates/docker-compose.yml.j2` según tus necesidades.

- **Certificados SSL**:
  Asegúrate de configurar correctamente el email para Let's Encrypt en `traefik.toml.j2`.

## Problemas de Resolución DNS

Si `whoami.localhost` no se resuelve, añade esta entrada al archivo `/etc/hosts` en tu máquina cliente:

```plaintext
10.17.3.12 whoami.localhost
```

---

## Traefik jwt token

[Traefik jwt token](https://github.com/vhgalvez/traefik-k8s-ingress-controller-ansible/blob/main/docs/traefik_jwt.md)


---

## Traefik dashboard

![Traefik dashboard](docs/Traefik_dashboard.png)


### Playbook de Ansible traefik instalacion OK

![certifcados](docs/certifcados.png)


![Infraestructura Kubernetes](docs/install_traefik.png)

---

### Diagrama de la Infraestructura de Balanceo de Carga controlador de Ingress

![Infraestructura Kubernetes](docs/ingress.png)


```bash
                     +-------------------------------------------------+
                     | HAProxy + Keepalived (k8s-api-lb VM)            |
                     | IP real: 10.17.5.20                             |
                     | IP virtual (VIP API Server): 10.17.5.10:6443    |
                     +-------------------------------------------------+
                                          |
                                          v
                        +-----------------+-------------------+
                        |                 |                   |
                        v                 v                   v
            +---------------+   +---------------+   +---------------+
            | Master Node 1 |   | Master Node 2 |   | Master Node 3 |
            |  (etcd+k3s)   |   |  (etcd+k3s)   |   |  (etcd+k3s)   |
            | 10.17.4.21    |   | 10.17.4.22    |   | 10.17.4.23    |
            +---------------+   +---------------+   +---------------+

 (Kubernetes API Server puerto 6443)───────────────────────────┐
                                                               │
───────────────────────────────────────────────────────────────┼────────────────
                                                               │ (Consulta API)
                                                               v
                  +----------------------------+-----------------------------+
                  |                                                          |
                  v                                                          v
      +-------------------------+                               +-------------------------+
      | Load Balancer 1 Traefik |                               | Load Balancer 2 Traefik |
      |    IP: 10.17.3.12       |                               |    IP: 10.17.3.13       |
      | (Ingress Controller)    |                               | (Ingress Controller)    |
      +-------------------------+                               +-------------------------+
                  |                                                          |
                  v                                                          v
      +---------------------------------------------------------------+
      |                 Worker Nodes Kubernetes                       |
      |                 IP: 10.17.4.24 / 25 / 26 / 27                 |
      +---------------------------------------------------------------+
```

## Descripción de Nodos Externos Balanceadores

En algunos casos, es posible que desees conectar balanceadores de carga externos al clúster Kubernetes. Estos balanceadores externos no pueden comunicarse directamente con los pods dentro del clúster debido a que están fuera del entorno de red del clúster. Para habilitar esta comunicación, es necesario realizar una configuración especial que permita enrutar el tráfico desde los balanceadores externos hacia los pods.

### Configuración Requerida

1. **Habilitar el Acceso Externo**:
   - Configura reglas de firewall para permitir el tráfico desde los balanceadores externos hacia los nodos del clúster.
   - Asegúrate de que los puertos necesarios estén abiertos (por ejemplo, el puerto 6443 para el API Server y los puertos utilizados por los servicios expuestos).

2. **Configurar Servicios con `NodePort` o `LoadBalancer`**:
   - Utiliza servicios de tipo `NodePort` o `LoadBalancer` para exponer los pods a través de los nodos del clúster.
   - Por ejemplo, puedes definir un servicio de tipo `NodePort` en el archivo YAML del servicio:

     ```yaml
     apiVersion: v1
     kind: Service
     metadata:
       name: mi-servicio
     spec:
       type: NodePort
       selector:
         app: mi-aplicacion
       ports:
         - protocol: TCP
           port: 80
           targetPort: 8080
           nodePort: 30001
     ```

3. **Configurar el Balanceador Externo**:
   - Configura el balanceador externo para enrutar el tráfico hacia las IPs de los nodos del clúster y los puertos expuestos por los servicios de tipo `NodePort` o `LoadBalancer`.
   - Asegúrate de que el balanceador externo pueda resolver los nombres DNS de los servicios si estás utilizando un servicio DNS interno.

4. **Verificar la Conectividad**:
   - Realiza pruebas para asegurarte de que el balanceador externo puede acceder a los servicios expuestos en el clúster.
   - Puedes usar herramientas como `curl` o `wget` para verificar la conectividad.

### Ejemplo de Configuración

Si tienes un balanceador externo con IP `10.17.6.10` y deseas conectarlo a un servicio expuesto en el clúster, asegúrate de que:

- El servicio en el clúster esté configurado con un `NodePort` accesible, por ejemplo, el puerto `30001`.
- El balanceador externo esté configurado para enrutar el tráfico hacia las IPs de los nodos del clúster (por ejemplo, `10.17.4.24`, `10.17.4.25`, etc.) en el puerto `30001`.

Con esta configuración, el balanceador externo podrá comunicarse con los pods dentro del clúster a través de los nodos y los servicios expuestos.

## Contribuciones

¡Las contribuciones son bienvenidas! Si encuentras algún problema o tienes sugerencias de mejora, abre un issue o envía un pull request.

## Licencia

Este proyecto está licenciado bajo la **Licencia MIT**. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

[Generador de Hash MD5](https://www.md5hashgenerator.com/)

---

/var/lib/rancher/k3s/server/tls/client-admin.crt