




sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/generate_certs.yml

sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_PyPy.yml

sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_kubectl_and_kubeconfig.yml

sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_haproxy_keepalived.yml

sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_traefik.yml


```bash
sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/generate_certs.yml \
&& sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_PyPy.yml \
&& sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_kubectl_and_kubeconfig.yml \
&& sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_haproxy_keepalived.yml \
&& sudo ansible-playbook -i inventory/hosts.ini ansible/playbooks/install_traefik.yml
```
