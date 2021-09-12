#!/usr/bin/env sh

#############################
#Declaring variables
#############################

#NUMBER=2
AUX1=$1
#AUX2=$2
#AUX_ALL="${@:NUMBER}" #All paramenters except or starting from the second.

#SOFTWARE="docker"
SOFTWARE="podman"
#SOFTWARE_REPOSITORY="docker.io"
SOFTWARE_REPOSITORY="localhost"
SOFTWARE_IMAGE_NAME="henrikbeck95/task-warrior"
SOFTWARE_IMAGE_VERSION="v1.0"

MESSAGE_HELP="
\t\t\tTaskWarrior
\t\t\t-----------\n
[Description]
Manage task notes using the Linux command line interface (CLI).

[Parameters]
-h\t--help\t-?\t\t\tDisplay this help message
-e\t--edit\t\t\t\tEdit this script file
-b\t--build\t\t\t\tBuild the $SOFTWARE_IMAGE_NAME container image
-c\t--container-usage\t\tUse the container for using TaskWarrior with parameters
-p\t--container-pull\t\tDownload the $SOFTWARE_IMAGE_NAME container image
-r\t--container-remove\t\tRemove the $SOFTWARE_IMAGE_NAME container image
"

#[Example]
#Download a Youtube video: > $ $0 -c https://www.youtube.com/watch?v=WPY84d6enyc
#Download many Youtube videos: > $ $0 -c best $(cat ./youtube_video_links.txt)

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_ERROR"

#############################
#Functions
#############################

display_message(){
	echo -e "#############################\n#$1\n#############################\n"
}

container_build(){
	case $SOFTWARE in
		"docker")
			display_message "Building $SOFTWARE $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION..."
			docker build --tag $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION .
			;;
		"podman")
			display_message "Building $SOFTWARE $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION..."
			buildah bud --layers=true --tag $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION .
			;;
		*)
			echo -e "$MESSAGE_ERROR"
			exit 0
			;;
	esac
}

container_pull(){
	$SOFTWARE pull $SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION
}

container_remove(){
	$SOFTWARE image rm -f $SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION
}

container_usage(){
	local SOFTWARE_CONTAINER_NAME="my_task_list"

	#Check if container already exists
	if [ ! "$($SOFTWARE ps -q -f name=$SOFTWARE_CONTAINER_NAME)" ]; then
		if [ "$($SOFTWARE ps -aq -f status=exited -f name=$SOFTWARE_CONTAINER_NAME)" ]; then
			display_message "Checking if container is stopped..."
			$SOFTWARE start $SOFTWARE_CONTAINER_NAME
		
		else
			display_message "Creating a new container..."

			$SOFTWARE run -d \
				--name $SOFTWARE_CONTAINER_NAME \
				$SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION
		fi
	fi

	#Get into container
	display_message "Getting into the container..."
	$SOFTWARE attach $SOFTWARE_CONTAINER_NAME
}

#############################
#Calling the function
#############################

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;; 
	"-b" | "--build") container_build ;;
	"-c" | "--container-usage") container_usage ;;
	"-p" | "--container-pull") container_pull ;;
	"-r" | "--container-remove") container_remove ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
