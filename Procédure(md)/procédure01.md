# Procédure N°1 

## Connexion à distance

### Première connexion à la machine de virtualisation 

#### Informations générales et commande de connexion
Pour se connecter à distance sur une machine du réseau de l'IUT, nous utlisons la commande : 

```console
login@phys$ ssh login@nom_de_la_machine.iutinfo.fr
```

>Où le login correspond à l'identifiant au format nom.prenom.etu et le nom de la machine est celui fourni par les enseignants dans le cours Moodle de la saé.

Lors de la première connexion sur la machine distante, il faudra vérifier si l'empreinte de la machine correspond bien à la clef renseignée sur le cours moodle. 

> Si l'empreinte est la même, tapez **"yes"** dans le terminal comme indiqué.


#### L'empreinte de la machine : conception de la paire de clef

Pour générer une clef qui nous permet de ne pas avoir à entrer nos identifiants à chaque connexion, nous utilisons la commande 

```console
login@phys$ ssh_keygen
```

Cela va créer un fichier se trouvant en 
> /home/infoetu/nom.prenom.etu/.ssh/id_rsa

où nous laisserons le nom du fichier par **défaut**.

Une **passphrase** sera demandée, il faudra la définir et la confirmer.

#### L'empreinte de la machine : transmission de la clef au serveur 

Une fois la clef créée, il faut la diffuser sur le serveur afin d'en profiter depuis l'ensemble des machines, ceci s'eefectue à l'aide de la commande : 

```console
login@phys$ ssh-copy-id -i $HOME/.ssh/id_rsa.pub machine
```

*où machine est la machine distante = de virtualisation(ex frene16).*


## Créer et gérer des machines virtuelles 

Pour accéder à la machine virtuelle, nous avons besoin du script `vmiut` que nous allons ajouter au **bashrc** pour ne pas avoir à l'importer dans chaque nouveau terminal, en y ajoutant la ligne : 

> source /home/public/vm/vm.env

### Création d'une machine virtuelle

Nous pouvons maintenant utiliser le script, ainsi pour créeer une machine virtuelle nous utilisons la commande : 

```console
login@virtualisation$ vmiut creer Matrix
```

Il faut maintenant procéder à la vérification

```console
login@virtualisation$ vmiut lister
```

Si la machine Matrix est bien présente nous pouvons passer à la suite.

### Démarrage de la machine virtuelle 

Pour démarrer la machine : 

```console
login@virtualisation$ vmiut demarrer Matrix
```

### Arrêt et suppression de la machine virtuelle 
Pour arrêter la machine : 

```console
login@virtualisation$ vmiut stop Matrix
```

Pour supprimer la machine : 

```console
login@virtualisation$ vmiut rm Matrix
```

### Obtenir des informations sur la machine virtuelle

La commande:
 ```console
 login@virtualisation$ vmiut info Matrix
 ```
permet de voir les informations et l'état de la machine Matrix. Ainsi, on peut voir si elle est allumée (`etat:running`) ou non, ou même l'adresse ip de la machine se situant à : **ip-possible**


### Utilisation de la machie virtuelle 

#### Console virtuelle 

La première manière est l'utilisation de la machine virtuelle en mode graphique, **une fois la connexion ssh actuelle coupée**, nous allons utiliser la commande: 

```console
login@phys$ ssh -X virtualisation
```

puis 

```console
login@virtualisation$ vmiut console Matrix
```
(*pensez à vérifier que la machine est bien allumée, si ce n'est pas le cas n'oubliez pas de le faire*)

Une fois sur la console, se connecter à l'aide du login : `root` et du mot de passe : `root`.

#### Changement de la configuration réseau

Nous souhaitons que la machine ait toujours la même adresse IP, dans notre cas : 
> 192.168.14.3

nous devons donc désactiver l'interface enp0s3 (*à partir de root sur la machine virtuelle*) : 

```console
root@debian# ifdown enp0s3
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

```console
root@debian# ifup enp0s3
```

on peut alors constater que les modifications sont bien effectives à l'aide des commandes : 

```console
root@debian# ip a show
root@debian# ip r show
```

qui nous montreront respectivement que l'ip de la machine a été modifiée : 
`inet 192.168.194.3/24 brd 192.168.194.255 scope global enpos`

et que la route par défaut a été définie : 
`default via 192.168.194.2 dev enp0s3 onlink`

Pour que le système prenne en compte les modfications il faut **reboot* la machine : 

```console
root@debian# reboot
```

Nous pouvons maintenant **fermer la console graphique**.

## Configurer et mettre à jour la machine virtuelle 

### Connexion root et ssh

**ssh** ne nous permet pas de nous connecter directement à **root**, nous devons donc passer par **user** : 

```console
login@virtualisation$ ssh user@192.168.194.3
```
(*ici on utilisera comme **password user***)

et nous pouvons ainsi nous connecter à root à l'aide de la commande : 

```console
user@debian$ su -
```

(*ici on utilisera le **password root***)

### Accès extérieur pour les machines virtuelles

Pour un accès extérieur au réseau, il faut configurer le **proxy de la machine virtuelle** en modfifiant le fichier : 
> /etc/environment 

à l'aide de la commande : 

```console
root@debian# echo """HTTP_PROXY=http://cache.univ-lille.fr:3128
HTTPS_PROXY=http://cache.univ-lille.fr:3128
http_proxy=http://cache.univ-lille.fr:3128
https_proxy=http://cache.univ-lille.fr:3128
NO_PROXY=localhost,192.168.194.0/24,172.18.48.0/22""" >> /etc/environment
```

(*en étant connecté à **root** comme expliqué précédemment*)

Un **reboot** est nécessaire pour la prise en compte des modifications.

### Mise à jour de la machine virtuelle

Pour mettre à jour le système nous utilisons depuis **root** la commande : 

```console
root@debian# apt update && apt full-upgrade
```

Plusieurs chargements se produisent et nous devons faire un choix : 
- Nous cochons la case */dev/sda/* et confirmons que **nous ne souhaitons pas installer grub**

il faut maintenant faire un **reboot** pour que les modifications soient effectives

```console
roo@debian# reboot
```

### Installation d'outils
Toujour sur la **machine virtuelle** et connecté en tant que **root**, nous allons installer `vim, less, tree  `et` rsync`  à l'aide de la commande suivante.

```console
root@debian# apt-get install vim less tree rsync
```

## Raccourcis utiles
Nous pouvons **fermer la connexion ssh** à la **machine virtuelle** ainsi qu'à la **machine de virtualisation**.


Sur notre **machine physique**, nous allons modifier le fichier `$HOME/ .ssh/config` de notre machine physique afin de créer des alias et de se connecter plus rapidement aux machines de virtualisation et virtuelle.

Il faudra donc ajouter les alias paramétrés de la manière suivante :

```text
Host virt
    HostName virtualisation.iutinfo.fr
    ForwardAgent yes

Host vm
    HostName 192.168.194.3
    User user
    ForwardAgent yes

Host vmjump
    HostName 192.168.194.3
    User user
    ForwardAgent yes
    ProxyJump virt
```