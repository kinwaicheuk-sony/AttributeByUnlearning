#!/bin/bash

# Function to find a working 7z executable
find_7z() {
    if command -v 7z &>/dev/null; then
        echo "7z"
    elif command -v 7zz &>/dev/null; then
        echo "7zz"
    else
        echo ""
    fi
}

mkdir -p data/mscoco

# download mscoco dataset
wget http://images.cocodataset.org/zips/train2017.zip -O data/mscoco/train2017.zip
unzip data/mscoco/train2017.zip -d data/mscoco
rm data/mscoco/train2017.zip

wget http://images.cocodataset.org/annotations/annotations_trainval2017.zip -O data/mscoco/annotations_trainval2017.zip
unzip data/mscoco/annotations_trainval2017.zip -d data/mscoco
rm data/mscoco/annotations_trainval2017.zip

# enable faster huggingface data transfer and download
export HF_HUB_ENABLE_HF_TRANSFER=1

mkdir -p data/mscoco/cache
python -c 'from huggingface_hub import snapshot_download; snapshot_download(repo_id="sywang/AttributeByUnlearning", allow_patterns=["mscoco/*"], repo_type="dataset", local_dir="data", cache_dir="data/mscoco/cache")'

# Determine the 7z executable
SEVEN_Z=$(find_7z)

# Exit if no suitable 7z executable is found
if [ -z "$SEVEN_Z" ]; then
    echo "Error: No suitable 7z executable found (7z or 7zz)."
    exit 1
else
    echo "Using $SEVEN_Z for extraction."
fi

# Function to extract and clean up safely
extract_and_cleanup() {
    archive=$1
    output_dir=$2
    temp_dir=$(dirname "$archive")

    echo "Extracting $archive..."
    if "$SEVEN_Z" x "$archive" -o"$output_dir"; then
        echo "Extraction successful. Cleaning up..."
        rm -rf "${archive%.001}".*
        rmdir "$temp_dir" 2>/dev/null || true
    else
        echo "Error: Extraction failed for $archive. Skipping cleanup."
    fi
}

# extract pretrained model weight and fisher information
extract_and_cleanup "data/mscoco/model_fisher.7z" "data/mscoco"
# extract generated samples
extract_and_cleanup "data/mscoco/sample.7z" "data/mscoco"
extract_and_cleanup "data/mscoco/latents_text_embeddings/latents_text_embeddings.7z.001" "data/mscoco"

# # Remove cache directory safely
# if [ -d "data/abc/cache" ]; then
#     echo "Removing cache directory..."
#     rm -rf "data/abc/cache"
# fi

# echo "All tasks completed safely."
