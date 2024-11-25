# Convert and Merge PPTX to PDF Script

This script converts all `.pptx` files in a specified input directory to PDF using LibreOffice CLI, merges the resulting PDFs into a single file using `pdfunite`, and optionally combines multiple pages into a single page using `pdfjam`.

## Requirements

- **LibreOffice** for `.pptx` to `.pdf` conversion.
- **Poppler utilities** for merging PDFs (`pdfunite`).
- **pdfjam** (optional) for combining multiple pages into one.

### Install Dependencies

```bash
sudo apt update
sudo apt install libreoffice poppler-utils pdfjam
```

## Usage

```bash
./convert_merge_pptx_to_pdf.sh -i <input_dir> -o <output_dir> -m <merged_output_file> [-c <nup_format>]
```

### Arguments:

- -i <input_dir>: Path to the directory containing .pptx files.
- -o <output_dir>: Path to the directory where converted PDFs will be saved.
- -m <merged_output_file>: Name of the final merged PDF file.
- -c <nup_format> (optional): Combine multiple pages into one using the specified format (e.g., 2x2, 3x2).

## Examples:

### Convert and merge .pptx files

```bash
./convert_merge_pptx_to_pdf.sh -i /home/user/pptx_files -o /home/user/pdf_files -m merged_output.pdf
```

### Convert, merge and combine pages

```bash
./convert_merge_pptx_to_pdf.sh -i /home/user/pptx_files -o /home/user/pdf_files -m merged_output.pdf -c 2x2
```

## Output:

- Converted PDFs: Saved in the specified output directory.
- Merged PDF: Created with the name provided using the -m flag.
- Combined PDF (if -c is used): Created with \_combined appended to the merged PDF name.

# Note:

- Ensure all dependencies are installed.
- File names in the input directory will determine the order of merging. Files are merged in lexical order.
- To ensure the correct order, rename files appropriately.
