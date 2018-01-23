Clang Linting/Formatting Tools
==============================
Various tools to facilitate formatting and linting with clang.

### clang-format-all
Contains a script which recursively searches a folder for C++ files and formats 
the code according to a predefined style with clang-format. The style is defined
 in the .clang-format file contained in the same directory as the script.

### compiledb-generator
Contains a set of scripts which generate a JSON compilation database 
(compile_commands.json) from a Makefile. The compilation database is required 
for linting with clang-tidy. While it is possible to generate the compilation 
database automatically with cmake, there are some currently unsolved issues with
 this method for our build system.

### run-clang-tidy
Contains a script which runs clang-tidy on all compilation targets defined in 
the compile_commands.json database. To analyze code for 
[CppCoreGuidelines](https://github.com/isocpp/CppCoreGuidelines) violations, 
```cd``` to the folder with the compile_commands.json file and execute 
```run-clang-tidy.py -checks="-*,cppcoreguidelines-*"```




