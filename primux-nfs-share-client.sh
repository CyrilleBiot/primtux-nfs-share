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
# primux-nfs-share-server.sh <ipv4 du serveur nfs>
# 


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

ipServeur=$1

# Test validité de l'IP
if [[ $ipServeur =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; 
	then
		echo "Format d'ip valide"
	else
		echo "L'ip n'a pas un format accpetable"
	fi
	
# Test paquet client nfs-common installé ou non
if [[ $(aptitude search nfs-common | cut -d " " -f 1) = "i" ]]
	then
        echo "Well, nfs-common is installed"
	else
		echo "nfs-common is not installed."
		echo "Install nfs-common package."
		#apt install nfs-common
fi

# Préparation des partages
mkdir /home/01-mini/partage-mini
mkdir /home/02-super/partage-super
mkdir /home/03-maxi/partage-maxi
mkdir /home/administrateur/partage-mini
mkdir /home/administrateur/partage-super
mkdir /home/administrateur/partage-maxi
mkdir /home/administrateur/partage-administrateur

# Affichage Utilisateur
echo "Le dossier /home/01-mini/partage-mini a été créé."
echo "Le dossier /home/02-super/partage-super a été créé."
echo "Le dossier /home/03-maxi/partage-maxi a été créé."
echo "Le dossier /home/administrateur/partage-mini a été créé."
echo "Le dossier /home/administrateur/partage-super a été créé."
echo "Le dossier /home/administrateur/partage-maxi a été créé."
echo "Le dossier /home/administrateur/partage-administrateur a été créé."

# Insertion dans fstab
echo "$ipServeur:/home/01-mini/partage-mini /home/01-mini/partage-mini  nfs rw,users 0 0"  >> /etc/fstab
echo "$ipServeur:/home/02-super/partage-super /home/02-super/partage-super nfs rw,users 0 0"  >> /etc/fstab
echo "$ipServeur:/home/03-maxi/partage-maxi /home/03-maxi/partage-maxi nfs rw,users 0 0"  >> /etc/fstab
echo "$ipServeur:/home/01-mini/partage-mini /home/administrateur/partage-mini nfs rw,users 0 0"  >> /etc/fstab
echo "$ipServeur:/home/02-super/partage-super /home/administrateur/partage-super nfs rw,users 0 0"  >> /etc/fstab
echo "$ipServeur:/home/03-maxi/partage-maxi /home/administrateur/partage-maxi nfs rw,users 0 0"  >> /etc/fstab
echo "$ipServeur:/home/administrateur/partage-administrateur /home/administrateur/partage-administrateur nfs rw,users 0 0"  >> /etc/fstab

# Montage des nouveaux partages
mount /home/01-mini/partage-mini
mount /home/02-super/partage-super
mount /home/03-maxi/partage-maxi
mount /home/administrateur/partage-mini
mount /home/administrateur/partage-super
mount /home/administrateur/partage-maxi
mount /home/administrateur/partage-administrateur

