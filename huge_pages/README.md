## Script Bash de mise en place de Huge Pages sur Linux

Le script prend en paramètre la taille en Go que l'on souhaite en Huge Pages. C'est notemment utilisé, pour la SGA d'Oracle.


## Playbook pour mise en place de Huge Pages sur Linux

Le playbook est à lancer depuis une Vm d'admin et permet via un inventory d'allouer sur des machines clientes le nombre de Huge Pages que l'on souhaite en Go.
**Nécessaire d'avoir: ansible-galaxy collection install ansible.posix**

