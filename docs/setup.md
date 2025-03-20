




sudo ansible-playbook -i inventory/hosts.ini generate_certs.yml
sudo ansible-playbook -i inventory/hosts.ini install_PyPy.yml
sudo ansible-playbook -i inventory/hosts.ini install_kubectl_and_kubeconfig.yml
sudo ansible-playbook -i inventory/hosts.ini install_traefik.yml
