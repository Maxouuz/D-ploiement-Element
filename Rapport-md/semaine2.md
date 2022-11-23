# Dernières configurations de la Machine Virtuelle 

## Changement du nom de la machine 

Afin de changer le nom de la machine virtuelle, nous nous connectons tout d'abord à la machine en SSH comme vu dans le compte rendu précédent et nous nous connectons également à root. 

Ensuite nous devons modifier le fichier */etc/hostname* avec la commande

`nano /etc/hostaname`

et y remplacer **debian** par **matrix**. 

En suite il nous faut aller changer un autre fichier 

`nano /etc/hosts`

pour changer également **debian** en **matrix**. Le changement de ce fichier permettra de lier une adresse IP au nouveau nom : **matrix**. 

Pour que cela soit pris en compte on devra **reboot** la machine.

## Installation et configuration de la commande sudo

### Installation de sudo

Avant d'installer **sudo** nous avons utilisé la commande (*en étant root*): 

`apt-get update`

puis afin d'installer le paquet **sudo** nous avons fait : 

`apt-get install sudo`

### Configuration de sudo

Il nous faut ajouter l'utilisateur **user** au groupe sudo et faire un reboot de la machine.

afin de ne pas modifier le fichier */etc/sudoers*, nous avons fait la commande suivante (*en tant que root*) : 

`usermod user -G sudo`

## Configuration de la synchronisation d’horloge

On remarque que la machine virtuelle avance d'une heure. 
Le problème peut être vu à l'aide de la commande : 

`sudo journalctl -u systemd-timesyncd`

Afin de coordonner l'heure aux serveur **NTP** de l'université, il suffit de modifier le fichier */etc/systemd/timesyncd.conf*

avec cette ligne : 
**[Time]
NTP=ntp.univ-lille.fr**

## Installation et configuration basique d’un serveur de base de données

### Installation de PostGreSQL

Pour installer PostGreSQL on utilise les commandes suivantes (à partir de root): 

`apt-get update` pour mettre à jour les paquets 

et

`apt-get install postgresql`

### Créer un utilisateur de la base de données

Afin de créer un un utilisateur de la base donnée, on doit au préalable se connecter à un utilisateur ayant les droits. 
Ici, l'user postgre possède tous les droits depuis l'installation  

Ainsi il faut effectuer (*en tant que sudo*):

`su - postgres`

Une fois connecté avec l'user **postgres** , on va donc créer un nouvel utilistauer avec la commande : 

`createuser matrix --pwprompt`

et on mettra comme **password** **matrix**

### Création d'une base de donnée

Pour créer la base de données, nous avons utlisé la commande 

`createdb  matrix -O matrix`

et nous nous sommes connectés sur cette base (*en user de la machine virtuelle*) avec la commande : 

`psql -U matrix -h localhost matrix`

### Utilisation de la base de données

Nous avons ensuite crées une table nommé test à l'aide de la commande : 

`CREATE TABLE test (texte text);`

et nous y avons insérés trois valeurs à l'aide de la commande : 

`INSERT INTO test values ('a'),('b'),('c');`
