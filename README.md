# Kubernetes Traefik LoadBalancer Docker

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

## Estructura del Proyecto

```
kubernetes-traefik-loadbalancer-docker/
├── inventory/
│   └── hosts.ini                # Archivo de inventario para Ansible
├── templates/
│   ├── acme.json                # Archivo preconfigurado para Let's Encrypt
│   ├── docker-compose.yml.j2    # Plantilla para Docker Compose
│   └── traefik.toml.j2          # Plantilla para la configuración de Traefik
└── install_traefik.yml          # Playbook principal para configurar Traefik
```

## Instalación y Uso

1. **Clonar el Repositorio**:

   ```bash
   git clone https://github.com/vhgalvez/kubernetes-traefik-loadbalancer-docker.git
   cd kubernetes-traefik-loadbalancer-docker
   ```

2. **Configurar el Inventario**:

   Edita el archivo `inventory/hosts.ini` para incluir los detalles del nodo `loadbalancer1`.

   ```ini
   [loadbalancer]
   loadbalancer1 ansible_host=10.17.3.12 ansible_user=core ansible_ssh_private_key_file=/ruta/a/tu/clave_privada
   ```

3. **Ejecutar el Playbook**:

   Usa el siguiente comando para instalar y configurar Traefik:

   ```bash
   sudo ansible-playbook -i inventory/hosts.ini install_traefik.yml
   ```
# 1️⃣ Generar certificados
sudo ansible-playbook generate_certs.yml

# 2️⃣ Instalar y configurar Traefik con los certificados
sudo ansible-playbook -i inventory/hosts.ini install_traefik.yml


4. **Verificar el Estado de Traefik**:

   Una vez finalizada la ejecución, accede al dashboard de Traefik para verificar la configuración:

   ```
   http://loadbalancer1.cefaslocalserver.com:8080/dashboard/
   ```

## Personalización

- **Configuración de Traefik**:
  Modifica las plantillas en `templates/traefik.toml.j2` y `templates/docker-compose.yml.j2` según tus necesidades.

- **Certificados SSL**:
  Asegúrate de configurar correctamente el email para Let's Encrypt en `traefik.toml.j2`.

## Contribuciones

¡Las contribuciones son bienvenidas! Si encuentras algún problema o tienes sugerencias de mejora, abre un issue o envía un pull request.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT. Consulta el archivo LICENSE para más detalles.

## Autor

Desarrollado por [Victor Gálvez](https://github.com/vhgalvez) como parte de la implementación de entornos Kubernetes altamente escalables y gestionados.


Error de resolución DNS: Si whoami.localhost no se resuelve, añade esta entrada al archivo /etc/hosts en tu máquina cliente:

plaintext
Copiar código
10.17.3.12 whoami.localhost


