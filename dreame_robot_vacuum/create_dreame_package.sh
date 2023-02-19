#!/bin/env bash
#
# Create an voice pack for Dreame vacuum cleaners, given appropriately named .wav audio files.
#

INPUT_FOLDER=$1
OUTPUT_TITLE=$2

# Command line options
if [[ $1 == "-h" ]] || [[ ! $1 ]]; then
    echo "
    Create an voice pack for Dreame vacuum cleaners, given appropriately named .wav audio files.
   

    USAGE:

     ./create_dreame_package.sh [input folder] [package name]

    
    The vorbis-tools package or comparable providing the 'oggenc' application is required.

    "
    exit 0
fi

INPUT_BASE_DIR=$(dirname $INPUT_FOLDER)
INPUT_FOLDER=$(basename $INPUT_FOLDER)

echo "Changing to directory: $INPUT_BASE_DIR"
cd $INPUT_BASE_DIR

echo "Creating directory: $OUTPUT_TITLE-16k"
mkdir $OUTPUT_TITLE-16k

for x in $INPUT_FOLDER/*.wav; do
    echo "Encoding: $x"
    oggenc $x -o $(echo $x | sed -e "s/$INPUT_FOLDER/$OUTPUT_TITLE-16k/" | sed -e "s/.wav/.ogg/") -b 100 --resample 16000
done

echo "Creating gzip archive..."
cd $OUTPUT_TITLE-16k
tar czf ../$OUTPUT_TITLE-16k.tar.gz *.ogg
cd ..

echo -e "Complete.\nArchive is: $OUTPUT_TITLE-16k.tar.gz"

echo "Calculating checksum..."
checksum=$(md5sum $OUTPUT_TITLE-16k.tar.gz)
echo "Checksum is: $checksum"
