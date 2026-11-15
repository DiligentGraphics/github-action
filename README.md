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
    uses: DiligentGraphics/github-action/setup-build-env@v28
    with:
      platform:           Win32     # UWP, Linux, MacOS, tvOS, iOS, Android, Web
      cmake-generator:    Ninja     # Optional
      ninja-vs-arch:      x64       # When Ninja is used for VS build
      vulkan-sdk-version: 1.4.363.0 # Optional, see defaults below
      java-version:       17        # Optional, see defaults below
      emsdk-version:      7.0.0     # Optional, see defaults below
```

Default component versions are specified in the table below:

|  Component      |      v28      |
|-----------------|---------------|
| Vulkan SDK      | 1.4.363.0     |
| Java            | 17            |
| Emscripten SDK  | 7.0.0         |


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

## run-fx-gpu-tests

Runs the `DiligentFXGPUTest` suite for the current configuration. Build with
`DILIGENT_BUILD_FX_TESTS=ON` before running this action. Tests run from
`DiligentFX/Tests/DiligentFXGPUTest/assets`.

The required `mode` input selects the graphics backend; the optional `args` input
passes additional test arguments. Like the other GPU test actions, it captures
output in `TestOutput.log` and verifies the requested backend was used.

Example:

```yml
- name: DiligentFXGPUTest D3D11
  if:   success()
  uses: DiligentGraphics/github-action/run-fx-gpu-tests@master
  with:
    mode: d3d11_sw
    args: --gtest_filter=*AtlasSamplingTest*
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

## run-radient-render-tests

Runs Radient reference-image rendering tests.

Example:

```yml
- name: Radient Render Tests D3D11
  uses: DiligentGraphics/github-action/run-radient-render-tests@master
  with:
    mode:                 d3d11_sw
    models-path:          ${{github.workspace}}/glTF-Sample-Assets
    assets-path:          ${{github.workspace}}/RadientTestData
    update-golden-images: true
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


## run-core-cpu-browser-tests

Runs the already-built `DiligentCoreTest` CPU suite in one headless Chrome
session on Linux, Windows, and macOS. Python 3 and Chrome/Chromium with JSPI
support must be installed. No GPU or software graphics adapter is required. Each test's output
is streamed to the workflow log; test logs and Google Test XML are uploaded
even after a failure.

`source-dir` defaults to `.` and `build-dir` to `DILIGENT_BUILD_DIR`. For an
engine checkout, use `source-dir: DiligentCore` and
`build-dir: ${{env.DILIGENT_BUILD_DIR}}/DiligentCore`. Optional inputs are
`browser`, `filter` (Google Test pattern), `output-dir` (default
`CoreCPUBrowserTestResults`), and `artifact-name` (default `CoreCPUBrowserTests`).
Use a unique artifact name for each matrix job. Build settings and test
configuration, including exception-test exclusions in `exclude.txt`, remain
in DiligentCore; this action only runs the tests.

## run-core-browser-tests

Runs the already-built `DiligentCoreAPITest` Wasm module in headless
Chrome/SwiftShader on Linux and Windows. Python 3 and Chrome/Chromium must be
installed. The action uses the Core checkout's browser runner and `exclude.txt`; changing
test exclusions does not require updating the action. Logs and Google Test XML
are uploaded even if the tests fail.

```yml
- name: Test Core in Chrome
  uses: DiligentGraphics/github-action/run-core-browser-tests@v33
  with:
    artifact-name: CoreBrowserTests-${{runner.os}}-${{matrix.build_type}}
```

For an engine checkout, specify `source-dir: DiligentCore` and
`build-dir: ${{env.DILIGENT_BUILD_DIR}}/DiligentCore`. The defaults are `.` and
`DILIGENT_BUILD_DIR`, respectively. Optional inputs are `browser` (executable),
`filter` (Google Test pattern), and `output-dir` (default `BrowserTestResults`).
Use a unique `artifact-name` for each job in a build matrix.

## run-tools-cpu-browser-tests and run-tools-gpu-browser-tests

Run the already-built `DiligentToolsTest` and `DiligentToolsGPUTest` suites in
headless Chrome. CPU tests support Linux, Windows, and macOS; GPU tests support
Linux and Windows. The GPU action selects SwiftShader; the CPU action does not
require a graphics adapter. Both stream per-test output to the workflow
log and upload `tests.log`, `chrome.log`, and Google Test XML, including after
failure. Python 3 and Chrome/Chromium with JSPI support must be installed.

```yml
- name: Test Tools CPU in Chrome
  uses: DiligentGraphics/github-action/run-tools-cpu-browser-tests@v33
  with:
    artifact-name: ToolsCPU-Chrome-${{runner.os}}-${{matrix.build_type}}

