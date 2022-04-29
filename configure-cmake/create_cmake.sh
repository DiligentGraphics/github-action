# The '>' redirection operator writes the output to a given file.
# If the file exists, it is truncated to zero length.
# Otherwise, the file is created.
echo "cmake_minimum_required(VERSION 3.6)" > CMakeLists.txt

# The '>>' redirection operator appends the output to a given file.
# The file is created if it does not exist.
echo "Project(BuildTest)" >> CMakeLists.txt

echo "add_subdirectory(DiligentCore)" >> CMakeLists.txt

if [ -d "./DiligentTools" ]; then
    echo "add_subdirectory(DiligentTools)" >> CMakeLists.txt
fi

if [ -d "./DiligentFX" ]; then
    echo "add_subdirectory(DiligentFX)" >> CMakeLists.txt
fi

if [ -d "./DiligentSamples" ]; then
    echo "add_subdirectory(DiligentSamples)" >> CMakeLists.txt
fi

if [ -d "./DiligentCorePro" ]; then
    echo "add_subdirectory(DiligentCorePro)" >> CMakeLists.txt
fi
