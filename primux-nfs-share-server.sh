#!/bin/bash
# Name : cyrille <cyrille@cbiot.fr>
# GIT : https://github.com/CyrilleBiot/primtux-nfs-share/
#
# Installation du partage nfs - Partie Serveur
#
# Fichiers modifiés /etc/fstab, /etc/exports, /etc/hosts.allow
# Dossiers créés
# ------ /home/01-mini/partage-mini
# ------ /home/02-super/partage-super
# ------ /home/03-maxi/partage-maxi
# ------ /home/administrateur/partage-administrateur
# 
# Ne fonctionne qu'avec IPv4
#
# Syntaxe (soit via sudo soit via le compte root)
# primux-nfs-share-server.sh 
# 

# Test des droits d'execution
if [[ $EUID -ne 0 ]]; then
	echo "Ce script doit être lancé en root ou via sudo" 
	exit 1
fi


# Test si desinstallation souhaitée
if [[ $1 = "clean" ]]
  then
	# Confirmer la suppression de la configuration
	read -p "Attention. Voulez réellement supprimer la config nfs serveur (oui / non) ?" answer
	if echo "$answer" | grep -i "^o" ;then
		# On efface la configuration
		rm -rf /home/01-mini/partage-mini
		rm -rf /home/02-super/partage-super
		rm -rf /home/03-maxi/partage-maxi
		rm -rf /home/administrateur/partage-administrateur
		
		# On rétablit les fichiers d'origine
		sed -e '/# Partage NFS Primtux/{N;N;N;N;N;N;N;N;d}' /etc/exports
		sed -e '/# Partage NFS Primtux/{N;N;N;N;N;d}' /etc/hosts.allow
		
		# On redémarre les services
		exportfs -a
		systemctl restart nfs-kernel-server
		exit 1
	else
		exit 1
	fi
fi

      # Recupération de l'ip de la machine
      ipServer=$(hostname -I)
      ipMini=$(hostname -I | cut -d '.' -f 1-3)


      	# Installation du serveur NFS
      	if [[ $(aptitude search nfs-kernel-server | cut -d " " -f 1) = "i" ]]
      		then
      		        echo "Bien, nfs-kernel-server est installé."
      		        	else
      		        		echo "nfs-kernel-server n'est pas installé."
      		        		echo "Installation du paquet nfs-kernel-server."
      		        		apt install nfs-kernel-server
      		        		fi

							# Création d'un nouveau groupe primtux-nfs
							# Et ajout des users
						    addgroup primtux-nfs
							adduser administrateur  primtux-nfs
							adduser 01-mini  primtux-nfs
							adduser  02-super primtux-nfs
							adduser  03-maxi primtux-nfs
							
							# On récup l'UID du groupe (normalement 1004 mais va t on savoir...)              
							# GUID=$(cat /etc/group | grep primtux-nfs | cut -d ":" -f 3)

      		        		# Préparation des partages sur le serveur
      		        		mkdir /home/01-mini/partage-mini
       		        		mkdir /home/02-super/partage-super
      		        		mkdir /home/03-maxi/partage-maxi
      		        		mkdir /home/administrateur/partage-administrateur
      		        		
      		        		# Attribution des droits
							chown administrateur:administrateur /home/administrateur/partage-administrateur
							chown 01-mini:01-mini /home/01-mini/partage-mini
							chown 02-super:02-super /home/02-super/partage-super
							chown 03-maxi:03-maxi /home/03-maxi/partage-maxi

      		        		# Configuration du fichier exports
      		        		# Partage lecture / ecriture
      		        		echo "# Partage NFS Primtux" >> /etc/exports
      		        		echo "#" >> /etc/exports
      		        		echo "/home/01-mini/partage-mini $ipMini.1/24(rw,sync,all_squash,anonuid=1001,anongid=$GUID)"  >> /etc/exports
      		        		echo "/home/02-super/partage-super $ipMini.1/24(rw,sync,all_squash,anonuid=1002,anongid=$GUID)"  >> /etc/exports
      		        		echo "/home/03-maxi/partage-maxi $ipMini.1/24(rw,sync,all_squash,anonuid=1003,anongid=$GUID)"  >> /etc/exports
      		        		echo "/home/administrateur/partage-administrateur $ipMini.1/24(rw,sync,,all_squash,anonuid=1000,anongid=$GUID)" >> /etc/exports
      		        		echo "#" >> /etc/exports
      		        		echo "# ===========================================" >> /etc/exports			
      		        							
      		        		# Configuration fichier hosts.allow
      		        		# Droit sur réseau local
      		        		echo "# Partage NFS Primtux" >> /etc/hosts.allow
      		        		echo "#" >> /etc/hosts.allow
      		        		echo "ALL:LOCAL" >> /etc/hosts.allow
      		        		echo "#" >> /etc/hosts.allow
      		        		echo "# ===========================================" >> /etc/hosts.allow
      		        							
								
   							# Redémarrage des services
   							exportfs -a
  							systemctl restart nfs-kernel-server
