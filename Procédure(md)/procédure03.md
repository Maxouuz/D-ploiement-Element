
# Accès à un service HTTP sur la VM

## Installation d'un serveur et d'un client HTTP

Installer nginx
```console
user@matrix# sudo apt-get install nginx
```
> On peut vérifier si le serveur nginx est démarré avec la commande `systemctl is-active nginx` (le résultat attendu est `active`)

Installer curl
```console
user@matrix# sudo apt-get install curl
```

## Vérifier l'installation client/serveur 

Maintenant que nous avons installé curl, on peut vérifier si on peut accéder au serveur nginx depuis la machine virtuelle avec la commande `curl http://localhost`

On peut vérifier aussi qu'on peut y accéder depuis la machine de virtualisation avec la commande `curl -x 192.168.194.3:80 localhost`

> Le résultat de la commande devrait correspondre à un fichier texte HTML qui nous informe que le serveur est bien installé

## Accès au service depuis la machine physique

Nous aimerions avoir accès au serveur HTTP de notre machine virtuelle depuis notre machine physique.
Malheureusement, cela est actuellement impossible car ce serveur est situé dans la vm, qui est situé dans la machine de virtualisation et non dans la machine physique.

Pour régler ce problème, nous allons utiliser une fonction de SSH qui s'appelle `tunnel`.

## Méthode manuelle

Se connecter à la vm en créant un pont entre elle et la machine de virtualisation :

```console
login@virt$ ssh -L 0.0.0.0:8080:localhost:80 user@192.168.194.3
```

Pour vérifier si le tunnel a bien été crée, il faut aller sur l'URL `<machine-de-virtu>.iutinfo.fr:8008`, en remplacant `<machine-de-virtu>` par le nom de votre machine (exemple: ayou03).
Le site devrait contenir un titre du type `Welcome to nginx!`

## Méthode automatique

On peut automatiser cette opération en ajoutant la ligne `LocalForward 0.0.0.0:8080 192.168.194.3:80` dans le fichier `~/.ssh/config` dans le host vm.
Le résultat devrait être:
```yaml
Host virt
        HostName frene26.iutinfo.fr
        ForwardAgent yes
Host vm
        HostName 192.168.194.3
        User user
        LocalForward 0.0.0.0:8080 192.168.194.3:80
        GatewayPorts yes
        ForwardAgent yes
Host vmjump
        HostName 192.168.194.3
        User user
        ForwardAgent yes
        ProxyJump virt
```

<div id="creer-tunnel"></div>

Pour créer le tunnel il faudra exécuter ces deux commandes :
```
login@phys$ ssh virt
user@virt$ ssh vm
```