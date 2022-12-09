# Installation et configuration de PostGreSQL sur une machine virtuelle debian

## Installation de PostGreSQL

En tant que root, nous allons installer le paquet `PostGreSQL`

```console
root@<nom_vm># apt-get install postgresql
```

## Créer un utilisateur de la base de données

Afin de créer un utilisateur, nous devons nous connecter en tant que root : 

```console
user@<nom_vm>$ su -
```

et ensuite se connecter à l'utilisateur `postgres` : 

```console
root@<nom_vm># su - postgres
```

à partir de ce point nous pouvons créer un nouvel utilisateur de la base de donnée :

```console
postgres@<nom_vm># createuser <nom_user> --pwprompt
```

Il faudra ajouter comme `password` le `<nom_user>`

## Création d'une base de données 

Pour créer une base de donnée, il faut se conecter à l'user `postgres` et utiliser la commande :

```console
postgres@<nom_vm># createdb <nom_db> -O <nom_user>
```

et pour accéder à cette nouvelle base de données nous utilisons la commande :

```console
postgres@<nom_vm># psql -U <nom_user> -h localhost <nom_db>
```

## Utilisation de la base de données

une fois à l'intérieur de la base, nous avons pu ``créer une table``, y ``insérer des données`` ainsi que ``visualiser`` les données fraichement rentrées :

```sql
<nom_db>=> CREATE TABLE test (texte TEXT);
CREATE TABLE
<nom_db>=> INSERT INTO test VALUES ('a'),('b'),('c');
INSERT 0 3
<nom_db>=> SELECT * FROM test;
 texte 
-------
 a
 b
 c
(3 rows)
```
