# Procédure N°1 

## Connexion à distance

### Première connexion à la machine de virtualisation 

#### Informations générales et commande de connexion
Pour se connecter à distance sur une machine du réseau de l'IUT, nous utlisons la commande : 

```sh
login@phys$ ssh login@nom_de_la_machine.iutinfo.fr
```

>Où le login correspond à l'identifiant au format nom.prenom.etu et le nom de la machine est celui fourni par les enseignants dans le cours Moodle de la saé.

Lors de la première connexion sur la machine distante, il faudra vérifier si l'empreinte de la machine correspond bien à la clef renseignée sur le cours moodle. 

> Si l'empreinte est la même, tapez **"yes"** dans le terminal comme indiqué.


#### L'empreinte de la machine : conception de la paire de clef

Pour générer une clef qui nous permet de ne pas avoir à entrer nos identifiants à chaque connexion, nous utilisons la commande 

```sh
login@phys$ ssh_keygen
```

Cela va créer un fichier se trouvant en 
> /home/infoetu/maxence.stievenard.etu/.ssh/id_rsa

où nous laisserons le nom du fichier par **défaut**.

Une **passphrase** sera demandée, il faudra la définir et la confirmer.

#### L'empreinte de la machine : transmission de la clef au serveur 

Une fois la clef créée, il faut la diffuser sur le serveur afin d'en profiter depuis l'ensemble des machines, ceci s'eefectue à l'aide de la commande : 

```sh
login@phys$ ssh-copy-id -i $HOME/.ssh/id_rsa.pub machine
```

*où machine est la machine distante (ex frene16).*


## Créer et gérer des machines virtuelles 

Pour accéder à la machine virtuelle, nous avons besoin du script `vmiut` que nous allons ajouter au **bashrc** pour ne pas avoir à l'importer dans chaque nouveau terminal, en y ajoutant la ligne : 

> source /home/public/vm/vm.env

### Création d'une machine virtuelle

Nous pouvons maintenant utiliser le script, ainsi pour créeer une machine virtuelle nous utilisons la commande : 

```sh
login@frene16$ vmiut creer Matrix
```

Il faut maintenant procéder à la vérification

```sh
login@frene16$ vmiut lister
```

Si la machine Matrix est bien présente nous pouvons passer à la suite.

### Démarrage de la machine virtuelle 

Pour démarrer la machine : 

```sh
login@frene16$ vmiut demarrer Matrix
```

### Arrêt et suppression de la machine virtuelle 
Pour arrêter la machine : 

```sh
login@frene16$ vmiut stop Matrix
```

Pour supprimer la machine : 

```sh
login@frene16$ vmiut rm Matrix
```

### Obtenir des informations sur la machine virtuelle

La commande:
 ```sh
 login@frene16$ vmiut info Matrix
 ```
permet de voir les informations et l'état de la machine Matrix. Ainsi, on peut voir si elle est allumée (`etat:running`) ou non, ou même l'adresse ip de la machine se situant à : **ip-possible**


### Utilisation de la machie virtuelle 

#### Console virtuelle 

La première manière est l'utilisation de la machine virtuelle en mode graphique, **une fois la connexion ssh actuelle coupée**, nous allons utiliser la commande: 

```sh
login@phys$ ssh -X frene16
```

puis 

```sh
login@frene16$ vmiut console Matrix
```
(*pensez à vérifier que la machine est bien allumée, si ce n'est pas le cas n'oubliez pas de le faire*)

Une fois sur la console, se connecter à l'aide du login : `root` et du mot de passe : `root`.

#### Changement de la configuration réseau

Nous souhaitons que la machine ait toujours la même adresse IP, dans notre cas : 
> 192.168.14.3

nous devons donc désactiver l'interface enp0s3 (*à partir de root sur la machine virtuelle*) : 

```sh
root@debian$ ifdown enp0s3
```

puis nous allons modifier le fichier suivant : 
> /etc/network/interfaces

en remplaçant : 
> iface enp0s3 inet dhcp

par : 
> iface enp0s3 inet static
    address 192.168.194.3/24
    gateway 192.168.194.2

puis nous allons ensuite réactiver l'interface enp0s3 :

```sh
root@debian$ ifup enp0s3
```

on peut alors constater que les modifications sont bien effectives à l'aide des commandes : 

```sh
root@debian$ ip a show
root@debian$ ip r show
```

qui nous montreront respectivement que l'ip de la machine a été modifiée : 
`inet 192.168.194.3/24 brd 192.168.194.255 scope global enpos`

et que la route par défaut a été définie : 
`default via 192.168.194.2 dev enp0s3 onlink`

Pour que le système prenne en compte les modfications il faut **reboot* la machine : 

```sh
root@debian$ reboot
```

## Configurer et mettre à jour la machine virtuelle 

### Connexion root et ssh

**ssh** ne nous permet pas de nous connecter directement à **root**, nous devons donc passer par **user** : 

```sh
login@frene16$ ssh user@192.168.194.3
```
(*ici on utilisera comme **password user***)

et nous pouvons ainsi nous connecter à root à l'aide de la commande : 

```sh
user@debian$ su -
```

(*ici on utilisera le **password root***)

### Accès extérieur pour les machines virtuelles

