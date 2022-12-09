# Installation et configuration d'une machine virtuelle (VM)

## Script VMIUT : Préambule

Le script `vmiut` nous permet de gérer simplement des machines virtuelles de la création, à la suppression en passant par l'affichage d'informations.

Pour des questions de facilité d'emploi, nous choisissons de d'ajouter son import à notre `.bashrc`.

Dans `~/.bashrc`: 
```txt 
source /home/public/vm/vm.env
```

## Installation d'une VM

## IMPORTANT

**Toutes ces procédures doivent être réalisées sur la machine de virtualisation !** 

Cette dernière sera notée comme tel : `<machine_de_virtu>`

Veillez à **remplacer** `<nom_vm>` par le nom de votre vm.

### Création d'une VM

Nous pouvons maintenant utiliser le script, ainsi pour **créeer** une machine virtuelle nous utiliserons la commande `creer`: 
```console
<login>@<machine_de_virtu>$ vmiut creer <nom_vm>
```

Il faut maintenant procéder à la **vérification** grâce à la commande `lister` :
```console
<login>@<machine_de_virtu>$ vmiut lister
```

Si la machine qui vient d'être créée est bien présente nous pouvons passer à la suite autrement il faudra reprendre ces instructions depuis le départ.

### Démarrage de la VM 

Pour **démarrer** la machine `demarrer`:
```console
<login>@<machine_de_virtu>$ vmiut demarrer <nom_vm>
```

### Arrêt et suppression de la VM 
Pour **arrêter** la machine `stop`: 
```console
<login>@<machine_de_virtu>$ vmiut stop <nom_vm>
```

Pour **supprimer** la machine `rm`: 
```console
<login>@<machine_de_virtu>$ vmiut rm <nom_vm>
```

### Obtenir des informations sur la VM

La commande `info` permet de voir les informations et l'état de la machine <nom_vm>:
 ```console
 <login>@<machine_de_virtu>$ vmiut info <nom_vm>
 ```
Ainsi, on peut voir si elle est allumée (`etat:running`) ou non, ou même l'adresse ip attribuée à la machine (`ip-possible`).


## Informations générales

### Identifiants de la VM

La VM dispose de **2 comptes configurés** avec les identifiants suivants :

- login : `root`, mot de passe : `root`
- login : `user`, mot de passe : `user`

### Accès SSH

SSH ne nous permet pas de nous connnecter directement à root, nous devons donc passer par **user** (mot de passe : `user`): 
```console
login@virtualisation$ ssh user@192.168.194.XX
```
Nous pouvons maintenant nous connecter à root à l'aide de la commande `su -` (mot de passe : `root`): 
```console
user@<nom_vm>$ su -
```

### SSH avec redirection graphique

Certaines manipulations requièrent une connexion ssh à la machine de virtualisation avec redirection graphique `ssh -X`.

Si votre machine physique est différente de votre machine de virtualisation, il faut se déconnecter de cette dernière pour s'y reconnecter à l'aide de la commande :
```console
<login>@<machine_physique>$ ssh -X <machine_de_virtu>
```

## Configuration de la VM

### Changement de la configuration réseau

**Cette manipulation requiert la redirection graphique.**

