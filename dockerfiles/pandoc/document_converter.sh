#!/usr/bin/env sh

#############################
#Instructions
#############################
#
#Reference
#- [Pandoc commands demo usage](https://pandoc.org/demos.html)
#- [Create a publication chain with Pandoc and Docker](https://www.toptal.com/docker/pandoc-docker-publication-chain)
#
#Description
#Converting Markdown to others documents formats using Pandoc from container.
#Be sure the file you want to convert is inside this script file folder directory.
#############################

#############################
#Declaring variables
#############################

NUMBER=2
AUX1=$1
AUX2=$2
AUX_ALL="${@:NUMBER}" #All paramenters except or starting from the second.

#SOFTWARE="docker"
SOFTWARE="podman"
SOFTWARE_IMAGE="docker.io/pandoc/latex:latest"

MESSAGE_HELP="
\t\t\tDocuments conversor
\t\t\t-------------------\n
[Parameters]
-h\t--help\t-?\t\t\tDisplay this help message
-e\t--edit\t\t\t\tEdit this script file
-c\t--container-usage\t\tUse the container for converting files
-p\t--container-pull\t\tDownload the $SOFTWARE_IMAGE container image
-r\t--container-remove\t\tRemove the $SOFTWARE_IMAGE container image

[Example]
Converting Markdown to Docx: > $ $0 -c README.md -s -o testing.docx
Converting Markdown to HTML: > $ $0 -c README.md -s -o testing.html
Converting Markdown to PDF: > $ $0 -c README.md -s -o testing.pdf

[In case of problems...]
$SOFTWARE run -it --rm -v /home/joker/sharing/projects_myself/trabalho_conclusao_curso/utils:/work/ -w /work/ docker.io/pandoc/latex README.md -o testing.pdf
"

MESSAGE_ERROR="Invalid option for $0!\n$MESSAGE_ERROR"

#############################
#Functions
#############################

display_message(){
	echo -e "#############################\n#$1\n#############################\n"
}

container_pull(){
	$SOFTWARE pull $SOFTWARE_IMAGE
}

container_remove(){
	$SOFTWARE image rm -f $SOFTWARE_IMAGE
}

container_usage(){
	#display_message "$SOFTWARE run -it --rm -v $(pwd):/work/ -w /work/ $SOFTWARE_IMAGE README.md -o lalala.pdf"
	#$SOFTWARE run -it --rm -v $(pwd):/work/ -w /work/ $SOFTWARE_IMAGE README.md -o lalala.pdf

	display_message "Running the command... > $ $SOFTWARE run -it --rm -v $(pwd):/work/ -w /work/ $SOFTWARE_IMAGE \"$AUX_ALL\""
	$SOFTWARE run -it --rm -v $(pwd):/work/ -w /work/ $SOFTWARE_IMAGE $AUX_ALL
}

#############################
#Calling the function
#############################

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;; 
	"-c" | "--container-usage") container_usage ;;
	"-p" | "--container-pull") container_pull ;;
	"-r" | "--container-remove") container_remove ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
