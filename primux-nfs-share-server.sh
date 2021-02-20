#!/bin/bash
# Name : cyrille <cyrille@cbiot.fr>
# GIT : https://github.com/CyrilleBiot/primtux-nfs-share/
#
# Installation du partage nfs - Partie Serveur
#
# Fichiers modifiés /etc/fstab, /etc/exports
# Dossiers créés
# ------ /home/01-mini/partage-mini
# ------ /home/02-super/partage-super
# ------ /home/03-maxi/partage-maxi
# ------ /home/administrateur/partage-mini
# ------ /home/administrateur/partage-super
# ------ /home/administrateur/partage-maxi
# ------ /home/administrateur/partage-administrateur
# 
# Ne fonctionne qu'avec IPv4
#
# Syntaxe (soit via sudo soit via le compte root)
# primux-nfs-share-server.sh 
# 

# Recupération de l'ip de la machine
ipServer=$(hostname -I)
ipMini=$(hostname -I | cut -d '.' -f 1-3)

	
# Installation du serveur NFS
if [[ $(aptitude search nfs-kernel-server | cut -d " " -f 1) = "i" ]]
	then
        echo "Bien, nfs-kernel-server est installé."
	else
		echo "nfs-kernel-server n'est pas installé."
		echo "Installation du paquet nfs-kernel-server."
		apt install nfs-kernel-server
fi


# Préparation des partages sur le serveur
mkdir /home/01-mini/partage-mini
mkdir /home/02-super/partage-super
mkdir /home/03-maxi/partage-maxi
mkdir /home/administrateur/partage-mini
mkdir /home/administrateur/partage-super
mkdir /home/administrateur/partage-maxi
mkdir /home/administrateur/partage-administrateur


# Configuration du fichier exports
# Partage lecture / ecriture
echo "# ===========================================" >> /etc/exports
echo "#" >> /etc/exports
echo "# Partage NFS Primtux" >> /etc/exports
echo "#" >> /etc/exports
echo "#" >> /etc/exports
echo "/home/01-mini/partage-mini /home/01-mini/partage-mini $ipMini.1/24(rw,sync)" rw,users 0 0 >> /etc/exports
echo "/home/02-super/partage-super /home/02-super/partage-super $ipMini.1/24(rw,sync)"  >> /etc/exports
echo "/home/03-maxi/partage-maxi /home/03-maxi/partage-maxi $ipMini.1/24(rw,sync)"  >> /etc/exports
echo "/home/01-mini/partage-mini /home/administrateur/partage-mini $ipMini.1/24(rw,sync)"  >> /etc/exports
echo "/home/02-super/partage-super /home/administrateur/partage-super $ipMini.1/24(rw,sync)"  >> /etc/exports
echo "/home/administrateur/partage-administrateur $ipMini.1/24(rw,sync) $ipMini.1/24(rw,sync)" >> /etc/exports
echo "/home/03-maxi/partage-maxi /home/administrateur/partage-maxi $ipMini.1/24(rw,sync)"  >> /etc/exports
echo "#" >> /etc/exports
echo "#" >> /etc/exports
echo "# ===========================================" >> /etc/exports

# Redémarrage des services
systemctl start nfs-kernel-server
