#!/usr/bin/env sh

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
\t\t\tPandoc
\t\t\t------\n
[Description]
A documents conversor tool

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
