# Acceso seguro al dashboard de Traefik mediante SSH

Este documento describe paso a paso cómo acceder al dashboard de Traefik de forma segura usando un túnel SSH y evitando su exposición pública. Ideal para entornos de desarrollo, pruebas o administración remota segura.

---

## 1. Crear el script de conexión

Escribe un script que cree el túnel SSH para acceder al dashboard en `http://localhost:8080/dashboard/`.  
El script debe establecer un reenvío de puertos local desde tu máquina física al servidor donde corre Traefik.

Ejemplo de script (`traefik-dashboard-start.sh`):

```bash
#!/bin/bash

# Configuración del túnel SSH
ssh -N -L 8080:localhost:8080 usuario@servidor_remoto &
echo "Túnel SSH establecido. Accede al dashboard en http://localhost:8080/dashboard/"
```

---

## 2. Hacer el script ejecutable y moverlo a `~/bin`

1. Dale permisos de ejecución al script:

   ```bash
   chmod +x traefik-dashboard-start.sh
   ```

2. Mueve el script a tu carpeta personal `~/bin`:

   ```bash
   mv traefik-dashboard-start.sh ~/bin/
   ```

---

## 3. Crear un alias persistente

Edita tu archivo `~/.bashrc` (o `~/.bash_aliases` si lo usas) y agrega el siguiente alias:

```bash
alias traefik-dashboard="~/bin/traefik-dashboard-start.sh"
```

Esto te permitirá ejecutar el script con solo escribir `traefik-dashboard` en la terminal.

---

## 4. Recargar el entorno de terminal

Recarga tu configuración de terminal para que el alias quede disponible inmediatamente, sin necesidad de cerrar sesión:

```bash
source ~/.bashrc
```

---

## 5. Acceder al dashboard

Ejecuta el comando para iniciar el túnel SSH:

```bash
traefik-dashboard
```

Luego, abre tu navegador y accede al dashboard desde:

[http://localhost:8080/dashboard/](http://localhost:8080/dashboard/)

---

## 6. Detener el túnel SSH

Para detener el túnel cuando no lo necesites, puedes crear otro script (por ejemplo, `traefik-dashboard-stop.sh`) que mate el proceso SSH correspondiente:

Ejemplo de script (`traefik-dashboard-stop.sh`):

```bash
#!/bin/bash

# Detener el túnel SSH
pkill -f "ssh -N -L 8080:localhost:8080"
echo "Túnel SSH detenido."
```

Dale permisos de ejecución y muévelo a `~/bin` como hiciste con el script anterior:

```bash
chmod +x traefik-dashboard-stop.sh
mv traefik-dashboard-stop.sh ~/bin/
```

---

## 7. Seguridad

⚠️ **Importante:** El dashboard de Traefik **no debe exponerse públicamente a Internet**.  
Esta técnica de reenvío de puertos por SSH garantiza que solo los usuarios autorizados, que tengan acceso por clave SSH, puedan verlo desde su propia máquina.

Con este método, mantienes tu infraestructura segura mientras tienes acceso al dashboard para monitoreo y administración.