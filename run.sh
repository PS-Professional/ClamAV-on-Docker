#!/usr/bin/bash

#ClamAV setup on docker
#Developed by PS-Professional
#
#
#    ____  ____        ____             __               _                   _
#   |  _ \/ ___|      |  _ \ _ __ ___  / _| ___  ___ ___(_) ___  _ __   __ _| |
#   | |_) \___ \ _____| |_) | '__/ _ \| |_ / _ \/ __/ __| |/ _ \| '_ \ / _` | |
#   |  __/ ___) |_____|  __/| | | (_) |  _|  __/\__ \__ \ | (_) | | | | (_| | |
#   |_|   |____/      |_|   |_|  \___/|_|  \___||___/___/_|\___/|_| |_|\__,_|_|
#
#===================================================================================================

#Option for later release
#SYS_PKG=`cat /etc/os-release | grep 'ID_LIKE' | cut -f 2 -d '='`

#Functions
function help(){
	echo -e "run.sh:     Setup and run ClamAV daemon on Docker engine\n"
	echo "Options:"
	echo -e "N/A\t\t Run script in interactive mode"
	echo -e "init\t\t Install Docker and setup ClamAV image"
	echo -e "start\t\t Start ClamAV container"
	echo -e "control\t\t Control and execute commands to ClamAV container"
	echo -e "restart\t\t Restart ClamAV container"
	echo -e "stop\t\t stop ClamAV container"
}

function docker_install(){
	#Install docker on your host
	echo installing Docker\.\.\.
	sleep 1
	sudo apt update
	sudo apt install -y\
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/ubuntu \
		$(lsb_release -cs) \
		stable"
	sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose
	sleep 2
	echo Installing done\!
}

function docker_update(){
#Update your system
	echo Updating system\.\.\.
	sleep 1
	sudo apt update && sudo apt upgrade
	sleep 2
	echo Updating Done\!
}

function docker_init(){
	#config files
	echo Building ClamAV image
	sleep 1
	sudo docker build -t ps/clamav .
}

function main(){
clear
echo Hello\! ; sleep 1
echo -e 'What you want me to do?\n1) Setup container (init)\n2) Start container (start)\n3) Control ClamAV (control)\n4) Restart container (restart)\n5) Stop container (stop)\n6) Exit (exit)'
read -p '-> ' func
case $func in
	init )
		if [[ -f /usr/bin/docker ]]
		then
			echo Docker is already exsits in your system
			sleep 1
			State=1
			while [[ $State = 1 ]]
			do
				read -p 'Do you want to check for system updates? ' update
				if [[ $update = 'yes' ]] || [[ $update = 'y' ]]
				then
					docker_update
					State=0
				elif [[ $update = 'no' ]] || [[ $update = 'n' ]]
				then
					echo OK\!
					sleep 1
					State=0
				else
					echo I didn\'t understand\!
					sleep 0.5
					echo Please try again\!
					sleep 0.5
				fi
			done
		else
			docker_install
		fi
		sleep 1
		docker_init ;;
	start )
		sudo docker-compose up -d ;;
	control )
		echo "These are available options for you:" ; sleep 1
		echo -e "status\t\t Show service status"
		echo -e "freshclam\t Update ClamAV virus databases"
		echo -e "update\t\t Check and update container packages"
		echo -e "bash\t\t Start bash shell in container"
		echo -e "restart\t\t Restart ClamAV services"
		echo -e "exit\t\t Exit"
		echo "What can I do for you?"
		read -p "-> " operation
		case $operation in
			status )
				sudo docker-compose exec clamav clamer status;;
			freshclam )
				sudo docker-compose exec clamav clamer freshclam;;
			update )
				sudo docker-compose exec clamav clamer update;;
			bash )
				sudo docker-compose exec clamav bash;;
			restart )
				sudo docker-compose exec clamav clamer restart;;
			exit )
				echo Goodbye\!;;
		esac;;
	restart )
		sudo docker-compose restart;;
	stop )
		sudo docker-compose down;;
	exit )
		echo Goodbye\!;;
esac

}

# Main code
if [[ -z $1 ]]
then
	main
else
	case $1 in
		init )
			if [[ -f /usr/bin/docker ]]
				then
					echo Docker is already exsits in your system
					sleep 1
					State=1
					while [[ $State = 1 ]]
					do
						read -p 'Do you want to check for system updates? ' update
						if [[ $update = 'yes' ]] || [[ $update = 'y' ]]
						then
							docker_update
							State=0
						elif [[ $update = 'no' ]] || [[ $update = 'n' ]]
						then
							echo OK\!
							sleep 1
							State=0
						else
							echo I didn\'t understand\!
							sleep 0.5
							echo Please try again\!
							sleep 0.5
						fi
					done
			else
				docker_install
			fi
			sleep 1
			docker_init ;;
	start )
		sudo docker-compose up -d ;;
	control )
		echo "These are available options for you:" ; sleep 1
		echo -e "status\t\t Show service status"
		echo -e "freshclam\t Update ClamAV virus databases"
		echo -e "update\t\t Check and update container packages"
		echo -e "bash\t\t Start bash shell in container"
		echo -e "restart\t\t Restart ClamAV services"
		echo -e "exit\t\t Exit"
		echo "What can I do for you?"
		read -p "-> " operation
		case $operation in
			status )
				sudo docker-compose exec clamav clamer status;;
			freshclam )
				sudo docker-compose exec clamav clamer freshclam;;
			update )
				sudo docker-compose exec clamav clamer update;;
			bash )
				sudo docker-compose exec clamav bash;;
			restart )
				sudo docker-compose exec clamav clamer restart;;
			exit )
				echo Goodbye\!;;
		esac;;
	restart )
		sudo docker-compose restart;;
	stop )
		sudo docker-compose down;;
	* )
		help;;
	esac
fi