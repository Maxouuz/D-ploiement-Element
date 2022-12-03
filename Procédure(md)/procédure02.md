# Procédure N°2

## Dernières configurations de la machine virtuelle 

### Changement du nom de la machine

De retour sur la **machine virtuelle**, deux fichiers sont à  éditer afin de changer le nom de la machine : 
- `/etc/hostname`
- `/etc/hosts`

Il faudra y changer toutes les occurences du nom actuel (ici *debian*) en `matrix` soit en remplaçant manuellement soit à l'aide des commandes :

```sh
root@debian# echo matrix > /etc/hostname
root@debian# sed -i 's/debian/matrix/g' /etc/hosts 
```

Un `cat` de ces fichiers nous montrera que les mentions à *debian* ont disparu au profit de **matrix**. 

### Installation et configuration de la commande sudo

#### Installation de sudo 

Avant toute installation de package, nous utilisons la commande (*en étant connecté à root*)

```sh
root@matrix# apt-get update
```

nous permettant de mettre à jour tous les packages. 

puis nous installon sudo avec la commande : 

```sh
root@matrix# apt-get install sudo
```

#### Configuration de sudo

Nous allons ajouter **l'utilisateur user** au groupe sudo :

```sh
root@matrix# usermod user -G sudo
```

puis nous allons **reboot** la machine pour que les modifications deviennent effectives : 

```sh
root@matrix# reboot
```

### Configuration de la synchronisation de l'horloge

Utiliser la commande :

```sh
user@matrix# date
```

Nous avons constaté que l'heure n'était pas la bonne donc nous avons cherché l'erreur à l'aide de la commande : 

```sh
user@matrix# sudo journalctl -u systemd-timesyncd
```
Et nous en avons conclus qu'il fallait donc coordonner l'heure à un **serveur NTP**, dans notre cas celui de l'université.

nous alllons donc modifier le fichier 

> /etc/systemd/timesyncd.conf

en décommentant les deux lignes qui se suivent et en y ajoutant le ntp de l'université : 

> [Time]
> NTP=ntp.univ-lille.fr

et pour que les modifications soient effectives il faut relancer le service:

```sh
user@matrix# sudo systemctl restart systemd-timesyncd.service
```
La confirmation s'obtient par la commande `date`.
### Installation et configuration basique d'un serveur de base de données

#### Installation de PostGreSQL

Pour installer postgressql nous allons utliser la commande (*en étant root*) :

```sh
root@matrix# apt-get install postgresql
```

#### Créer un utilisateur de la base de donnée

Afin de créer un utilisateur, nous devons nous connecter en tant que root : 

```sh
user@matrix# su -
```

et ensuite se connecter à l'utilisateur **postgres** : 

```sh
root@matrix su - postgres
```
à partir de ce point nous pouvons créer un nouvel utilisateur de la base de donnée : 

```sh
postgres@matrix# createuser matrix --pwprompt
```

(*On y ajoutera comme **password : matrix***)

#### Création d'une base de donnée

Pour créer une base de donnée, il faut se conecter à l'user **postgres** et utiliser la commande :

```sh
postgres@matrix# createdb matrix -O matrix
```

et pour accéder à cette nouvelle base de données nous utilisons la commande :

```sh
postgres@matrix# psql -U matrix -h localhost matrix
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