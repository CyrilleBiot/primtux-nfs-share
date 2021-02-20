#!/bin/bash
#
# Installation du partage nfs sur le poste qui sera la serveur NFS
# l'IP doit être fixe
# le poste doit être allumé en permanence
#

# Recupération de l'ip de la machine
ipServer=$(hostname -I)
ipMini=$(hostname -I | cut -d '.' -f 1-3)

	
# Installation du serveur NFS

if [[ $(aptitude search nfs-kernel-server | cut -d " " -f 1) = "i" ]]
	then
        echo "Bien , nfs-kernel-server est installé."
	else
		echo "nfs-kernel-server n'est pas installé."
		echo "Installation du paquet nfs-kernel-server."
		#apt install nfs-kernel-server
fi


# Préparation des partages sur le serveur
# mkdir /home/01-mini/partage-mini
# mkdir /home/02-super/partage-super
# mkdir /home/03-maxi/partage-maxi
# mdir  /home/administrateur/partage-mini
# mdir  /home/administrateur/partage-super
# mdir  /home/administrateur/partage-maxi
# mkdir /home/administrateur/partage-administrateur


# Configuration du fichier exports
# Partage lecture / ecriture
echo "/home/01-mini/partage-mini /home/01-mini/partage-mini" >> /etc/exports
echo "/home/02-super/partage-super /home/02-super/partage-super"  >> /etc/exports
echo "/home/03-maxi/partage-maxi /home/03-maxi/partage-maxi"  >> /etc/exports
echo "/home/01-mini/partage-mini /home/administrateur/partage-mini"  >> /etc/exports
echo "/home/02-super/partage-super /home/administrateur/partage-super"  >> /etc/exports
echo "/home/administrateur/partage-administrateur $ipMini.1/24(rw,sync)" >> /etc/exports
echo "/home/03-maxi/partage-maxi /home/administrateur/partage-maxi"  >> /etc/exports


# Insertion dans fstab
echo "$ipServeur:/home/01-mini/partage-mini /home/01-mini/partage-mini" >> /etc/fstab
echo "$ipServeur:/home/02-super/partage-super /home/02-super/partage-super"  >> /etc/fstab
echo "$ipServeur:/home/03-maxi/partage-maxi /home/03-maxi/partage-maxi"  >> /etc/fstab
echo "$ipServeur:/home/01-mini/partage-mini /home/administrateur/partage-mini"  >> /etc/fstab
echo "$ipServeur:/home/02-super/partage-super /home/administrateur/partage-super"  >> /etc/fstab
echo "$ipServeur:/home/03-maxi/partage-maxi /home/administrateur/partage-maxi"  >> /etc/fstab
echo "$ipServeur:/home/administrateur/partage-administrateur /home/administrateur/partage-administrateur"  >> /etc/fstab

mount /home/01-mini/partage-mini
mount /home/02-super/partage-super
mount /home/03-maxi/partage-maxi
mount /home/administrateur/partage-mini
mount /home/administrateur/partage-super
mount /home/administrateur/partage-maxi
mount /home/administrateur/partage-administrateur

