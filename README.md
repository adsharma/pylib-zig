# Python style libraries for Zig

Zig as a language likes to keep things explicit (e.g. allocators). This makes transpilers more
complex since one line of python explodes into many lines of zig.

Try a library approach so we keep the expansion minimal

## Building

To build the library, you need to have Zig installed (version 0.11.0 or later).

```bash
# Clone the repository
git clone https://github.com/your-username/pylib-zig.git
cd pylib-zig

# Build the library
zig build

# Run tests
zig build test
```

Or use the provided build script:
```bash
./build.sh
```

## CI

This project uses GitHub Actions for continuous integration. The CI pipeline:
- Tests building the library
- Runs all unit tests
- Tests against recent Zig versions (0.14.x for now)
