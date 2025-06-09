#!/bin/bash

if [ -f "$(dirname "$0")/utils.sh" ]; then
    source "$(dirname "$0")/utils.sh"
fi

if ! command -v asdf &> /dev/null; then
    echo "Installing asdf..."
    brew install asdf
fi

flutter_version=""
while read -r line; do
    if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
        continue
    fi
    
    tool=$(echo "$line" | awk '{print $1}')
    version=$(echo "$line" | awk '{print $2}')
    
    if [[ -n "$tool" && -n "$version" ]]; then
        echo "Installing $tool $version..."
        asdf install "$tool" "$version"
        
        if [[ "$tool" == "flutter" ]]; then
            flutter_version="$version"
        fi
    fi
done < .tool-versions

# Update VSCode settings with Flutter SDK path
if [[ -n "$flutter_version" ]]; then
    echo "Updating VSCode settings with Flutter SDK path..."
    mkdir -p .vscode
    cat > .vscode/settings.json << EOF
{
    "dart.flutterSdkPath": "~/.asdf/installs/flutter/$flutter_version"
}
EOF
    
    echo "Updated .vscode/settings.json with Flutter SDK path: ~/.asdf/installs/flutter/$flutter_version"
fi