Depuis la machine de virtualisation et avec **redirection graphique activée**, on peut accéder à la VM (*pensez à vérifier que la machine est bien allumée, si ce n'est pas le cas, allumez la*)
```console
login@virtualisation$ vmiut console <nom_vm>
```

Les opérations suivantes se feront depuis **root** (login : `root`, mot de passe : `root`).

#### Attribution d'une IP statique et Passerelle

Nous souhaitons que la machine ait toujours la même adresse IP, et que notre machine de virtualisation serve de passerelle par défaut.

Nous devons d'abord **désactiver l'interface** `enp0s3`:
```console
root@debian# ifdown enp0s3
```
puis modifier le fichier de configuration des `interfaces`, où l'IP est initialement configurée par *DHCP*.
> /etc/network/interfaces

```conf
#iface enp0s3 inet dhcp
iface enp0s3 inet static
    address 192.168.194.XX/24
    gateway 192.168.194.2
```
(*Où **XX** représente l'adresse sur le réseau à attribuer à la VM*)

Nous pouvons **réactiver l'interface** `enp0s3`:
```console
root@debian# ifup enp0s3
```


#### Vérification des modifications
On peut alors constater que les modifications sont bien effectives à l'aide des commandes : 
```console
root@debian# ip a show
root@debian# ip r show
```

qui nous montreront respectivement que l'ip de la machine a été modifiée : 
`inet 192.168.194.XX/24 brd 192.168.194.255 scope global enpos`

et que la route par défaut a été définie : 
`default via 192.168.194.2 dev enp0s3 onlink`

Pour que le système prenne en compte les modfications il faut **redémarrer* la machine : 
```console
root@debian# reboot
```

Nous pouvons maintenant **fermer la console graphique**.

### Changement du nom de la machine

Via une connexion ssh classique à la **vm**:
```console
login@virtualisation$ ssh user@192.168.194.XX
```
Et en étant connecté à **root** (mot de passe : `root`): 
```console
user@debian$ su -
```

Deux fichiers sont à  éditer afin de changer le nom de la machine : 
- `/etc/hostname`
- `/etc/hosts`

Il faudra y changer toutes les occurences du nom actuel (ici *debian*) en `<nom_vm>` soit en remplaçant manuellement soit à l'aide des commandes :

```console
root@debian# echo <nom_vm> > /etc/hostname
root@debian# sed -i 's/debian/<nom_vm>/g' /etc/hosts 
```

Un `cat` de ces fichiers nous montrera que les mentions à *debian* ont disparu au profit de **<nom_vm>**. 

### Configuration du PROXY

**Sur la VM en tant que ROOT**.

Pour que la VM accède au réseau extérieur, il faut configurer le **proxy** en modifiant les `variables d'environnement`: 
> /etc/environment 
Grâce à la commande suivante :
```console
root@<nom_vm># echo """HTTP_PROXY=http://cache.univ-lille.fr:3128
HTTPS_PROXY=http://cache.univ-lille.fr:3128
http_proxy=http://cache.univ-lille.fr:3128
https_proxy=http://cache.univ-lille.fr:3128
NO_PROXY=localhost,192.168.194.0/24,172.18.48.0/22""" >> /etc/environment
```
Un **redémarrage** est nécessaire pour la prise en compte des modifications (`reboot`).

### Mise à jour de la VM

Pour mettre à jour le système nous utilisons depuis **root** la commande : 
```console
root@<nom_vm># apt update && apt full-upgrade
```
Plusieurs chargements se produisent et nous devons faire plusieurs choix : 
1.  Nous cochons la case **/dev/sda/**
1. Nous confirmons (**YES**) que nous ne souhaitons pas installer grub

Un **redémarrage** est nécessaire pour la prise en compte des modifications (`reboot`).

### Installation d'outils
Toujours sur la **machine virtuelle** et connecté en tant que **root**, nous allons installer `vim, less, tree  `et` rsync`  à l'aide de la commande suivante.

```console
root@<nom_vm># apt-get install vim less tree rsync
```

### Installation de sudo 

Avant toute installation de package, nous mettons à jour la liste des paquets (*en étant connecté à root*)
```console
root@<nom_vm># apt-get update
```
puis nous installons sudo avec la commande : 
```console
root@<nom_vm># apt-get install sudo
```

#### Ajout d'un membre à sudo

Nous allons ajouter **l'utilisateur user** au groupe sudo :
```console
root@<nom_vm># usermod user -G sudo
```
puis nous allons **redémarrer** (`reboot`) la machine pour que les modifications deviennent effectives.

### Synchonisation de l'horloge
Il est important que le système soit à la bonne heure, et pour cela il faut le synchroniser à un serveur **NTP**, ici celui de l'université (`ntp.univ-lille.fr`).

Le fichier de configuration est le suivant :
> /etc/systemd/timesyncd.conf
Il faut y décommenter la ligne `#NTP=` pour que le fichier ressemble à ceci :
```conf
[Time]
NTP=ntp.univ-lille.fr
```
Pour que les modifications soient effectives il faut **relancer le service**:
```console
root@<nom_vm># systemctl restart systemd-timesyncd.service
```
La confirmation s'obtient par la commande `date` qui montrera que l'heure du système correspond à l'heure réelle.


