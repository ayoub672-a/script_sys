# Playbook pour l'installation de packages Linux Debian/RedHat

## Utilisation
```bash
ansible-playbook install/install.yaml -e '{"package_install":['nginx','postgresql','sysstat']}' -i swap/inventory.yaml
```
