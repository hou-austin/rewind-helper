#!/bin/zsh

# Set nullglob option
setopt nullglob

# Define the paths for chunks and snippets
LOCATIONS_A=(
  "$HOME/Library/Application Support/com.memoryvault.MemoryVault/chunks"
  "$HOME/Library/Application Support/com.memoryvault.MemoryVault/snippets"
)
LOCATION_B="/Volumes/STEALTH/Rewind"

# Iterate through each directory (chunks and snippets)
for LOCATION_A in "${LOCATIONS_A[@]}"; do
  LOCATION_B_SUBDIR="$LOCATION_B/$(basename "$LOCATION_A")"

  # Create the directory if it doesn't exist
  mkdir -p "$LOCATION_B_SUBDIR"

  # Iterate through every folder in Location B
  for folder in "$LOCATION_B_SUBDIR"/*; do
      if [ -d "$folder" ]; then
          symlink="$LOCATION_A/$(basename "$folder")"

          # If a folder is found in Location B but no existing symlink at Location A points to it
          if [ ! -L "$symlink" ]; then
              # Delete the folder at Location B
              echo "Deleting $folder"
              rm -rf "$folder"
          fi
      fi
  done

  # Iterate through every folder in Location A
  for folder in "$LOCATION_A"/*; do
      if [ -d "$folder" ] && [ ! -L "$folder" ]; then
          # Extract folder date
          folder_date=$(basename "$folder" | awk -FT '{print $1}')
          folder_timestamp=$(date -j -f "%Y-%m-%d" "$folder_date" "+%s")
          current_timestamp=$(date "+%s")
          days_old=$(( (current_timestamp - folder_timestamp) / 60 / 60 / 24 ))

          # Move folders over 14 days old
          if [ "$days_old" -gt 14 ]; then
              # Check if the file is not being used by any other process
              if ! lsof "$folder" >/dev/null; then
                  new_folder="$LOCATION_B_SUBDIR/$(basename "$folder")"

                  # Move the folder
                  if mv "$folder" "$new_folder"; then
                      # Create a symlink
                      echo "Creating symlink for $new_folder"
                      ln -s "$new_folder" "$folder"
                  else
                      # If moving failed, continue with the next folder
                      echo "Failed to move $folder"
                      continue
                  fi
              fi
          fi
      fi
  done
done

echo "Done at $(date)"