# Cosmopolitan support in vcpkg (community triplet)

This document explains how to build vcpkg ports with [Cosmopolitan Libc](https://github.com/jart/cosmopolitan) using the community triplet `x64-cosmo`, so you can link your apps into single-file, run-anywhere executables via `cosmocc` / `cosmoc++`.

## Prerequisites

- A working Cosmopolitan toolchain:
  - Option A: Build from source (see Cosmopolitan repo instructions), ensure `cosmocc` and (optionally) `cosmoc++` are on your `PATH`.
  - Option B: Define `COSMOPOLITAN_ROOT` environment variable pointing to a directory that has `bin/cosmocc` (and optionally `bin/cosmoc++`).

- vcpkg bootstrapped as usual:
  ```bash
  ./bootstrap-vcpkg.sh   # or .\\bootstrap-vcpkg.bat on Windows
  ```

## Install ports with the `x64-cosmo` triplet

Example:
```bash
./vcpkg install zlib:x64-cosmo
```

Notes:
- Only static libraries are produced.
- Many ports depend on OS facilities or perform `try_run()` checks and may not build under cross conditions. Start with portable, pure C libraries (e.g., `zlib`, `miniz`, `xxhash`, etc.).
- You can maintain an overlay-ports directory to carry small patches or `supports` constraints specific to Cosmopolitan. This fork includes an overlays scaffold at `overlays/` — point `VCPKG_OVERLAY_PORTS` to subfolders you add here.

## Linking your app

Compile and link your application with `cosmocc`/`cosmoc++`, adding your vcpkg-installed library and include paths. For example:

```bash
cosmocc -I$(./vcpkg fetch zlib:x64-cosmo | grep include) \
        -L$(./vcpkg fetch zlib:x64-cosmo | grep lib) \
        -o myapp.com.dbg myapp.c -lz
```

Or more simply, if you've already installed the port:

```bash
cosmocc -I./installed/x64-cosmo/include \
        -L./installed/x64-cosmo/lib \
        -o myapp.com.dbg myapp.c -lz
```

The resulting `.com.dbg` binary is a multiplatform APE (Actually Portable Executable) that can run on Linux, macOS, Windows, and more.

## Troubleshooting

- **Port fails to build**: Many ports assume POSIX or specific OS features. Consider adding an overlay port with patches or a `supports` expression that excludes `x64-cosmo`.
- **Try-run errors**: Cosmopolitan cross-compilation disables `try_run()` via `CMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY`. Some ports may need patches to avoid runtime checks.
- **Missing symbols**: Ensure you're linking the correct libraries. Cosmopolitan provides its own libc, so avoid mixing with system libraries.

## References

- [Cosmopolitan Libc](https://github.com/jart/cosmopolitan)
- [vcpkg Triplets documentation](triplets.md)
- [vcpkg Overlay Ports](https://learn.microsoft.com/vcpkg/users/examples/overlay-ports)
