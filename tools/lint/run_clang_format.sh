#!/usr/bin/env bash

if [ "$#" -lt 3 ]; then
    echo "Usage: ./run_clang_format.sh <clang-format-exe> \\"
    echo "                             <path/to/.clang-format> \\"
    echo "                             <dir1> \\"
    echo "                             [<dir2>...]"
    echo ""
    echo "clang-format-exe: path to clang-format command to run"
    echo "path/to/.clang-format: path to .clang-format fiel to use"
    echo "dir1: the directory to format"
    echo "(optional) dir2...: additional directories to format"
    exit 1
fi

executable=$1
format_file=$2
dirs=("$@")

for((i=2;i<$#;++i));do
    curr_dir=${dirs[$i]}
    echo "Formatting files in ${curr_dir}"
    cp ${format_file} ${curr_dir}
    cd ${curr_dir}
    find ${source_dir} \
     \( -name '*.c' \
        -o -name '*.cc' \
        -o -name '*.cpp' \
        -o -name '*.h' \
        -o -name '*.hh' \
        -o -name '*.hpp' \) \
        -exec "${executable}" -i -style=file '{}' \;
    rm ${format_file}
    cd -
done

