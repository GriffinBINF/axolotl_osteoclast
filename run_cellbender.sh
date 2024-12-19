#!/bin/bash

# Check if the clean_adata directory exists; if not, create it
if [ ! -d "../clean_adata" ]; then
  mkdir ../clean_adata
fi

# Loop through all h5ad files in the current directory
for file in *.h5ad; do
  # Define the output file path
  output_file="../clean_adata/$(basename "$file" .h5ad)denoised.h5"

  # Check if the output file already exists
  if [ -f "$output_file" ]; then
    echo "Output file '$output_file' already exists. Skipping..."
  else
    # If the output file does not exist, run CellBender
    echo "Processing '$file' with CellBender..."
    cellbender remove-background \
      --input "$file" \
      --output "$output_file" \
      --total-droplets-included 50000 \
      --checkpoint-mins 5 \
      --cuda
  fi
done
  fi
done