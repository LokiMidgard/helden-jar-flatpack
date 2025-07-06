#!/bin/sh
# Ensure the JAR is referenced from the correct directory
exec /usr/lib/sdk/openjdk17/bin/java -jar /app/helden.jar "$@"
