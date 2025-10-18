# Overlay Ports for Cosmopolitan

This directory provides a scaffold for maintaining Cosmopolitan-specific patches and port overrides without modifying the upstream vcpkg port tree.

## Usage

To use overlay ports with vcpkg, set the `VCPKG_OVERLAY_PORTS` environment variable or pass `--overlay-ports` on the command line:

```bash
# Environment variable approach
export VCPKG_OVERLAY_PORTS=/home/runner/work/vcpkg/vcpkg/overlays/my-ports
./vcpkg install some-port:x64-cosmo

# Command-line approach
./vcpkg install some-port:x64-cosmo --overlay-ports=./overlays/my-ports
```

## Structure

Create subdirectories here for each port you need to patch:

```
overlays/
├── README.md
├── my-ports/
│   ├── zlib/
│   │   ├── portfile.cmake
│   │   ├── vcpkg.json
│   │   └── fix-cosmo.patch
│   └── other-port/
│       └── ...
```

## When to Use Overlays

Use overlay ports when:
- A port requires Cosmopolitan-specific patches
- A port needs additional `supports` constraints to exclude `x64-cosmo`
- You need to test changes before upstreaming to vcpkg

## Best Practices

1. **Keep patches minimal**: Only override what's necessary for Cosmopolitan compatibility
2. **Document changes**: Add comments explaining why the overlay is needed
3. **Contribute upstream**: When possible, submit patches to the main vcpkg repository
4. **Version tracking**: Include `"port-version"` in `vcpkg.json` to track your changes

## References

- [vcpkg Overlay Ports Documentation](https://learn.microsoft.com/vcpkg/users/examples/overlay-ports)
- [Cosmopolitan Documentation](../docs/users/cosmopolitan.md)
