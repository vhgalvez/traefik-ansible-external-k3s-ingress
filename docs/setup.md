

```bash

sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_traefik.yml && \
sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/generate_certs.yml

```
