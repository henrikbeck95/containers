#!/usr/bin/env sh

#############################
#Declaring the variables
#############################

AUX1=$1

#SOFTWARE="docker"
SOFTWARE="podman"

SOFTWARE_REPOSITORY="docker.io"

SOFTWARE_IMAGE_NAME="henrikbeck95/convert-pdf-color"
#SOFTWARE_IMAGE_NAME="henrikbeck95/ffmpeg"
#SOFTWARE_IMAGE_NAME="henrikbeck95/youtube-dl"

#SOFTWARE_IMAGE_VERSION="v0.1"
SOFTWARE_IMAGE_VERSION="v1.0"

SOFTWARE_IMAGE_ID="convert_pdf_color"
#SOFTWARE_IMAGE_ID="ffmpeg"
#SOFTWARE_IMAGE_ID="pyenv"
#SOFTWARE_IMAGE_ID="youtube-dl"
#localhost/henrikbeck95/pyenv:v0.1

MESSAGE_HELP="
\t\t\tContainer hub
\t\t\t-------------\n
[Description]
Manage container repository hub accounts such as DockerHub.

[Parameters]
-h\t--help\t-?\t\tDisplay this help message
-b\t--build\t\t\tBuild the $SOFTWARE_IMAGE_NAME container image
-e\t--edit\t\t\tEdit this script file
-l\t--login\t\t\tLogin to DockerHub
-p\t--push\t\t\tPush the container image to DockerHub
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_HELP"

#############################
#Functions
#############################

display_message(){
	echo -e "#############################\n#$1...\n#############################"
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

docker_hub_login(){
	$SOFTWARE login docker.io
}

docker_hub_push(){
	#$SOFTWARE push $SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION
	display_message "Pushing $SOFTWARE_IMAGE_ID to docker://$SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION"

	$SOFTWARE push $SOFTWARE_IMAGE_ID docker://$SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION
}

#############################
#Calling the functions
#############################

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;;
	#"-" | "--")
	"-b" | "--build") container_build ;;
	"-l" | "--login") docker_hub_login ;;
	"-p" | "--push") docker_hub_push ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
