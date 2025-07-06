#!/bin/bash

# Script to download helden.jar and build the Flatpak

set -e  # Exit on any error

echo "=== Helden Flatpak Build Script ==="

# Check if flatpak is installed
if ! command -v flatpak &> /dev/null; then
    echo "Error: flatpak is not installed. Please install flatpak first."
    exit 1
fi

# Check if flathub repository is added
echo "Checking Flathub repository..."
if ! flatpak remotes | grep -q flathub; then
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
fi

# Install required runtimes and SDKs
echo "Checking and installing required Flatpak runtimes and SDKs..."

# Check and install Platform runtime
if ! flatpak list | grep -q "org.freedesktop.Platform.*23.08"; then
    echo "Installing org.freedesktop.Platform/23.08..."
    flatpak install -y flathub org.freedesktop.Platform//23.08
else
    echo "✓ org.freedesktop.Platform/23.08 already installed"
fi

# Check and install SDK
if ! flatpak list | grep -q "org.freedesktop.Sdk.*23.08"; then
    echo "Installing org.freedesktop.Sdk/23.08..."
    flatpak install -y flathub org.freedesktop.Sdk//23.08
else
    echo "✓ org.freedesktop.Sdk/23.08 already installed"
fi

# Check and install OpenJDK 17 extension
if ! flatpak list | grep -q "org.freedesktop.Sdk.Extension.openjdk17.*23.08"; then
    echo "Installing org.freedesktop.Sdk.Extension.openjdk17/23.08..."
    flatpak install -y flathub org.freedesktop.Sdk.Extension.openjdk17//23.08
else
    echo "✓ org.freedesktop.Sdk.Extension.openjdk17/23.08 already installed"
fi

echo "✓ All required Flatpak components are installed"

# Download the latest helden.jar
echo "Downloading helden.jar from helden-software.de..."
wget -O helden.jar "https://www.helden-software.de/down/hs5/050503/helden.jar"

if [ ! -f "helden.jar" ]; then
    echo "Error: Failed to download helden.jar"
    exit 1
fi

echo "✓ helden.jar downloaded successfully"

# Make sure run-helden.sh is executable
chmod +x run-helden.sh

# Clean any previous build
echo "Cleaning previous build..."
rm -rf build-dir .flatpak-builder/build

# Build the Flatpak
echo "Building Flatpak..."
flatpak-builder --force-clean build-dir flatpak.json

if [ $? -eq 0 ]; then
    echo "✓ Flatpak build completed successfully!"
    echo ""
    echo "To run the application:"
    echo "  flatpak-builder --run build-dir flatpak.json run-helden.sh"
    echo ""
    echo "To export for distribution:"
    echo "  flatpak-builder --repo=repo --force-clean build-dir flatpak.json"
else
    echo "✗ Flatpak build failed!"
    exit 1
fi
