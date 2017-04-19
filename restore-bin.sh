#!/bin/bash

# Author: ravexina 
# https://github.com/ravexina

# Repo on github
# https://github.com/ravexina/restore-bin

# Usage: 
# 	This script will restore the accidentally or on purpose removed /bin directory.
#
# Example: 
#       Chroot to broken system, run the script, it will asks the necessary questions
#

# Licensed under the GNU General Public License v3.0 

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your option) any later version.
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.

#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Creates a list of packages which are related to /bin, (has file there).
function create_list(){

	# Create a temp file to hold a list of packages related to /bin directory
	tmp=`mktemp`

	# Get a list of installed packages which got file in /bin
	dpkg -S "/bin" | cut -f1 -d: | tr "," "\n" | while read -r pkg;
	do
	# Get a list of files within the packages which belogns to the /bin
	files=`dpkg --listfiles "$pkg" | grep "^/bin/"`
 
	# Print out package details
	echo -e "\033[1;31m$pkg\n \033[0m" # Package name
	echo -e "\033[0;33mfiles:\n\033[1;30m$files \033[0m" # Files from this packages installed in /bin
	echo -e "\033[1;34m- - - - \033[0m \n" # Seperator
	echo "$pkg " >> $tmp # Append package name to our temp list
	
	done;
}

# Downloads the related deb packages and then moves only
# the necessary files to /bin
function move(){

	# Create a temp directory to hold and extract deb packages in it
	tmpdir=`mktemp -d`

	# Change directory to temp dir
	cd $tmpdir
	
	echo "Start downloading packages..."
	
	# Download deb packages
	xargs apt download < $tmp

	# Start extracting deb files
	for pkg in *.deb
	do
	 echo -e "Extracting: $pkg"
	 dpkg-deb -x "$pkg" $tmpdir
	done

	# Move the related files to /bin
	mv -T "$tmpdir/bin" "/bin" 2> /dev/null
	
	# Move deb packages to cache
	mv ./*.deb /var/cache/apt/archives/
	
	# Get out of temp dir then remove it
	cd
	rm -r $tmpdir
}

function reinstall(){
	echo "Start reinstall prcoess..."
	xargs apt install --reinstall --assume-yes < $tmp
}

# Start creating a list of packages which got files in /bin dir
create_list

# What should we do now
echo -e "\033[1;31mWhat should I do to fix the issue?"
echo -e "\033[1;34mm\033[0m: \033[0;33mDownload and move necessary files to /bin [Recommended]"
echo -e "\033[1;34mr\033[0m: \033[0;33mDownload and reinstall all required packages to fix the /bin"
echo -e "\033[1;34me\033[0m: \033[0;33mDo nothing, exit.\033[0m"
read func

# Call the appropriate function
case "$func" in
"e")
    exit
  ;;
"m")
    move
  ;;
"r")
    reinstall
  ;;
esac

echo "Done"