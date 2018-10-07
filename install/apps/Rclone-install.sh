#!/bin/bash

which rclone > /tmp/checkapp.txt
clear

if [ -s /tmp/checkapp.txt ]; then

	ALREADYINSTALLED

else

	EXPLAINTASK

	CONFIRMATION

	if [[ ${REPLY} =~ ^[Yy]$ ]]; then

		GOAHEAD

		# Dependencies

		RUNPATCHES

		sudo -s apt-get -y install \
			unzip \
			curl \
			fuse \
		denyhosts at sudo software-properties-common

		# Open ports

		#na

		# Create directories

		mkdir -p /home/plexuser/logs
		mkdir -p /home/plexuser/uploads
		sudo chown plexuser:plexuser -R /home/plexuser

		# Main script

		cd /tmp

		read -e -p "Release ${YELLOW}(R)${STD} or Beta installation ${YELLOW}(B)?${STD} " -i "R" choice

		case "$choice" in 
			b|B ) curl https://rclone.org/install.sh | sudo bash -s beta ;;
			* ) curl https://rclone.org/install.sh | sudo bash ;;
		esac

		cd ~
		clear

		echo "${YELLOW}Please follow the instructions to setup Rclone${STD}"
		echo ""
		sudo rclone config

		# Installing Services

		sudo rsync -a /opt/GooPlex/scripts/rclone.service /etc/systemd/system/rclone.service
		sudo systemctl enable rclone.service
		sudo systemctl daemon-reload
		sudo systemctl start rclone.service

		TASKCOMPLETE

	else

		CANCELTHIS

	fi

fi

rm /tmp/checkapp.txt
PAUSE
