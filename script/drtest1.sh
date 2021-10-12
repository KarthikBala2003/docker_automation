#!/bin/bash

# ./Test2.sh -b httpd -c webserver1 -p 9090 -m "This is first Docker App..."

BASE_IMAGE_NAME=httpd
CUSTOM_IMAGE_NAME=webserver1
PORT_NUMBER=5354
DOCKER_INTERNAL_PORT=80
WEB_SERVER_MSG="This is first Docker App..."
HTML_PAGE_NAME=myhtml.html
HTDOCS=htdocs

# Initializing Input Parameters
while getopts b:c:p: option
	do
		case "${option}"
		in
		b) BASEIMAGE=${OPTARG};;
		c) CUSTOMIMAGE=${OPTARG};;
		p) PORT=${OPTARG};;
		m) MSG=${OPTARG};;
		esac
	done
	
# BASEIMAGE_NAME="${BASEIMAGE:-$BASE_IMAGE_NAME}"
# CUSTOMIMAGE_NAME="${CUSTOMIMAGE:-$CUSTOM_IMAGE_NAME}"
# CUSTOM_PORT="${PORT:-$PORT_NUMBER}"

# Read the user input   
# Check base image name is empty  
if [ -z "$BASEIMAGE" ]; then 
	echo "Enter base image name to pull: "  
	read BASEIMAGE_NAME
	echo
fi

BASEIMAGE_NAME="${BASEIMAGE_NAME:-$BASE_IMAGE_NAME}"

# Check custom image name is empty  
if [ -z "$CUSTOMIMAGE" ]; then 
	echo "Enter custom image name: "  
	read CUSTOMIMAGE_NAME
	echo
fi

CUSTOMIMAGE_NAME="${CUSTOMIMAGE_NAME:-$CUSTOM_IMAGE_NAME}"

# Check custom port is empty  
if [ -z "$PORT" ]; then 
	echo "Enter custom port: "  
	read CUSTOM_PORT
	echo
fi

CUSTOM_PORT="${CUSTOM_PORT:-$PORT_NUMBER}"

# Check custom message for webserver is empty  
if [ -z "$MSG" ]; then 
	echo "Enter custom message to display on the webpage: "  
	read CUSTOM_MSG
	echo
fi

CUSTOM_MSG="${CUSTOM_MSG:-$WEB_SERVER_MSG}"

# Displaying Supplied Parameters
echo "Note: If required parameters supplied, default values will be set"
echo "Base Image Name: " $BASEIMAGE_NAME
echo "Custom Image Name: " $CUSTOMIMAGE_NAME
echo "Custom Port: " $CUSTOM_PORT
echo "Custom Message: " $CUSTOM_MSG
echo

# :<<'EOF'
# Pull supplied base image from docker hub
# echo "Pulling supplied base image $BASEIMAGE_NAME from docker hub..."
# echo
# docker pulll $BASEIMAGE_NAME

# Running Docker Image
echo
echo "Runing Docker image..."
echo
container_id=$(docker run -d --name $CUSTOMIMAGE_NAME -p $CUSTOM_PORT:$DOCKER_INTERNAL_PORT $BASEIMAGE_NAME | cut -c1-12)

echo "$BASEIMAGE_NAME container has been created, container_id: $container_id"

# Executing Docker Image to enter into bash
echo
echo "Executing Docker image and Entering into bash..."
echo

docker exec -d $CUSTOMIMAGE_NAME touch $HTDOCS/$HTML_PAGE_NAME

# if [ $? -eq 0 ]
# then
  # echo "New custom $HTML_PAGE_NAME webpage created..."
  # exit 0
# else
  # echo "The script failed" >&2
  # exit 1
# fi

docker exec -d $CUSTOMIMAGE_NAME sh -c "echo '$CUSTOM_MSG' >> $HTDOCS/$HTML_PAGE_NAME"

if [ $? -eq 0 ]
then
  echo "New custom message added into webpage..."
  echo "Click below link to view your custom webpage..."
  echo "http://localhost:$CUSTOM_PORT/$HTML_PAGE_NAME"
  exit 0
else
  echo "The script failed" >&2
  exit 1
fi

exit

