#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
  echo "Do NOT run this script with root previlige!"
  exit 1
fi

if [[ "$(uname)" == "Linux" ]]; then
    config_path="$HOME/.local/share/fcitx5/rime"
elif [[ "$(uname)" == "Darwin" ]]; then
    config_path="$HOME/Library/Rime"
else
    echo "Unsupported operating system"
    exit 1
fi

echo "Detected system: $(uname)"
echo "Config path set to: $config_path"

if [ -d "$config_path" ]; then
    echo "Removing existing directory: $config_path"
    rm -rf "$config_path"
fi

echo "Cloning oh-my-rime repository..."
git clone https://github.com/Mintimate/oh-my-rime.git "$config_path"

if [ $? -ne 0 ]; then
    echo "Failed to clone oh-my-rime repository"
    exit 1
fi

echo "Downloading custom files"
curl -o "$config_path/default.custom.yaml" \
    https://raw.githubusercontent.com/Orion-zhen/rime-overwrite/refs/heads/main/default.custom.yaml
curl -o "$config_path/rime_mint.custom.yaml" \
    https://raw.githubusercontent.com/Orion-zhen/rime-overwrite/refs/heads/main/rime_mint.custom.yaml
if [[ "$(uname)" == "Darwin" ]]; then
    curl -o "$config_path/squirrel.custom.yaml" \
        https://raw.githubusercontent.com/Orion-zhen/rime-overwrite/refs/heads/main/squirrel.custom.yaml
fi

echo "Downloading WanXiang model"
curl -fsSL https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram \
     -o "$config_path/wanxiang-lts-zh-hans.gram"

echo "Setup completed successfully!"
