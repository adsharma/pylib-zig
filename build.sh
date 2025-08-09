#!/bin/bash
# Simple build script for pylib-zig

echo "Building pylib-zig..."
zig build

echo "Running tests..."
zig build test

echo "Build and test completed successfully!"