Pour un accès extérieur au réseau, il faut configurer le **proxy de la machine virtuelle** en modfifiant le fichier : 
> /etc/environment 

à l'aide de la commande : 

```sh
root@debian$ echo """HTTP_PROXY=http://cache.univ-lille.fr:3128
HTTPS_PROXY=http://cache.univ-lille.fr:3128
http_proxy=http://cache.univ-lille.fr:3128
https_proxy=http://cache.univ-lille.fr:3128
NO_PROXY=localhost,192.168.194.0/24,172.18.48.0/22""" >> /etc/environment
```

(*en étant connecté à **root** comme expliqué précédemment*)

### Mise à jour de la machine virtuelle

Pour mettre à jour le système nous utilisons la commande : 

```sh
root@debian$ apt update && apt full-upgrade
```

Plusieurs chargement se produisent et nous devons faire un choix : 
- Nous cochons la case */dev/sda/* et confirmons que nous ne souhaitons pas installer **grub**

il faut maintenant faire un **reboot** pour que les modifications soient effectives

```sh
roo@debian$ reboot
```

### Installation d'outils
En tant que root, nous avons installés **vim**, **less**, **tree**  et **rsync** à l'aide de la commande suivante.

```sh
root@debian$ apt-get install vim less tree rsync
```

## Raccourcis utiles

Nous allons modifier le fichier 
>$HOME/ .ssh/config 

de notre machine physique afin de créer des alias et de se connecter plus rapidement à la machine virtuelle.

ainsi le fichier contiendra :

> Host virt
>       HostName frene16.iutinfo.fr
>       ForwardAgent yes
>
> Host vm
>       HostName 192.168.194.3
>       User user
>       ForwardAgent yes
>
> Host vmjump
>       HostName 192.168.194.3
>       User user
>       ForwardAgent yes
>       ProxyJump virt



# Procédure N°2

## Dernières configurations de la machine virtuelle 

### Changement du nom de la machine

Deux fichiers sont à  éditer afin de changer le nom de la machine : 
- `/etc/hostname`
- `/etc/hosts`

Il faudra y changer toutes les occurences du nom actuel (ici *debian*) en `matrix` soit en remplaçant manuellement soit à l'aide des commandes

Soit à l'aide des commandes :
```sh
root@debian$ echo matrix > /etc/hostname
root@debian$ sed -i 's/debian/matrix/g' /etc/hosts 
```


### Installation et configuration de la commande sudo

#### Installation de sudo 

Avant toute installation de package, nous utilisons la commande (*en étant connecté à root*)

```sh
root@matrix$ apt-get update
```

nous permettant de mettre à jour tous les packages. 

puis nous installon sudo avec la commande : 

```sh
root@matrix$ apt-get install sudo
```

#### Configuration de sudo

Nous allons ajouter **l'utilisateur user** au groupe sudo :

```sh
root@matrix$ usermod user -G sudo
```

puis nous allons **reboot** la machine pour que les modifications deviennent effectives : 

```sh
root@matrix$ reboot
```

### Configuration de la synchronisation de l'horloge

Utiliser la commande :

```sh
user@matrix$ date
```

Nous avons constaté que l'heure n'était pas la bonne donc nous avons cherché l'erreur à l'aide de la commande : 

```sh
user@matrix$ sudo journalctl -u systemd-timesyncd
```
Et nous en avons conclus qu'il fallait donc coordonner l'heure à un **serveur NTP**, dans notre cas celui de l'université.

nous alllons donc modifier le fichier 

> /etc/systemd/timesyncd.conf

en décommentant les deux lignes qui se suivent et en y ajoutant le ntp de l'université : 

> [Time]
> NTP=ntp.univ-lille.fr


### Installation et configuration basique d'un serveur de base de données

#### Installation de PostGreSQL

Pour installer postgressql nous allons utliser la commande (*en étant root*) :

```sh
rot@matrix$ apt-get install postgresql
```

#### Créer un utilisateur de la base de donnée

Afin de créer un utilisateur, nous devons nous connecter en tant que root : 

```sh
user@matrix$ su -
```

et ensuite se connecter à l'utilisateur **postgres** : 

```sh
root@matrix su - postgres
```
à partir de ce point nous pouvons créer un nouvel utilisateur de la base de donnée : 

```sh
postgres@matrix$ createuser matrix --pwprompt
```

(*On y ajoutera comme **password : matrix***)

#### Création d'une base de donnée

Pour créer une base de donnée, il faut se conecter à l'user **postgres** et utiliser la commande :

```sh
postgres@matrix$ createdb matrix -O matrix
```

et pour accéder à cette nouvelle base de données nous utilisons la commande :

```sh
postgres@matrix$ psql -U matrix -h localhost matrix
```

#### Utilisation de la base de données

une fois à l'intérieur de la base, nous avons pu **créer une table**, y **insérer des données** ainsi que visualiser les données fraichement rentrées :

```sql
matrix=> CREATE TABLE test (texte TEXT);
CREATE TABLE
matrix=> INSERT INTO test VALUES ('a'),('b'),('c');
INSERT 0 3
matrix=> SELECT * FROM test;
 texte 
-------
 a
 b
 c
(3 rows)
```