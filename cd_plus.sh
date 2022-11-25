#!/usr/bin/bash

# 0- source this script to get cd+ function defined
# 1- initialize at some project root directory : cd+ -init
# 2- change to inner directories and bookmark it : cd+ -book
# 3- list all projects : cd+ -dir
# 4- list all bookmarks in active project : cd+ -list
# 5- jump to bookmarked directory "path1/path2/namesuffix" 
#    at different branch : cd+ suffix

function cd+ {
  local current=`pwd`
  local cd_plus_d=$CD_PLUS_DIRECTORY
  local op=$1

  if [[ ($op != "-init") && (! -f ${cd_plus_d}/directory) ]]; then
    echo cd+ not initialized, run -init first
    return
  fi

  case $op in 
    (-init)
      cd_init
      ;;
    (-list)
      cd_list
      ;;
    (-dir)
      cd_dir $*
      ;;
    (-book)
      cd_book 
      ;;
    (-help)
      echo operations: -init -book -list -dir
      ;;
    (*)
      cd_jump $1
  esac;
}
export -f cd+
export CD_PLUS_CURRENT=''
export CD_PLUS_DIRECTORY=~/.local/share/cd_plus

function cd_init {
  echo init
  local cd_plus_d=$CD_PLUS_DIRECTORY

  if [[ ! -f ${cd_plus_d}/directory ]]; then
    mkdir -p $cd_plus_d
    touch ${cd_plus_d}/directory 
  fi
  touch .cd_bookmarks
  entry=`pwd`
  \grep -qE "^${entry}$" ${cd_plus_d}/directory
  if [[ $? -ne 0 ]]; then
    echo $entry >> $cd_plus_d/directory
  fi
}

function cd_get_active {
  local current=`pwd`
  local cd_plus_d=$CD_PLUS_DIRECTORY

  if [[ (-f $CD_PLUS_CURRENT/.cd_bookmarks) && ($current =~ ^$CD_PLUS_CURRENT) ]]
  then
    echo $CD_PLUS_CURRENT
  else
    current_match=$current
    local active=''
    while read entry; do
      if [[ ($current =~ $entry) && ($current_match =~ ${current#$entry}$) ]]; then
        current_match=${current#$entry}
        active=$entry
      fi
    done < $cd_plus_d/directory
    echo $active
  fi
}

function cd_book {
  local book=`pwd`
  
  local active=$(cd_get_active)

  if [[ -z $active ]]; then
    echo no active parent directory was found
    return
  fi
  if [[ $book == $active ]]; then
    echo not bookmarked, already at root
    return
  fi

  book=${book#$active}
  \grep -qE "^${book}$" ${active}/.cd_bookmarks
  if [[ $? -ne 0 ]]; then
    echo $book >> ${active}/.cd_bookmarks
    echo $book_name booked at $active
  else
    echo $book_name already exists at $active
  fi
  CD_PLUS_CURRENT=$active
}

function cd_dir {
  local cd_plus_d=$CD_PLUS_DIRECTORY
  
  if [[ -n $2 ]]; then
    matches=(`\grep -E "${2}$" $cd_plus_d/directory`)
    if [[ ${#matches[@]} -gt 0 ]]; then
      cd ${matches[0]}
      return
    else
      echo directory ${2} did not match suffix
    fi
  fi
  cat $cd_plus_d/directory
}

function cd_list {
  local active=$(cd_get_active)

  if [[ -z $active ]]; then
    echo no active parent directory was found
    return
  fi

  cat $active/.cd_bookmarks
}

# if same bookmark exists in different entries then first one will be chosen
function cd_jump {
  local book=$1
  local active=$(cd_get_active)

  if [[ -z $active ]]; then
    echo no active parent directory was found
    return
  fi

  matches=(`\grep -E "${book}$" ${active}/.cd_bookmarks`)
  if [[ ${#matches[@]} -gt 0 ]]; then
    cd ${active}${matches[0]}
  else
    echo $book not found
  fi 
}
