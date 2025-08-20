# Simple-Calculator

A simple command-line calculator application built with C++ and CMake.

## Features

- Basic arithmetic operations: add, subtract, multiply, divide
- Version information support
- GitHub release versioning
- Bitbake/Yocto integration ready

## Building

```bash
mkdir build
cd build
cmake ..
make
```

## Usage

```bash
# Basic operations
./basic-calculator add 5 3
./basic-calculator subtract 10 4
./basic-calculator multiply 6 7
./basic-calculator divide 15 3

# Version information
./basic-calculator --version
```

## Versioning

This project uses semantic versioning (MAJOR.MINOR.PATCH) with automated GitHub releases.

Current version: 1.0.0

## Bitbake Integration

See `bitbake-recipes/` directory for Yocto/OpenEmbedded recipes and `RELEASE-GUIDE.md` for detailed instructions on version management and upgrade testing.

## License

MIT License - see LICENSE file for details.