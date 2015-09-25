#!/bin/bash

INPUT="$*"

JOT_ROUTE="/Users/"$USER"/Dropbox/notes/"
cd $JOT_ROUTE


load_notes(){
  echo 'Here are your jots:'
  echo ''

  FILENAME="q"

  PS3="Type a number or 'q' to quit: "

  # Create a list of files to display  http://wuhrr.wordpress.com/2009/09/10/simple-menu-with-bashs-select-command/
  fileList=$(find . -maxdepth 1 -type f \( ! -iname ".*" \) | sort -n)  # ignores dot files like .DS_STORE 

  # Show a menu and ask for input. 
  select noteFileName in $fileList; do
    if [ -n "$noteFileName" ]; then
      FILENAME=${noteFileName}
    fi
    break
  done

  if [[ $FILENAME == "q" ]]
  then
    echo ''
    echo "Quitting..."
    exit 
  fi

  if [ ! -f $FILENAME ]  # if user entry does not match an existing note file name. 
  then
    echo ''
    echo "Sorry, I don't have that note. Goodbye."
    exit 
  fi

  echo "Opening file "$FILENAME
  mvim $FILENAME
}


if [[ $INPUT == "where" ]]
then
  echo "You're jotting in "$JOT_ROUTE

  echo "Do you want to go there? (y/n) "
  read -p "" -n 1 -r  
  echo ''   # move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]] 
  then
    cd $JOT_ROUTE
  fi
elif [[ $INPUT == "help" ]]
then
  echo "jot <file name, no extension> to jot a new file"
  echo "jot select to be presented with list of your files"
  echo "jot all to open all your notes in your text editor"
  echo "jot where to ask where you're currently jotting"
elif [[ $INPUT == "all" ]]
then 
  mvim $JOT_ROUTE
elif [[ $INPUT == "select" ]]
then
  load_notes
else
  NOTE_TITLE=${INPUT// /-}      # replace all spaces with hyphens
  touch "$NOTE_TITLE".mdown 
  mvim "$NOTE_TITLE".mdown
fi
