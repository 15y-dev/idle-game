#!/bin/bash
set -e

GODOT_VERSION="4.3-stable"

# Godot をダウンロード
wget -q https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.x86_64.zip
unzip -q Godot_v${GODOT_VERSION}_linux.x86_64.zip

# export templates をダウンロード
wget -q https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_export_templates.tpz
mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}
unzip -q Godot_v${GODOT_VERSION}_export_templates.tpz -d /tmp/templates
mv /tmp/templates/templates/* ~/.local/share/godot/export_templates/${GODOT_VERSION}/

# エクスポート
mkdir -p export/web
./Godot_v${GODOT_VERSION}_linux.x86_64 --headless --export-release "Web" export/web/index.html
