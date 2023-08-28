#!/bin/bash

# -----------------------------------------
# This script takes care of setting up the
# environment for the more-vim program
# Files are stored in the /src folder
# for later use
# ------------------------------------------

# get the name of the logged in user
user=`who -u | awk {'print $1'} | head -1`

# must be root run
if [ $UID -ne 0 ]; then
	echo "You need to be root"
	exit 1
else
	echo "Starting installation..."
fi

if [ -f /usr/bin/gcc ]; then
	echo "gcc exists"
else
	echo "gcc is required to compile code... but wasn't found".
	echo "install and try again..."

	exit 2
fi
# store files in a different directory for later use
if [ -d "/src" ]; then
	read -p "Directory '/src' exits... Do you want to continue? (y/n) " answer

	if [ $answer = 'y' ]; then
		echo "Thanks for your response... Continuing"
	elif [ $answer = 'n' ]; then
		echo "Exiting... No changes made"
		exit 0
	else
		echo "No valid response given... Run the program and try again"
		exit 3
	fi
else
	echo "Creating /src directory"
	mkdir /src
fi

# copy necessary files to their locations
echo "Copying neccessary files..."
cp -r ../resources/vim /src/vim
cp ../resources/vimrc /src/vimrc.unused
cp more-vim.c /src/

# remove existing .vim folder
if [ -d "/home/$user/.vim" ]; then
	echo ""
	echo "There's an existing /home/$user/.vim folder in your home directory..." 
	read -p "do you want overwrite it? (y/n) " overwrite
	if [ $overwrite = 'n' ]; then
		echo "Exiting installation..."
		exit 0
	elif [ $overwrite = 'y' ]; then
		rm -rf "/home/$user/.vim/"
		# copy the vim folder to user's directory... contains all plugins
		cp -r "../resources/vim/" "/home/$user/.vim"
		chown -R $user:$user /home/$user/.vim
	fi
else
	# copy the vim folder to user's directory... contains all plugins
	cp -r "../resources/vim/" "/home/$user/.vim"
	chown -R $user:$user /home/$user/.vim
fi

echo ""
echo "File copied successfully..."

# compile code and put in /usr/bin directory
gcc more-vim.c -o /usr/bin/more-vim

# create .vimrc file
touch /home/$user/.vimrc
chown $user:$user /home/$user/.vimrc

# everything is set now
echo "more-vim is ready now..."
echo ""
echo `more-vim --help` # show usage
