# Présentation du repository git

Ce projet est mené par **HERSSENS Alexendre** et **STIEVENARD Maxence** afin de répondre aux attentes de la **SAÉ S3.03 - Déploiement d'une application d'une application**.

Deux dossiers seront mis à jour régulièrement contenant nos rapports hebdomadaires dans des extentions différentes : 
- MarkDowwn
- PDF

Pour générer les rapports en pdf nous utiliserons l'outil [pandoc](https://pandoc.org/) afin de générer également une table des matières fonctionelle. 

Nous nous aiderons de la commande : 

`pandoc -s --toc -N -o nom_que_l_on_souhaite_donner.pdf nom_du_fichier_actuel.md --metadata title="Titre que l'on souhaite donner au fichier"`

[site](blabla/test.txt)
