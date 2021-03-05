#!/bin/bash
# Name : cyrille <cyrille@cbiot.fr>
# GIT : https://github.com/CyrilleBiot/primtux-nfs-share/
#
# Installation du partage nfs sur les clients primtux
# 
# Ne fonctionne qu'avec IPv4
#
# Le serveur doit être paramétré avant de lancer cette installation
# Pour le paramétrage du serveur, utiliser le script
# primux-nfs-share-server.sh
#
# Syntaxe 
# primux-nfs-share-client.sh <ipv4 du serveur nfs>
# 
# Lancer le script avec l'option clean pour effacer les modifications 
# apportées au système
#
# primux-nfs-share-client.sh clean

# Test des droits d'execution
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être lancé en root ou via sudo" 
   exit 1
fi

# Test si existence parametre IP 
if [[ -z "$1" ]]
  then
    echo "L'ip du serveur nfs doit être notifiée"
    exit
fi


# Test si desinstallation souhaitée
if [[ $1 = "clean" ]]
  then
	# Confirmer la suppression de la configuration
	read -p "Attention. Voulez réellement supprimer la config nfs serveur (oui / non) ?" answer
	if echo "$answer" | grep -i "^o" ;then
	
		# Montage des nouveaux partages
		umount /home/01-mini/partage-mini
		umount /home/02-super/partage-super
		umount /home/03-maxi/partage-maxi
		umount /home/administrateur/partage-administrateur
		
		# On efface la configuration
		rm -rf /home/01-mini/partage-mini
		rm -rf /home/02-super/partage-super
		rm -rf /home/03-maxi/partage-maxi
		rm -rf /home/administrateur/partage-administrateur
		
		# On rétablit les fichiers d'origine
		sed -i '/#PrimtuxNFS/{N;N;N;N;d;}' /etc/fstab

		exit 1
	else
		exit 1
	fi
fi

# Recup de l'ip passée en paramètre
ipServeur=$1

# Test validité de l'IP
if [[ $ipServeur =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; 
	then
		echo "Format d'ip valide."
	else
		echo "L'ip n'a pas un format accpetable."
	fi
	
# Test paquet client nfs-common installé ou non
if [[ $(aptitude search nfs-common | cut -d " " -f 1) = "i" ]]
	then
        echo "Bien, nfs-common est déjà installé."
	else
		echo "Attation : nfs-common n'est installé."
		echo "Installation du paquet  nfs-common."
		apt install nfs-common
fi

# Préparation des partages
	mkdir /home/01-mini/partage-mini
	mkdir /home/02-super/partage-super
	mkdir /home/03-maxi/partage-maxi
	mkdir /home/administrateur/partage-administrateur

# Attribution des droits
	chown administrateur:administrateur /home/administrateur/partage-administrateur
	chown 01-mini:01-mini /home/01-mini/partage-mini
	chown 02-super:02-super /home/02-suoer/partage-mini
	chown 03-maxi:03-maxi /home/03-maxi/partage-mini

# Affichage Utilisateur
	echo "Le dossier /home/01-mini/partage-mini a été créé."
	echo "Le dossier /home/02-super/partage-super a été créé."
	echo "Le dossier /home/03-maxi/partage-maxi a été créé."
	echo "Le dossier /home/administrateur/partage-administrateur a été créé."

# Insertion dans fstab

	echo "#PrimtuxNFS" >> /etc/fstab
	echo "$ipServeur:/home/01-mini/partage-mini /home/01-mini/partage-mini  nfs rw,users 0 0"  >> /etc/fstab
	echo "$ipServeur:/home/02-super/partage-super /home/02-super/partage-super nfs rw,users 0 0"  >> /etc/fstab
	echo "$ipServeur:/home/03-maxi/partage-maxi /home/03-maxi/partage-maxi nfs rw,users 0 0"  >> /etc/fstab
	echo "$ipServeur:/home/administrateur/partage-administrateur /home/administrateur/partage-administrateur nfs rw,users 0 0"  >> /etc/fstab

# Montage des nouveaux partages
	mount /home/01-mini/partage-mini
	mount /home/02-super/partage-super
	mount /home/03-maxi/partage-maxi
	mount /home/administrateur/partage-administrateur
