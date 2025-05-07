#!/bin/bash

# Create a 'compressed' directory if it doesn't exist
mkdir -p compressed

# Prompt the user for the desired quality level
echo "Select the quality level for compression:"
echo "1. Low (/screen)"
echo "2. Medium (/ebook)"
echo "3. High (/printer)"
read -p "Enter your choice (1, 2, or 3): " quality_choice

# Set the quality level based on user input
case $quality_choice in
  1)
    quality="/screen"
    ;;
  2)
    quality="/ebook"
    ;;
  3)
    quality="/printer"
    ;;
  *)
    echo "Invalid choice. Defaulting to Medium (/ebook)."
    quality="/ebook"
    ;;
esac

  echo -e "\n\nCompressing $file with quality $quality...\n"

# Loop through all PDF files in the current directory
for file in *.pdf; do

  if ! gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=$quality \
    -dNOPAUSE -dQUIET -dBATCH \
    -sOutputFile="compressed/$file" "$file"; then
      echo "❌ $file"
      continue
  else
      echo "✅ $file"
  fi

  echo "done..."
done

echo "Compression complete. Compressed files are in the 'compressed' directory."

# Wait for the user to press Enter before exiting
read -p "Press Enter to exit..."