#!/bin/bash

# Installation du partage nfs sur les clients primtux
# Le serveur doit être paramétré avant de lancer cette installation
# Les rép doivent exister
# ----------  mkdir /home/01-mini/partage-mini
# ----------  mkdir /home/02-super/partage-super
# ----------  mkdir /home/03-maxi/partage-maxi
# ----------  mdir  /home/administrateur/partage-mini
# ----------  mdir  /home/administrateur/partage-super
# ----------  mdir  /home/administrateur/partage-maxi
# ----------  mkdir /home/administrateur/partage-administrateur

if [[ -z "$1" ]]
  then
    echo "L'ip du serveur nfs doit être notifiée"
    exit
fi

ipServeur=$1

if [[ $ipServeur =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; 
	then
		echo "Format d'ip valide"
	else
		echo "L'ip n'a pas un format accpetable"
	fi
	



if [[ $(aptitude search nfs-common | cut -d " " -f 1) = "i" ]]
	then
        echo "Well, nfs-common is installed"
	else
		echo "nfs-common is not installed."
		echo "Install nfs-common package."
		#apt install nfs-common
fi

echo $1

# Préparation des partages
# mkdir /home/01-mini/partage-mini
# mkdir /home/02-super/partage-super
# mkdir /home/03-maxi/partage-maxi
# mdir  /home/administrateur/partage-mini
# mdir  /home/administrateur/partage-super
# mdir  /home/administrateur/partage-maxi
# mkdir /home/administrateur/partage-administrateur

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


