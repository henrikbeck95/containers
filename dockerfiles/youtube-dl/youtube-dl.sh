#!/usr/bin/env sh

#############################
#Instructions
#############################
#
#Reference
#- [DockerHub](https://hub.docker.com/r/wernight/youtube-dl)
#- [Youtube-dl tutorial with examples for beginners](https://ostechnix.com/youtube-dl-tutorial-with-examples-for-beginners/)
#
#Description
#Download videos from YouTube using the Linux command line interface (CLI).
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
#SOFTWARE_REPOSITORY="docker.io"
SOFTWARE_REPOSITORY="localhost"
SOFTWARE_IMAGE_NAME="henrikbeck95/youtube-dl"
SOFTWARE_IMAGE_VERSION="v1.0"

MESSAGE_HELP="
\t\t\tYoutube video downloader
\t\t\t------------------------\n
[Parameters]
-h\t--help\t-?\t\t\tDisplay this help message
-e\t--edit\t\t\t\tEdit this script file
-b\t--build\t\t\t\tBuild the $SOFTWARE_IMAGE_NAME container image
-c\t--container-usage\t\tUse the container for using YouTude-dl with parameters
-best\t--container-usage-best\t\tUse the container for downloading video and audio file
-mp3\t--container-usage-mp3\t\tUse the container for downloading .mp3 audio file
-mp4\t--container-usage-mp4\t\tUse the container for downloading .mp4 video file
-p\t--container-pull\t\tDownload the $SOFTWARE_IMAGE_NAME container image
-r\t--container-remove\t\tRemove the $SOFTWARE_IMAGE_NAME container image

[Example]
Download a Youtube video: > $ $0 -c https://www.youtube.com/watch?v=WPY84d6enyc
Download many Youtube videos: > $ $0 -c best $(cat ./youtube_video_links.txt)

[In case of problems...]
$SOFTWARE run --rm -v $(pwd):/downloads:rw $SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION -f mp4 -o '%(title)s.%(ext)s' <youtube_link>
"

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
	$SOFTWARE run --rm \
		-v $(pwd):/downloads \
		$SOFTWARE_REPOSITORY/$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION \
		$AUX_ALL
}

container_usage_mp3(){
	$SOFTWARE run --rm \
		-v $(pwd):/downloads:rw \
		$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION \
		-f bestaudio --extract-audio --audio-format mp3 --audio-quality 0 \
		-o '%(title)s.%(ext)s' \
		$AUX_ALL
}

container_usage_mp4(){
	$SOFTWARE run --rm \
		-v $(pwd):/downloads:rw \
		$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION \
		-f mp4 \
		-o '%(title)s.%(ext)s' \
		$AUX_ALL
}

container_usage_best(){
	$SOFTWARE run --rm \
		-v $(pwd):/downloads:rw \
		$SOFTWARE_IMAGE_NAME:$SOFTWARE_IMAGE_VERSION \
		-f best \
		-o '%(title)s.%(ext)s' \
		$AUX_ALL
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
	"-best" | "--container-usage-best") container_usage_best ;;
	"-mp3" | "--container-usage-mp3") container_usage_mp3 ;;
	"-mp4" | "--container-usage-mp4") container_usage_mp4 ;;
	"-p" | "--container-pull") container_pull ;;
	"-r" | "--container-remove") container_remove ;;
	*) echo -e "$MESSAGE_ERROR" ;;
esac
