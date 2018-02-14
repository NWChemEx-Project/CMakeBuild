#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "In NWChemExBase/tools/lint execute:"
    echo "./clean_my_code.sh <clang-format-exe> <clang-tidy-exe> <source-dir> <build_dir>"
    exit 1
fi

#Pretty-ify the input commands
clang_format_command=${1}
clang_tidy_command=${2}
source_dir=${3}
build_dir=${4}

#we're in same directory as the script 'cause we told user to run there...
NWXLintRoot=`pwd`

######  Tidy Settings ######################

#This is the script to build the JSON database
make_json_cmmd=${NWXLintRoot}/compiledb-generator/compiledb-gen-make

#and this is name of said JSON database
commands_out="compile_commands.json"

#This is the full path to the run-clang-tidy.py script
run_clang_tidy="${NWXLintRoot}/clang-tidy-all/run-clang-tidy.py"

########################## Actual Script Follows ###############################

# Run format
find ${source_dir} \
     \( -name '*.c' \
        -o -name '*.cc' \
        -o -name '*.cpp' \
        -o -name '*.h' \
        -o -name '*.hh' \
        -o -name '*.hpp' \) \
        -exec "${clang_format_command}" -i -style=file '{}' \;


# Run tidy
# Step 1: Build compile command database
#cd ${build_dir}
#${make_json_cmmd} all > ${commands_out}
#${run_clang_tidy} -clang-tidy-binary=${clang_tidy_command} \
#                  -checks="-*,cppcoreguidelines-*"
