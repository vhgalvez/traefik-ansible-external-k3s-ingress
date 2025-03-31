 Hazlo ejecutable y muévelo a ~/bin
bash
Copiar
Editar
chmod +x ~/traefik-dashboard.sh
mv ~/traefik-dashboard.sh ~/bin/
✅ 2. Agrega un alias persistente en ~/.bashrc o ~/.bash_aliases
Edita tu archivo .bashrc:

bash
Copiar
Editar
nano ~/.bashrc
Y agrega al final:

bash
Copiar
Editar
alias traefik-dashboard="~/bin/traefik-dashboard.sh"
Luego recarga el shell:

bash
Copiar
Editar

source ~/.bashrc

🧪 Ahora puedes usarlo así:
bash
Copiar
Editar
source ~/.bashrc

traefik-dashboard
Y se abrirá el túnel SSH en background, accediendo al dashboard por:

bash
Copiar
Editar
http://localhost:8080/dashboard/
