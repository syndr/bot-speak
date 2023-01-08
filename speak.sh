#!/bin/env bash
#
# Say things or save them to disk!

################ CONFIGURATION ################

# Set this to the URL of a Mimic3 instance.
#
# If you do not already have Mimic3 running somewhere, you can run it on your machine via
# docker as described here:
#    https://mycroft-ai.gitbook.io/docs/mycroft-technologies/mimic-tts/mimic-3#docker-image
# and set this variable to "http://localhost:59126"
#MIMIC3_URL="https://mimic.ucs-1.ultroncore.net"

###############################################

# Command line options
if [[ $1 == "-h" ]]; then
    echo "
    It's nice to be able to talk, isn't it?
   

    USAGE:

     ./speak.sh [voice #] [\"Thing to say\"] [output file (optional)]

     -b   Batch Mode
          ./speak.sh [voice #] [file name] [output file (optional)]


    Mimic3 is used to speak, so that must be running! Set the MIMIC3_URL environment
    variable to its' http(s) location.

    "
    exit 0
elif [[ $1 == "-b" ]]; then
    OP_MODE="batchfile"
else
    OP_MODE="default"
fi


speak () {
    MIMIC_VOICE=$1
    INPUT_TEXT=$2
    OUTPUT_FILE=$3
    
    effect_1="pitch 43"
    effect_2="phaser 0.89 0.85 1 0.24 2 -t"
    effect_3="chorus 0.6 0.9 90 0.4 0.25 2 -t 70 0.32 0.4 1.3 -s 40 0.3 0.3 1.3 -s"
    effect_4="overdrive 7 30"
    effect_5="bend .35,80,.25 0,-120,.3 .5,200,.5 0,-50,.3"
    effect_6="dither"
    
    case $MIMIC_VOICE in
        1) MIMIC_VOICE_STRING="--voice en_US/m-ailabs_low --speaker mary_ann";;
        2) MIMIC_VOICE_STRING="--voice en_US/ljspeech_low";;
        3) MIMIC_VOICE_STRING="--voice en_US/m-ailabs_low --speaker elliot_miller";;
        4) MIMIC_VOICE_STRING="--voice en_US/vctk_low --speaker p287";;
        *) echo "I don't support that voice!" && exit 1;;
    esac

    echo -e "\nCreating words with voice $MIMIC_VOICE using Mimic3 voice string: $MIMIC_VOICE_STRING \n"
    
    if [ ! -d ./speak_scratch ]; then
        mkdir ./speak_scratch
    fi
    
    mimic3 --remote $MIMIC3_URL --length-scale 1.6 $MIMIC_VOICE_STRING --output-dir ./speak_scratch --output-naming time "$INPUT_TEXT"
    
    filename=$(ls ./speak_scratch/)
    
    if [[ $OUTPUT_FILE ]]; then
        sox ./speak_scratch/$filename $OUTPUT_FILE $effect_1 $effect_2 $effect_3 $effect_4 $effect_5 $effect_6 
    elif [[ $INPUT_TEXT ]]; then
        play ./speak_scratch/$filename $effect_1 $effect_2 $effect_3 $effect_4 $effect_5 $effect_6 
    fi
    
    rm -rf ./speak_scratch
}

if [[ ! $MIMIC3_URL ]]; then
    MIMIC3_URL="http://localhost:59125"
fi


if [[ $OP_MODE == "default" ]]; then
    speak "$1" "$2" "$3"
elif [[ $OP_MODE == "batchfile" ]]; then
    voice=$2
    input_path=$3
    output_path=$4

    # Make an iterator
    i=0
    declare -i i

    while IFS= read -r line
    do
        i+=1
        if [[ $output_path ]]; then
            speak $voice "$line" "$output_path/$i.wav"
        else
            speak $voice "$line"
        fi

    done < $input_path
fi

exit 0