- name: Test Tools WebGPU in Chrome
  uses: DiligentGraphics/github-action/run-tools-gpu-browser-tests@v33
  with:
    artifact-name: ToolsWebGPU-Chrome-${{runner.os}}-${{matrix.build_type}}
```

`source-dir` defaults to `DiligentTools` and `build-dir` to
`DILIGENT_BUILD_DIR/DiligentTools`, matching both Tools CI and an engine checkout.
Optional inputs are `browser`, `filter` (Google Test pattern), `output-dir`, and
`artifact-name`. CPU results default to `ToolsCPUBrowserTestResults`; GPU results
default to `ToolsGPUBrowserTestResults`. Use unique artifact names for matrix jobs.
The actions reuse Core's browser harness through the Tools entry points.
Each suite's `exclude.txt` and assets remain in DiligentTools. Build steps remain
in the calling workflow.

## run-radient-cpu-browser-tests and run-radient-gpu-browser-tests

Run the already-built `RadientTest` and `RadientGPUTest` suites in headless Chrome
on Linux and Windows, with CPU tests also supported on macOS. CPU tests need no
graphics adapter; GPU tests use WebGPU with SwiftShader. Both reuse Core's browser
harness, stream each test's output,
and upload logs and Google Test XML even after a failure.

```yml
- name: Test Radient CPU in Chrome
  uses: DiligentGraphics/github-action/run-radient-cpu-browser-tests@v34
  with:
    artifact-name: RadientCPU-Chrome-${{runner.os}}-${{matrix.build_type}}

- name: Test Radient WebGPU in Chrome
  uses: DiligentGraphics/github-action/run-radient-gpu-browser-tests@v34
  with:
    artifact-name: RadientWebGPU-Chrome-${{runner.os}}-${{matrix.build_type}}
```

Configure with `DILIGENT_BUILD_FX_TESTS=ON` and build the suites before running
these actions. Python 3 and Chrome/Chromium with JSPI support are required.
`source-dir` defaults to `DiligentFX`, and `build-dir` to
`DILIGENT_BUILD_DIR/DiligentFX`. Optional inputs are `browser`, `filter`,
`output-dir`, and `artifact-name`. Results default to `RadientCPUBrowserTestResults`
and `RadientGPUBrowserTestResults`. Test configuration, including `exclude.txt`,
stays in FX. These native suites complement the JavaScript binding and golden-image
tests run by `run-radient-render-browser-tests`.

## run-radient-render-browser-tests

Runs the already-built Radient browser binding suites and golden-image tests
through CTest in headless Chrome/SwiftShader on Linux. The test list, render
manifest, timeouts, and image-comparison tolerances remain in DiligentFX.
The action uploads the verbose CTest log, JUnit XML, render reports, and images,
including after a test failure. It does not build tests or download assets.

```yml
- name: Test Radient in Chrome
  uses: DiligentGraphics/github-action/run-radient-render-browser-tests@v34
  with:
    models-path: ${{github.workspace}}/glTF-Sample-Assets
    assets-path: ${{github.workspace}}/DiligentTestData
    artifact-name: RadientBrowserTests-${{matrix.build_type}}
```

`build-dir` defaults to `DILIGENT_BUILD_DIR/DiligentFX`; `configuration` defaults
to `DILIGENT_BUILD_TYPE`. Optional inputs are `browser` (executable), `filter`
(CTest test-name regular expression within the `Browser` label), and
`output-dir` (default `BrowserRenderResults`). Relative paths are resolved from
the workflow workspace. The assets checkout must contain the Chrome reference
images used by the module's render tests.

Core, Tools, and Radient CPU/GPU actions use `common/run_browser_tests.sh` to select Python and
software rendering flags for the host platform. Their shared Core harness discovers
Chrome on `PATH` or in standard Windows/macOS installation directories. On Windows,
ANGLE uses D3D11 WARP and WebGPU uses SwiftShader, so no hardware GPU is required.
The Linux Radient JavaScript action uses `common/chrome_swiftshader.sh`.
Their module-specific harnesses manage browser sessions and report failures. Build and asset-checkout steps remain in the calling workflow.
