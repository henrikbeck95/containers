# Convert PDF color

## Description

This tool is a specific color converter for PDF documents. This tool can be very useful if your printer hardware does not prints a specific tint color.

## Installation

- Build container
	> $ `convert_pdf_color.sh -b`

## Usage

### The script usage

- The document file

By default the PDF filename must be **input.pdf** and it must be storage in the root of the project. Otherwise the file is not going to be converted.

The converted result is going to recieve the **output.pdf** filename.

- Colors

By default the PDF color convertion is replacing **black** to **blue**. You can change this settings by editing the converting.sh file.

- Give executable permission
	> $ `chmod +x convert_pdf_color.sh`

- Check help info
	> $ `convert_pdf_color.sh -h`

- Convert PDF colors
	> $ `convert_pdf_color.sh -c`

### The manually mode

Be sure to replace **$YOUR_HOST_PATH** by the PDF file path you want to convert.

- Docker
	$ `$docker run --volume /$YOUR_HOST_PATH:/tmp/ localhost/convert_pdf_color:0.1 /converting.sh --container`

- Podman
	$ `$podman run --volume /$YOUR_HOST_PATH:/tmp/ localhost/convert_pdf_color:0.1 /converting.sh --container`
