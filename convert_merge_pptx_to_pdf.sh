#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -i <input_dir> -o <output_dir> -m <merged_output_file>"
    echo "  -i  Input directory containing PPTX files"
    echo "  -o  Output directory for converted PDFs"
    echo "  -m  Name of the merged output PDF file"
    exit 1
}

# Parse CLI arguments
while getopts "i:o:m:c:" opt; do
    case $opt in
        i) INPUT_DIR="$OPTARG" ;;
        o) OUTPUT_DIR="$OPTARG" ;;
        m) MERGED_FILE="$OPTARG" ;;
        c) NUP="$OPTARG" ;;
        *) usage ;;
    esac
done

# Validate arguments
if [ -z "$INPUT_DIR" ] || [ -z "$OUTPUT_DIR" ] || [ -z "$MERGED_FILE" ]; then
    usage
fi

if [ -n "$NUP" ] && ! command -v pdfjam &>/dev/null; then
    echo "Error: pdfjam is not installed. Install it to use the -c option."
    exit 1
fi

# Ensure directories exist
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist."
    exit 1
fi
mkdir -p "$OUTPUT_DIR"

# Check if required tools are installed
if ! command -v libreoffice &>/dev/null || ! command -v pdfunite &>/dev/null; then
    echo "Error: LibreOffice or Poppler utilities (pdfunite) are not installed."
    exit 1
fi

# Convert each PPTX file in the input directory to PDF
for FILE in "$INPUT_DIR"/*.pptx; do
    if [ -f "$FILE" ]; then
        OUTPUT_FILE="$OUTPUT_DIR/$(basename "${FILE%.pptx}.pdf")"
        echo "Converting $FILE to $OUTPUT_FILE..."
        libreoffice --headless --convert-to pdf --outdir "$OUTPUT_DIR" "$FILE"
        if [ $? -ne 0 ]; then
            echo "Error converting $FILE. Skipping."
        fi
    else
        echo "No PPTX files found in $INPUT_DIR. Exiting."
        exit 1
    fi
done

# Merge all PDFs in the output directory
PDF_FILES=("$OUTPUT_DIR"/*.pdf)

if [ ${#PDF_FILES[@]} -eq 0 ]; then
    echo "No PDF files found to merge."
    exit 1
fi

echo "Merging PDFs into $MERGED_FILE..."
pdfunite "${PDF_FILES[@]}" "$MERGED_FILE"

if [ $? -eq 0 ]; then
    echo "Merged PDF created successfully at $MERGED_FILE."
else
    echo "Error during PDF merging."
    exit 1
fi


# Optionally combine multiple pages into one using pdfjam
if [ -n "$NUP" ]; then
    COMBINED_FILE="${MERGED_FILE%.pdf}_combined.pdf"
    echo "Combining pages into $NUP format using pdfjam..."
    pdfjam --nup "$NUP" "$MERGED_FILE" --outfile "$COMBINED_FILE"
    if [ $? -eq 0 ]; then
        echo "Combined PDF created successfully at $COMBINED_FILE."
    else
        echo "Error during page combination."
        exit 1
    fi
fi
