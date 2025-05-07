#!/bin/bash

# Prompt user for the maximum file size in KB
read -p "Enter the target maximum file size for PDFs (in KB): " max_size_kb

# Ask if the user wants to convert PDFs to grayscale
read -p "Do you want to convert PDFs to grayscale? (y/n): " grayscale_choice
if [[ "$grayscale_choice" == "y" ]]; then
  grayscale_option="-sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray"
  echo "✔ Grayscale conversion enabled."
else
  grayscale_option=""
  echo "❌ Keeping original colors."
fi

# Convert KB to Bytes
max_size=$((max_size_kb * 1024))

# Create the 'output' directory if it doesn't exist
mkdir -p output

# Loop through all PDF files in the current directory
for file in *.pdf; do
  # Get the size of the current PDF in bytes
  file_size=$(stat -c%s "$file")

  # Check if the file size is already below the maximum
  if [ "$file_size" -le "$max_size" ]; then
    echo -e "\n📄 Copying '$file' to output/ (size: $((file_size / 1024)) KB)"
    cp "$file" "output/$file"
  else
    dpi=300
    jpeg_quality=100
    # pdf_setting="/ebook"
    compressed_file="output/$file"

    echo -e "\n💾 Compressing '$file' (original size: $((file_size / 1024)) KB)"

    # Iteratively compress the PDF until it meets the size requirement
    while [ "$file_size" -gt "$max_size" ]; do
      # echo -e "\t🤔 Attempting compression at ${dpi} DPI, JPEG Quality: ${jpeg_quality}, PDF Setting: ${pdf_setting}..."
      echo -e "\t🤔 Attempting compression at ${dpi} DPI, JPEG Quality: ${jpeg_quality}..."

      # Compress the PDF using Ghostscript
      #  -dPDFSETTINGS="$pdf_setting" \
      
      gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dNOPAUSE -dQUIET -dBATCH \
         -r"$dpi" \
         -dColorImageResolution="$dpi" -dGrayImageResolution="$dpi" -dMonoImageResolution="$dpi" \
         -dDownsampleColorImages=true -dDownsampleGrayImages=true -dDownsampleMonoImages=true \
         -dColorImageDownsampleType=/Bicubic -dGrayImageDownsampleType=/Bicubic -dMonoImageDownsampleType=/Bicubic \
         -dCompressFonts=true -dEmbedAllFonts=false -dSubsetFonts=true \
         -dAutoFilterColorImages=false -dAutoFilterGrayImages=false \
         -dJPEGQ="$jpeg_quality" \
         $grayscale_option \
         -sOutputFile="$compressed_file" "$file"

      # Update the file size after compression
      file_size=$(stat -c%s "$compressed_file")

      # Show the new size after compression attempt
      echo -e "\t📏 Got $((file_size / 1024)) KB..."

      # Check if the file size is now acceptable
      if [ "$file_size" -le "$max_size" ]; then
        echo -e "\t✅ Compression successful at ${dpi} DPI, JPEG Quality: ${jpeg_quality} (size: $((file_size / 1024)) KB)"
        break
      fi

      # Reduce settings gradually
      if [ "$jpeg_quality" -gt 75 ]; then
        jpeg_quality=$((jpeg_quality - 5))

      elif [ "$dpi" -eq 300 ]; then
        jpeg_quality=100
        dpi=200

      elif [ "$dpi" -eq 200 ]; then
        jpeg_quality=100
        dpi=100

      elif [ "$dpi" -eq 100 ]; then
        jpeg_quality=100
        dpi=75 
        
      elif [ "$dpi" -eq 75 ]; then
        echo -e "\t❌ Unable to compress '$file' below ${max_size_kb} KB without major quality loss."
        break
      fi
    done
  fi
done

echo -e "\n\n😁👍 Processing complete. Check the 'output' directory for results.\n"

# Wait for user to press enter before closing
read -p "Press Enter to exit..."
