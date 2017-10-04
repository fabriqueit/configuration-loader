#!/bin/sh
# This script is a classical bourn shell script so syntaxe may be differe from classical bash script.
# I intentionaly use sh because is the only one shell available by default on Alpine Linux.

# Get the script name
package=$0

# Show how to use the current script
usage ()
{
    echo "$package - Download (a) file(s) from a URL into (a) local file(s)"
    echo " "
    echo "$package [options]"
    echo " "
    echo "options:"
    echo "\t-h, --help                show brief help"
    echo "\t-u, --url=URL             specify an url where to download a file"
    echo "\t-o, --output=DIR          specify a directory to store output in"
    echo "\t-l, --list-url=URL        specify a directory to store output in"
    exit 0
}

# Method used to download a url into a specific file
download_file_from_url ()
{
  wget -qO $1 $2
}

# Create a directory from a dirname of a file
create_directory ()
{
  DIRECTORY=$(dirname "$1")
  mkdir -p $DIRECTORY
}

# Do nothing if there is no options
if [ $# -eq 0 ]; then
  echo "No arguments supplied, nothing to do!"
  usage
  exit 0
fi

# Use getopt to parse option for the current script
OPTS=`getopt -o hl:u:o: -l help,list-url:,url:,output: -- "$@"`
eval set -- "$OPTS"

while true ; do
  case $1 in
    -h|--help)
      usage; shift;;
    -l|--list-url)
      FILE_LIST_URL="$2"; shift 2;;
    -u|--url)
      URL="$2"; shift 2;;
    -o|--output)
      OUTPUT="$2"; shift 2;;
    --)
      shift; break;;
  esac
done

if [ ! -z "$URL" ] && [ ! -z "$OUTPUT" ]; then
  create_directory "${OUTPUT}"
  download_file_from_url $OUTPUT $URL
elif [ ! -z "$FILE_LIST_URL"  ]; then
  # Download the list file
  download_file_from_url /tmp/list $FILE_LIST_URL
  cat /tmp/list | while read line; do
    set $line
    if [ $# -ne 2 ]; then
      echo "There is no two arguments on each line of the list file"
      exit 0
    fi
    create_directory "$1"
    download_file_from_url $1 $2
  done
  # Delete the list file
  rm /tmp/list
else
  echo "Nothing to do"
  usage
fi
