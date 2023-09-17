#!/bin/bash

# This file will be called by AB auto-eval script

# Get Input from the Users
[ ! -z "${1}" ] && TEAM_ID="${1}"

if [[ $# -eq 0 ]]; then
    echo -e "\e[33mPlease enter your Team ID :)\e[0m"
    exit 0
fi

# Folder Name
FOLDER_NAME=ab_task0_$TEAM_ID

# Folder Location
SUBMISSION_FOLDER=$FOLDER_NAME

# Flag to check files and folders existence
QUARTUS_FOLDER_PRESENT=0
RISCV_FOLDER_PRESENT=0
JSON_FILE_PRESENT=0

# Check if required folders are present
for project in "AND_GATE" "ripple_carry_adder" "sequence_detector"; do
    if [ -d $project ]; then
        QUARTUS_FOLDER_PRESENT=1
    else # echo Problem
        echo -e "\e[31m$project Quartus Project folder not found.\e[0m"
    fi
done

if [ -f "riscv_compiler_test/output.hex" ]; then
    RISCV_FOLDER_PRESENT=1
else
    echo -e "\e[31mRISC-V Compiler Test Output files are not present.\e[0m"
fi

# Find result*.json file
if [ "$(find -type f -name 'result*.json' | wc -l)" -gt 0 ]; then
    JSON_FILE_PRESENT=1
else
    echo -e "\e[31mJSON File is not present in the current directory\e[0m"
    echo -e "Please run the following command and then re-run the script."
    echo -e "\e[37meyantra-autoeval evaluate --year 2023 --theme AB --task 0\e[0m"
fi

# If all the folders exists, copy required folders to the Submission Folder
if [[ $QUARTUS_FOLDER_PRESENT -eq 1 && $RISCV_FOLDER_PRESENT -eq 1 && $JSON_FILE_PRESENT -eq 1 ]]; then
    # Create a Folder
    mkdir $SUBMISSION_FOLDER
    echo -e "\e[32mFolder Created with the name -> $FOLDER_NAME\e[0m"
    # Copy Files
    cp -r riscv_compiler_test/output.hex $SUBMISSION_FOLDER
    cp result*.json $SUBMISSION_FOLDER
    # Remove Unnecessary Files
    for i in "AND_GATE" "ripple_carry_adder" "sequence_detector"; do
        cp -r $i $SUBMISSION_FOLDER
        rm -r $SUBMISSION_FOLDER/$i/incremental_db $SUBMISSION_FOLDER/$i/output_files $SUBMISSION_FOLDER/$i/db
    done
    # zip files to submission folder
    zip -m -r $FOLDER_NAME.zip $SUBMISSION_FOLDER
    echo -e "\e[32mZip File Successfully Generated.\e[0m"
    echo -e "\e[36mYou can now submit the generated zip file in the portal.\e[0m"
fi
