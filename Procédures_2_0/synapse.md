# Installation de Synapse

## Installation du paquet sous debian 

Pour installer **synapse** sous debian : 

```console
user@<nom_vm>$ sudo apt install -y lsb-release wget apt-transport-https

user@<nom_vm>$ sudo wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg

user@<nom_vm>$ echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" |
         sudo tee /etc/apt/sources.list.d/matrix-org.list

user@<nom_vm>$ sudo apt update

user@<nom_vm>$ sudo apt install matrix-synapse-py3 
```

Pour la dernière ligne de commande, il faudra rentrer le nom de la machine : `<machine_de_virtu>.iutinfo.fr:8008`

## Paramétrage

### Trusted Keys Servers 

Nous devons changer la configuration par défaut de synapse, car le service n'est pas accessible à l'exterieur. 

Dans le  fichier : 

`/etc/matrix-synapse/homeserver.yaml`

il faut modifier la ligne : 

```text
trusted_keys_servers
server-name: "matrix.org"
```

par 

```text
trusted_key_servers: []
```
### PostGreSQL

Nous allons nous connecter au compte `postgres` : 

```console
user@<nom_vm>$ sudo su - postgres
```

Une fois connecté au compte postgres, nous allons reccréer la base de données pour qu'elle puisse être utilisée avec synapse : 

```console
postgres@<nom_vm>$ dropdb <ancien_nom_db>
postgres@<nom_vm$ createdb --encoding=UTF-8 --locale=C --template=template0 --owner=<nom_user> <nom_db>
```

On doit aussi modifier le fichier permettant sa configuration : 

``/etc/matrix-synapse/homeserveur.yaml``

On doit commenter ces lignes : 
```yaml
# database:
#  name: sqlite3
#  args:
#  database: /var/lib/matrix-synapse/homeserver.db
```

et ajouter celles-ci : 

```yaml
database:
  name: psycopg2
  args:
    user: matrix
    password: matrix
    database: matrix
    host: localhost
    cp_min: 5
    cp_max: 10
```


Ensuite pour que les modifications soient prises en compte nous allons **redémarrer le service** avec la commande : 

```console
user@<nom_vm>$ sudo systemctl restart synapse-matrix.service
```

Nous pouvons vérifier que l'opération à bien fonctionnée en nous connectant au compte matrix de postegresql à l'aide de la commande 

```console
user@<nom_vm>$ psql -U  matrix -h localhost matrix 
```

et effectuer un `\d` afin de vérifier que plusieurs tables ont étés créées.


#### Création d'utilisateurs

Dans le fichier : 

> /etc/matrix-synapse/homerserver.yaml

On rajoute 

> registration_shares_secret: "matrix"

Redémarrer le serveur synapse pour tenir compte des modifications

```console
user@<nom_vm>$ sudo systemctl restart matrix-synapse
```

Afin de définir les deux utilisateurs nous utiliserons les commandes : 

```console
user@<nom_vm>$ register_new_matrix_user -u <nom1> -p <password1> -c /etc/matrix-synapse/homersever.yaml -a
user@<nom_vm>$ register_new_matrix_user -u <nom2> -p <password2> -c /etc/matrix-synapse/homeserver.yaml -a
```

#### Connexion au serveur 

### Avoir la possibilité d'ajouter de créer un compte

Toujours dans le fichier `/etc/matrix-synapse/homeserver.yaml`, on peut ajouter ces deux lignes pour pouvoir donner la possibilité aux utilisateurs de créer un compte

```yaml
enable_registration: true
enable_registration_without_verification: true
```

On peut redémarrer le serveur synapse avec la commande `systemctl restart matrix-synapse` (en tant qu'administrateur), et constater qu'on peut bel est bien créer un nouvel utilisateur depuis synapse






