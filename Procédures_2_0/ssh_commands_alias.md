# SSH - Raccourcis utiles

Sur notre machine **physique** ou de **virtualisation**, nous allons modifier le fichier `$HOME/ .ssh/config` afin de créer des alias ssh et de se connecter plus facilement aux machines de virtualisation et virtuelle.

On peut donc ajouter des alias paramétrés de la manière suivante :

```text
Host virt
    HostName <machine_de_virtu>.iutinfo.fr
    ForwardAgent yes

Host <alia_vm>
    HostName 192.168.194.XX
    User user
    ForwardAgent yes

Host vmjump
    HostName 192.168.194.XX
    User user
    ForwardAgent yes
    ProxyJump virt
```