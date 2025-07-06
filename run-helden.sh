#!/bin/sh
# Ensure the JAR is referenced from the correct directory

# Set up XDG directories if not already set
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.var/app/de.helden-software/data"
fi

if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.var/app/de.helden-software/config"
fi

if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.var/app/de.helden-software/cache"
fi

# Create directories if they don't exist
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_CACHE_HOME"

# Create subdirectories for Helden-Software
mkdir -p "$XDG_DATA_HOME/plugins"
mkdir -p "$XDG_DATA_HOME/mods"
mkdir -p "$XDG_DATA_HOME/hintergruende"
mkdir -p "$XDG_DATA_HOME/helden"
mkdir -p "$XDG_DATA_HOME/heldenbilder"
mkdir -p "$XDG_DATA_HOME/hilfetexte"
mkdir -p "$XDG_DATA_HOME/erschaffungssaves"
mkdir -p "$XDG_DATA_HOME/daten"
mkdir -p "$XDG_CACHE_HOME/logs"

# Copy and configure heldconfiguration.xml if it doesn't exist
CONFIG_FILE="$XDG_CONFIG_HOME/.heldEinstellungen4_1.xml"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Setting up Helden configuration..."
    # Copy template and replace variables with actual paths
    sed -e "s|\$XDG_DATA_HOME|$XDG_DATA_HOME|g" \
        -e "s|\$XDG_CONFIG_HOME|$XDG_CONFIG_HOME|g" \
        -e "s|\$XDG_CACHE_HOME|$XDG_CACHE_HOME|g" \
        /app/share/heldconfiguration.xml > "$CONFIG_FILE"
fi

echo "Configuration: $CONFIG_FILE"

exec /app/jvm/bin/java -jar /app/helden.jar "-ep$XDG_CONFIG_HOME"
