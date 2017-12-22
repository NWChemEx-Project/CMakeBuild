CMake Build Basics
------------------

This page is designed to detail the basic steps required to build a C++ project
using CMake.  It is targeted at users who want to understand how CMake works in
order to contribute to NWChemExBase (or simply because there's a lack of good
tutorials on the internets).

Building a C++ Project
----------------------

C++ is a compiled language.  What this means is a compiler turns the C++ source
code into some form of binary object such as an executable (a program that can
actually be run) or a library (a reusable collection of binary routines).  Many
tutorials make compiling seem simple because the tutorial is a single file.  
When you start making a package you quickly amass a multitude of source and 
header files.  Furthermore, you likely will want to link against other 
people's libraries.  Maybe your source tree is so big and parts change so rarely
that you want to break your source into multiple libraries.  Then you start
caring about performance, so now certain files are compiled with certain options
and others with other options.  Manually compiling the package (*i.e.* calling
the compiler for each and every source file with the appropriate commands) 
becomes error-prone and tedious.  Historically this is where compiling 
languages like `make` came in.

Make provides a "simple" mechanism for expressing rules for making a particular
target and for expressing dependencies among targets.  It is not however 
easy for make to locate the dependencies, nor is it easy for make to adapt the
build process to the current hardware platform.  This is where `autotools` and
`CMake` come in.  Generally speaking they both attempt to generate a set of 
build files that are knowledgeable about dependency locations and details of 
the current platform.  For the most part `autotools` is only used by GNU 
projects and although supposedly cross-platform, really is targeted at Linux.
For this reason many C++ projects prefer CMake for their build system.

To some extent this means we've developed an entire software stack around 
calling a single command a bunch of times with different arguments.  Whether 
there is a better way to do this, in a manner that is cross platform, is 
somewhat irrelevant at the moment.  This is because potential users of your 
package often want to treat compilation as a black box and consequentially 
can be easily frightened by build systems that are different than what they are
used to.  Anyways now that we've motivated the problem CMake intends to fix, 
let's discuss how it goes about doing this.
 
CMake Workflow
--------------

Before discussing how to use CMake let us discuss the workflow CMake is 
designed for.  "User" in this section refers to the person attempting to 
compile your code.

1. Obtain source.  Although it may seem silly to list this step it'll behoove us
   later.  As you can imagine this step is the literal process of obtaining a
   source tree.
2. Configure source.  If the source is designed to use CMake, this is where the
   user will invoke the `cmake` command.  This step generates the files 
   necessary to build the source.  Included in this step is system introspection
   as well as finding the dependencies.
3. Build source. After configuration, the files necessary for actually 
   building the source exist and the user is then responsible for running the
   build (typically by calling `make`, but not strictly necessary).
4. Test project.  After the project is built the user may test to ensure 
   everything built correctly.
5. Install project.  With the knowledge that the resulting project works right,
   the user installs it to a place will it will reside.
   
   
    
    


