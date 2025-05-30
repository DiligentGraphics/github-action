# github-action

Custom actions used by the [Diligent Engine](https://github.com/DiligentGraphics/DiligentEngine) CI.

## checkout

Checks out the specified module and its required dependent modules.

Example:

```yml
steps:
- name: Checkout
    uses: DiligentGraphics/github-action/checkout@master
    with:
      module:     Tools # Optional; by default, current module is checked out
      submodules: true  # Optional; by default, 'recursive' is used
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
      platform:           Win32     # UWP, Linux, MacOS, tvOS, iOS, Android, Web
      cmake-generator:    Ninja     # Optional
      ninja-vs-arch:      x64       # When Ninja is used for VS build
      vulkan-sdk-version: 1.3.290.0 # Optional, see defaults below
      java-version:       17        # Optional, see defaults below
      emsdk-version:      4.0.0     # Optional, see defaults below
```

Default component versions are specified in the table below:

|  Component      |      v1       |
|-----------------|---------------|
| Vulkan SDK      | 1.3.290.0     |
| Java            | 17            |
| Emscripten  SDK | 4.0.0         |


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

Example:

```yml
steps:
- name: Configure CMake
  if: success()
  uses: DiligentGraphics/github-action/configure-cmake@v1
  with:
    generator:             Visual Studio 17 2022
    vs-arch:               x64   # Required for VS generator
    build-type:            Debug # Required
    cmake-args:            -DDILIGENT_DEVELOPMENT=ON # Optional extra CMake arguments
    osx-deployment-target: 11         # Required for iOS/tvOS
    osx-architectures:     arm64      # Required for iOS/tvOS
    cc:                    clang-12   # Optional for Linux
    cxx:                   clang++-12 # Optional for Linux
    windows-sdk-version:   10.0.22621.0 # Optional for Visual Studio generator
```

Default versions are specified in the table below:

|  Parameter            |      v1       |
|-----------------------|---------------|
| osx-deployment-target |      11       |

The action sets the following environment variables:
* `DILIGENT_BUILD_TYPE`  - Build type (`${{inputs.build-type}}`)
* `DILIGENT_BUILD_DIR`   - Build directory (`${{runner.workspace}}/build`)
* `DILIGENT_INSTALL_DIR` - Install directory (`${{runner.workspace}}/build/install`)


## build

Runs the build for the current configuration.

Example:

```yml
steps:
- name: Build
  if: success()
  uses: DiligentGraphics/github-action/build@master
  with:
    target: install # Optional target
```


## run-core-tests

Runs Diligent Core tests for the current configuration.

Example:

```yml
steps:
- name: DiligentCoreTest
  if:   success()
  uses: DiligentGraphics/github-action/run-core-tests@master
```


## run-core-gpu-tests

Runs Diligent Core GPU tests for the current configuration.

Example:

```yml
- name: DiligentCoreAPITest D3D12 DXC
  if:   success()
  uses: DiligentGraphics/github-action/run-core-gpu-tests@master
  with:
    mode:                d3d12_sw
    use-dxc:             true
    non-separable-progs: false
```


## run-tools-tests

Runs Diligent Tools tests for the current configuration.

Example:

```yml
steps:
- name: DiligentToolsTest
  if:   success()
  uses: DiligentGraphics/github-action/run-tools-tests@master
```


## run-tools-gpu-tests

Runs Diligent Tools GPU tests for the current configuration.

Example:

```yml
- name: DiligentToolsGPUTest D3D11
  if:   success()
  uses: DiligentGraphics/github-action/run-tools-gpu-tests@master
  with:
    mode:    d3d11_sw
```

## run-sample-tests

Runs sample and tutorial tests for the current configuration.

Example:

```yml
- name: Sample Tests D3D11
    uses: DiligentGraphics/github-action/run-sample-tests@v1
    with:
      mode:                d3d12_sw
      golden-image-mode:   compare_update
      non-separable-progs: false
```


## clean-disk-ubuntu

Removes unneeded packages and tools to free disk space.

Example:

```yml
- name: Clean Disk
  uses: DiligentGraphics/github-action/clean-disk-ubuntu@master
  preserve-android-ndk: 27.0.12077973
```


## install-doxygen

Installs Doxygen.

Example:

```yml
- name: Install Doxygen
  uses: DiligentGraphics/github-action/install-doxygen@master
```
