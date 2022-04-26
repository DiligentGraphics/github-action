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
