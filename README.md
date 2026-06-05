## Configuration Nginx pour servire plusieurs sites Web avec 1 seul serveur

**Basé sur le Header HTTP (host)**
Nous avons ici un exemple de configuration pour avoir un serveur nginx multi-sites. Il ne faut pas oublié côté client d'avoir des entrées DNS correspondantes aux noms de domaines utilisés sinon sa ne marchera pas.
Sur Linux on peut modifier `/etc/hosts`:
```bash
10.0.1.93  admin.local blog.local shop.local
```

exemple d'utilisation côté client:
curl http://admin.local/
