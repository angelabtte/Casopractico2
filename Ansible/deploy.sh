#!/bin/bash

echo "Iniciando despliegue con Ansible"

# Verificar si se proporciona una contrasena de Ansible Vault
if [ -z "$1" ]; then
  echo "No se ha proporcionado contraseña de Ansible Vault. Ejecutando sin vault..."
  ansible-playbook -i inventory/hosts.ini playbook.yml
else
  echo "Usando contraseña de Ansible Vault..."
  ansible-playbook -i inventory/hosts.ini playbook.yml --ask-vault-pass
fi

echo "Despliegue finalizado."
