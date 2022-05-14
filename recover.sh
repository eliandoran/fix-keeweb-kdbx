#!/usr/bin/env bash

#
# Create a temporary directory.
#

dir=`mktemp -d`

function cleanup {
    rm -rf "$dir"
}

if [ ! -e "$dir" ]; then
    >&2 echo "Unable to create a temporary directory to store the XML files."
    exit 1
fi

trap cleanup EXIT

#
# Ask the user to add the XML files.
#
echo "In KeeWeb, go to the file settings and select \"Save to...\", then select \"XML\"."
echo "Save the XML to the following temporary directory: $dir"
echo "Please don't save it anywhere else to avoid security issues. The XML files are not encrypted."

if command -v xdg-open &> /dev/null
then
    xdg-open $dir &> /dev/null
fi

echo "After placing all your exported XML files, press Enter to continue."
read -n1