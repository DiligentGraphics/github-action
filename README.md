# github-action

Custom actions used by the Diligent Engine CI

## checkout

Checks out the specified module and its required dependent modules.

Example:

```yml
steps:
- name: Checkout
    uses: DiligentGraphics/github-action/checkout@master
    with:
      module: Tools # Optional; by default, current module is checked out
```

## setup-build-env

Sets up the build environment and downloads the required prerequisites:

- Ninja
- Vulkan SDK
- Java
- Emscripten SDK
- Required linux libraries

Example:

```yml
steps:
- name: Set up build environment
    uses: DiligentGraphics/github-action/setup-build-env@v1
    with:
      platform:           Win32     # UWP, Linux, MacOS, tvOS, iOS, Android, Emscripten
      setup-ninja:        true      # Optional
      ninja-vs-arch:      x64       # When ninja is used for VS build
      vulkan-sdk-version: 1.3.204.1 # Optional, see defaults below
      java-version:       17        # Optional, see defaults below
      emsdk-version:      3.1.9     # Optional, see defaults below
```

Default component versions are specified in the table below:

|  Component      |      v1       |
|-----------------|---------------|
| Vulkan SDK      | 1.3.204.1     |
| Java            | 17            |
| Emscripten  SDK | 3.1.9         |


Linux libraires:

* v1
  - build-essential
  - libx11-dev
  - libgl1-mesa-dev
  - libxrandr-dev
  - libxinerama-dev
  - libxcursor-dev
  - libxi-dev


## configure-cmake

Configures CMake; creates a helper `CMakeLists.txt` file, if necessary.

Build files are generated in `${{runner.workspace}}/build` directory.
The path is stored in `DILIGENT_BUILD_DIR` environment varible.

Install directory is set to `${{runner.workspace}}/build/install`.
The path is stored in `DILIGENT_INSTALL_DIR` environment varible.

Example:

```yml
steps:
- name: Configure CMake
  if: success()
  uses: DiligentGraphics/github-action/configure-cmake@dev
  with:
    generator:             Visual Studio 17 2022
    vs-arch:               x64   # Required for VS generator
    build-type:            Debug # Required
    cmake-args:            -DDILIGENT_DEVELOPMENT=ON # Optional extra CMake arguments
    osx-deployment-target: 11         # Required for iOS/tvOS
    osx-architectures:     arm64      # Required for iOS/tvOS
    cc:                    clang-12   # Optional for Linux
    cxx:                   clang++-12 # Optional for Linux
```

Default versions are specified in the table below:

|  Parameter            |      v1       |
|-----------------------|---------------|
| osx-deployment-target |      11       |
