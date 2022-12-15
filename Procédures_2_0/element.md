# Element

## Choix du serveur web : Ngix

Nous avons choisi `nginx` plutôt qu'apache car nginx permet de de traiter `plusieurs requêtes sur un seul thread`, et donc de réaliser très rapidement les opérations et de déployer le minimum de ressources.

Ngix est également plus performant quand il s'agit de traiter un contenu statique.

## Installation de Element

Pour installer element, nous nous rendons sur le répertoire github officiel de [Element](https://github.com/vector-im) afin de pouvoir l'installer sur la machine virtuelle. 


```console
user@<nom_vm>$ curl -s https://api.github.com/repos/vector-im/element-web/releases/latest | grep 'browser_download_url.*tar.gz"' | cut -d : -f 2,3 | wget -o element -qi -
```

```console
user@<nom_vm>$ sudo tar -xzvf element -C /var/www/html/
```

Il faut ensuite ajouter dans le fichier `/etc/nginx/sites-available/element`

```text
server {
    listen 8080;
    listen [::]:8080;

    server_name element;
    root /var/www/html/element;
    index index.html welcome.html;

    location / {
        try-files $uri $uri/ =404;
    }
}
```

Il faut donc maintenant créer un lien symbolique afin que `sites-enabled` puisse bénéficier de la même chose : 

```console
user@<nom-vm>$ sudo ln -s /etc/nginx/sties-available/element /etc/nginx/sites-enabled/element
```

```console
user@<nom-vm>$ sudo cp /var/www/html/element/config.sample.json /var/www/html/element/config.json
```

Suite à ça nous devons redémarrer nginx pour que les modifications prennent effet : 

```console
user@<nom-vm>$ sudo systemctl restart nginx
```

Puis l'on vérfie à l'aide de la commande `curl` : 

```console
user@<nom_vm>$ curl localhost:8080
```

Pour accéder à `Element` depuis la machine physique nous devons remplacer la ligne suivante : 

```text
LocalFoward 0.0.0.0:8080 192.168.193.XX:80
```

du fichier `~.ssh/config`

par : 

```text
LocalForward 0.0.0.0:8080 192.168.194.XX.8080
```

La procédure [ssh_commands_alias](./ssh_commands_alias.md) pourrait-être utile pour une bonne visualisation de l'action à faire.