#!/usr/bin/env bash

function askForExport {
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
}

function patchXml {
    file=$1
    
    function removeSelfClosingElement {
        sed -i "s/<$1\s*\/>//g" "$file"
    }

    removeSelfClosingElement "EnableSearching"
    removeSelfClosingElement "EnableAutoType"
    removeSelfClosingElement "MaintenanceHistoryDays"
    removeSelfClosingElement "MasterKeyChange\w*"
}

function importXml {
    keepassxc-cli import "$1" "$2"
    echo "The XML was exported back to a KDBX to $2"
}

function patchAll {
    # Patch all files in the temp directory.
    for file in *.xml
    do
        [ -e "$file" ] || continue
        patchXml "$file"
        importXml "$file" "$file.kdbx"
    done

    rm *.xml

    echo
    echo "The files have been successfully fixed. Move the KDBX files to somewhere safe and press ENTER."
    echo "The temporary directory '$dir' will be removed." 
    read -n 1 
}

# Advanced usage
if [ $# -eq 1 ]
then
    patchXml "$1"
    importXml "$1" "$1.kdbx"
    exit 0
fi

# Basic usage
# Create a temporary directory.
dir=`mktemp -d`

function cleanup {
    echo "Removing '$dir'"
    rm -rf "$dir"
}

if [ ! -e "$dir" ]; then
    >&2 echo "Unable to create a temporary directory to store the XML files."
    exit 1
fi

trap cleanup EXIT

cd "$dir"
askForExport
patchAll
