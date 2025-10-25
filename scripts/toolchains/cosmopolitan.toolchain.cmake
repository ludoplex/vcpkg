# Minimal chainloaded toolchain for building ports against Cosmopolitan libc.
# Requirements:
# - cosmocc / cosmoc++ available on PATH or in COSMOPOLITAN_ROOT/bin
# - Static-only builds; try-run disabled

cmake_minimum_required(VERSION 3.20)
include_guard(GLOBAL)

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR x86_64)
set(CMAKE_CROSSCOMPILING TRUE)

# Locate Cosmopolitan SDK/toolchain
set(COSMOPOLITAN_ROOT "$ENV{COSMOPOLITAN_ROOT}" CACHE PATH "Path to the Cosmopolitan SDK root")
find_program(COSMOCC NAMES cosmocc cosmoc PATHS "${COSMOPOLITAN_ROOT}/bin" ENV PATH REQUIRED)
find_program(COSMOCXX NAMES cosmoc++ cosmocxx PATHS "${COSMOPOLITAN_ROOT}/bin" ENV PATH)

set(CMAKE_C_COMPILER "${COSMOCC}" CACHE FILEPATH "" FORCE)
if(COSMOCXX)
  set(CMAKE_CXX_COMPILER "${COSMOCXX}" CACHE FILEPATH "" FORCE)
else()
  # Fallback for pure-C builds
  set(CMAKE_CXX_COMPILER "${COSMOCC}" CACHE FILEPATH "" FORCE)
endif()

# Static linking; do not build shared libs
set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" CACHE STRING "" FORCE)

# Avoid executing built binaries during configure
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY CACHE STRING "" FORCE)

# Reasonable defaults; cosmocc typically bakes in static/APE flags
add_compile_definitions(__COSMOPOLITAN__)
add_compile_options(-O2)

# vcpkg expectations
set(VCPKG_CRT_LINKAGE static CACHE STRING "" FORCE)
set(VCPKG_LIBRARY_LINKAGE static CACHE STRING "" FORCE)
