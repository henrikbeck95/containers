FROM docker.io/library/alpine:3.14
MAINTAINER Henrik Beck <henrikbeck95@gmail.com>

#Install essential softwares
RUN apk update && apk add --no-cache ghostscript imagemagick

#Edit the policies of ImageMagick in /etc/ImageMagick-7/policy.xml
RUN rm /etc/ImageMagick-7/policy.xml
ADD policy.xml /etc/ImageMagick-7/policy.xml

#Copy convert.sh script file from host to container
ADD converting.sh /converting.sh

#Execute convert.sh script file
RUN chmod +x /converting.sh
