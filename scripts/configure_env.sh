#!/bin/bash

environment="$1"

if [ -z $1 ]; then
    echo "Please pass environment as argument (staging / production / testnet)"
    exit 0
elif [ "$environment" != "production" ] && [ "$environment" != "staging" ] && [ "$environment" != "testnet" ]; then
    echo "Please pass a valid environment (staging / production / testnet)"
    exit 0
else
    cp -rf ../flutter-app-secrets/$environment/* ./ &&
    cp -a ../flutter-app-secrets/$environment/ ./ &&
    source .env
    
    # Generate Swift configuration file for iOS notification service extension
    EXTENSION_CONFIG_DIR="ios/NotificationServiceExtension/Configuration"
    EXTENSION_CONFIG_FILE="$EXTENSION_CONFIG_DIR/Environment.swift"
    
    # Create directory if it doesn't exist
    mkdir -p "$EXTENSION_CONFIG_DIR"
    
    # Create Swift file with environment variables
    cat > "$EXTENSION_CONFIG_FILE" << EOF
// SPDX-License-Identifier: ice License 1.0
// Auto-generated file from configure_env.sh - DO NOT EDIT MANUALLY

enum Environment {
    static let ionOrigin = "$(grep '^ION_ORIGIN=' .app.env | cut -d= -f2-)"
    static let pushTranslationsCacheMinutes = $(grep '^PUSH_TRANSLATIONS_CACHE_MINUTES=' .app.env | cut -d= -f2-)
}
EOF
    
    echo "Generated iOS notification service extension configuration at $EXTENSION_CONFIG_FILE"
    echo "Done!"
fi