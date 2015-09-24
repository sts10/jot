#!/bin/bash

MAP="/Users/samschlinkert/Documents/code/jot/path.txt"

INPUT="$*"
CURRENTDIR=$(pwd)
echo "pwd in here is"
echo $CURRENTDIR

JOT_ROUTE=$(<$MAP)

cd $JOT_ROUTE


load_notes(){
  echo 'Here are your jots:'
  echo ''

  FILENAME="q"

  PS3="Type a number or 'q' to quit: "

  # Create a list of files to display  http://wuhrr.wordpress.com/2009/09/10/simple-menu-with-bashs-select-command/
  fileList=$(find . -maxdepth 1 -type f \( ! -iname ".*" \))  # ignores dot files like .DS_STORE 

  # Show a menu and ask for input. 
  select draftFileName in $fileList; do
    if [ -n "$draftFileName" ]; then
      FILENAME=${draftFileName}
    fi
    break
  done

  if [[ $FILENAME == "q" ]]
  then
    echo ''
    echo "Quitting..."
    exit 
  fi

  if [ ! -f $FILENAME ]  # if user entry does not match an existing draft file name. 
  then
    echo ''
    echo "Sorry, I don't have that draft. Goodbye."
    # cd $cwd
    exit 
  fi

  echo "opening file"
  mvim $FILENAME
}


if [[ $INPUT == "here" ]]
then 
  NEW_PATH=$(pwd)
  echo "$NEW_PATH/" > $MAP 
  echo "Now jotting in "$NEW_PATH
elif [[ $INPUT == "where" ]]
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
  echo "jot here to place the jot."
  echo "jot where to ask where you're currently jotting."
  echo "jot <file name, no extension> to jot a new file."
elif [[ $INPUT == "all" ]]
then 
  mvim $JOT_ROUTE
elif [[ $INPUT == "select" ]]
then
  load_notes
else
  #INPUT=$1
  #INPUT=$*
  #NOTE_TITLE=${$INPUT// /-}      # replace all spaces with hyphens
  NOTE_TITLE=$INPUT
  touch "$NOTE_TITLE".mdown 
  mvim "$NOTE_TITLE".mdown
fi




