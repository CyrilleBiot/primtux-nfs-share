# primtux-nfs-share

## En dev

Testé sur parc de laptops, dernière Primtux

## Utilisation

Un groupe spécifique est créé : primtux-nfs comprenant les users 01-mini, 02-super, 03-maxi, administrateur


### Le script serveur pour le serveur


Le serveur doit avoir une IP Fixe.

 Fichiers modifiés /etc/hosts.allow, /etc/exports
 
 Dossiers créés
 
 ------ /home/01-mini/partage-mini
 
 ------ /home/02-super/partage-super
 
 ------ /home/03-maxi/partage-maxi
  
 ------ /home/administrateur/partage-administrateur

*Syntaxe*

```
sudo bash primux-nfs-share-server.sh

```

 Effacer la configuration

 ```
 sudo bash primux-nfs-share-server.sh clean
 
 ```



### Le script serveur pour le client 

 Fichier modifié : /etc/fstab


 Dossiers crées

 ------ /home/01-mini/partage-mini

 ------ /home/02-super/partage-super

 ------ /home/03-maxi/partage-maxi

 ------ /home/administrateur/partage-administrateur


 *Syntaxe*
 
 ```
 sudo bash primux-nfs-share-client.sh <IP-V4-DU-SERVEUR>
 
 ```

 Effacer la configuration

 ```
 sudo bash primux-nfs-share-client.sh clean
 
 ```

### Attention
 Ne fonctionne qu'en ipv4
 
