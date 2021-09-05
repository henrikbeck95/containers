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
\t\t\t\t\tPandoc
\t\t\t\t\t------\n
[Description]
A documents conversor tool

[Parameters]
-h\t--help\t-?\t\t\t\tDisplay this help message
-e\t--edit\t\t\t\t\tEdit this script file
-c\t--container-usage\t\t\tUse the container for converting files
-td\t--theme-dracula\t\t\t\tUse the container for converting files with Dracula
-p\t--container-pull\t\t\tDownload the $SOFTWARE_IMAGE container image
-r\t--container-remove\t\t\tRemove the $SOFTWARE_IMAGE container image

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
	$SOFTWARE run -it --rm -v $(pwd):/work/ -w /work/ $SOFTWARE_IMAGE $AUX_ALL
}

container_usage_theme_dracula(){
	#download_theme_dracula_files
	mkdir -p ./output/

	local FILENAME_INPUT="./input/*.md"
	local FILENAME_OUTPUT="./output/dracula_theme.pdf"

	$SOFTWARE run -it --rm \
		-v $(pwd):/work/ \
		-v /usr/share/fonts/:/usr/share/fonts/ \
		-v $HOME/.fonts/:/usr/local/share/fonts/ \
		-w /work/ \
		$SOFTWARE_IMAGE \
		\
		$FILENAME_INPUT \
		--defaults=./dracula/dracula.yaml \
		--filter pandoc-crossref \
		-V fontsize=12pt \
		-V documentclass=report \
		\
		-V geometry:a4paper \
		-V geometry:margin=2cm \
		-V mainfont="FreeSerif" \
		-V monofont="FreeMono" \
		--pdf-engine=xelatex \
		\
		--output=$FILENAME_OUTPUT
}

#############################
#Download raw files
#############################

download_theme_dracula_files(){
	mkdir -p ./dracula/
	cd ./dracula/

	curl -LO https://raw.githubusercontent.com/dracula/pandoc/master/dracula.yaml #This one must be edited the paths values
	curl -LO https://raw.githubusercontent.com/dracula/latex/master/draculatheme.sty
	curl -LO https://raw.githubusercontent.com/dracula/pandoc/master/dracula.theme
	#curl -LO https://gist.githubusercontent.com/scastiel/4c409156ad4bc6a6dbbfe2abbd163671/raw/374eef0890c2794dc81c4c9816555b68a0960a32/dracula.theme
	cd -
}

#############################
#Calling the function
#############################

clear

case $AUX1 in
	"" | "-h" | "--help" | "-?") echo -e "$MESSAGE_HELP" ;;
	"-e" | "--edit") $EDITOR $0 ;; 
	"-c" | "--container-usage") container_usage ;;
	"-td" | "--theme-dracula") container_usage_theme_dracula ;;
	"-p" | "--container-pull") container_pull ;;
	"-r" | "--container-remove") container_remove ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
