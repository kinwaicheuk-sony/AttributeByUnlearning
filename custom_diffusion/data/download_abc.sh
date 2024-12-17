mkdir -p data/abc

# enable faster huggingface data transfer and download
export HF_HUB_ENABLE_HF_TRANSFER=1

mkdir -p data/abc/cache
python -c 'from huggingface_hub import snapshot_download; snapshot_download(repo_id="sywang/GenDataAttribution", allow_patterns=["exemplar/*", "synth_test/*", "laion_subset/*", "models_test/*", "json/test_*", "imagenet_class_to_categories.json", "path_to_prompts.json"], repo_type="dataset", local_dir="data/abc", cache_dir="data/abc/cache")'
python -c 'from huggingface_hub import snapshot_download; snapshot_download(repo_id="sywang/AttributeByUnlearning", allow_patterns=["abc/*"], repo_type="dataset", local_dir="data", cache_dir="data/abc/cache")'

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

# Extract exemplar, synthetic test data, and model weights
extract_and_cleanup "data/abc/exemplar/exemplar.7z.001" "data/abc"
extract_and_cleanup "data/abc/synth_test/synth_test.7z.001" "data/abc"
extract_and_cleanup "data/abc/laion_subset/laion_subset.7z.001" "data/abc"
extract_and_cleanup "data/abc/models_test/models_test.7z.001" "data/abc"

# Extract precomputed vae latents, text embeddings
extract_and_cleanup "data/abc/laion_latents_text_embeddings/laion_latents_text_embeddings.7z.001" "data/abc"

# Remove cache directory safely
if [ -d "data/abc/cache" ]; then
    echo "Removing cache directory..."
    rm -rf "data/abc/cache"
fi

echo "All tasks completed safely."
