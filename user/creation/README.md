# Playbook pour automatiser la création d'utilisateur sur Linux

## Playbook

Créer un ou plusieurs utilisateurs avec les différents paramètres possibles, les variables sont à spécifier dans **vars/users.yaml.**

## Password compte

Les mots de passes sont à spécifier dans le fichier var/secrets.yaml, ils doivent impéativement être stocké dans un vault.
```bash
ansible-vault create vars/secrets.yaml
# On met le mot de passe du vault dans vars/.vault_password
```

## Déploiement

```bash
ansible-playbook -i inventory.yaml --vault-password-file vars/.vault_password
```

