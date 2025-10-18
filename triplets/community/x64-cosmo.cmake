set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_LIBRARY_LINKAGE static)

# Cross-compiling; avoid host OS assumptions
set(VCPKG_CMAKE_SYSTEM_NAME "Generic")

# Build single-config to keep artifacts small and speed builds
set(VCPKG_BUILD_TYPE release)

# Chainload the Cosmopolitan toolchain for compilers/flags
set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${VCPKG_ROOT_DIR}/scripts/toolchains/cosmopolitan.toolchain.cmake")
