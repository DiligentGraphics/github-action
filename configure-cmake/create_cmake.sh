echo "cmake_minimum_required(VERSION 3.6)" > CMakeLists.txt
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
