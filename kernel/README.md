# Playbook pour modification de valeur de paramètre kernel

## Prérequis

```bash
ansible-galaxy collection install ansible.posix
```

## Valeur dans le fichier vars/parameters.yaml

Préciser dans le fichier vars/parameters.yaml:
** name: nom du paramètre kernel par exemple vm.swappiness (faire un sysctl -a | grep ... si on est pas sûr)
** value: la nouvelle valeur que l'on souhaite donné
