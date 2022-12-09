# Accès à un service HTTP sur la machine virtuelle

## Installation d'un serveur HTTP 

Afin d'installer `ngix`, le serveur web open source, il faut utiliser la commande : 

```console
user@<nom_vm>$ sudo apt-get install nginx
```

> Pour vérifier si le serveur web nginx est bien démmaré on utlise la commande : 

```console
user@<nom_vm>$ systemctl is-active nginx
```

Si la commande nous renvois `active`, alors le serveur est bien démarré.

Il faut maintenant installer `curl`, qui est lui le client pour les url.

```console
user@<nom_vm>$ sudo apt-get install curl
```

## Vérifications de l'installation

Il faut maintenant vérifier si l'accès au serveur ngix depuis la machine virtuelle est fonctionnel :

Depuis la machine virtuel il faut effectuer cette commande : 

```console
user@<nom_vm>$ curl http:/localhost
```

et depuis la machine de virtualisation : 

```console
<login>@<machine_de_virtu>$ curl -x 192.168.194.XX:80 localhost
```
*(où XX represente le dernier octet de l'IP de la machine virtuelle)*

Si le serveur est bien installé, un fichier **HTML** nos indique qu'il estbien installé.

## Accès de la machine physique

Il est impossible d'avoir accès au serveur depuis la machine physique car le serveur est situé dans la machine virtuelle qui elle même est située à l'intérieur de la machine de virtualisation.

Nous allons donc devoir concevoir un `tunnel`.

### A l'aide de la ligne de commande

Pour ce faire il faututiliser la commande : 

```console
<login>@<machine_de_virtu>$ ssh -L 0.0.0.0:8080:localhost:80 user@192.168.194.XX
```

Sur un navigateur web, il faut ensuite entrer l'url suivante : `<machine_de_virtu>iutinfo;fr:8080`. 
Si le message `Welcome to nginx` s'affiche, alors le tunnel est bien configuré.

### Automatiquement

Cette tâche peut être automatisée en ajoutant : `LocalForward 0.0.0.0:8080 192.168.194.XX:80` dans le fichier `~/.ssh/config` de la machine physique ou de virtualisation.

Cette ligne doit s'ajouter dans la section `Host <alia_vm>`.

La procédure [ssh_commands_alias](./ssh_commands_alias.md) pourrait-être utile pour une bonne visualisation de l'action à faire.