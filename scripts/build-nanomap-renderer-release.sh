#!/bin/bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
cd ..

# -----------------------------------------------------------------------------
# Get tag name
relname=$(git describe --tags --exact)
echo "Using tag name: $relname"

# -----------------------------------------------------------------------------
# Cargo build
touch crates/*/build.rs

echo '==== Linux build ===='
cargo build --release --bin dmm-tools --target x86_64-unknown-linux-musl

echo '==== Windows build ===='
cargo build --release --bin dmm-tools --target x86_64-pc-windows-gnu

# -----------------------------------------------------------------------------
# Organize binaries into a directory for upload
echo '==== Organize files ===='
DEST=target/dist
rm -rf "$DEST"
mkdir -p "$DEST"
cp target/x86_64-unknown-linux-musl/release/dmm-tools "$DEST/nanomap-renderer"
cp target/x86_64-pc-windows-gnu/release/dmm-tools.exe "$DEST/nanomap-renderer.exe"
echo "# SpacemanDMM - NanoMap Renderer $relname"
ls -lh --color=auto "$DEST"
