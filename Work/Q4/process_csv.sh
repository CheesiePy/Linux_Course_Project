#!/bin/bash
# process_csv.sh
# Usage: ./process_csv.sh <csv_file>
# The CSV file should have a header and the following columns:
# plant,height,leaf_count,dry_weight
# Example row: Rose,"50 55 60 65 70","35 40 45 50 55","2.0 2.2 2.5 2.7 3.0"

CSV_FILE="$1"

if [ -z "$CSV_FILE" ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

if [ ! -f "$CSV_FILE" ]; then
    echo "CSV file not found: $CSV_FILE"
    exit 1
fi

# Check if virtual environment exists; if not, create it.
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Creating one..."
    python3 -m venv venv
fi

# Activate the virtual environment.
source venv/bin/activate

# Install required packages if requirements.txt exists.
if [ -f "requirements.txt" ]; then
    echo "Installing requirements..."
    pip install -r requirements.txt
fi

# Log file for recording processing details.
LOG_FILE="process_csv.log"
echo "CSV processing started at: $(date)" > "$LOG_FILE"

# Read the CSV file, skipping the header line.
tail -n +2 "$CSV_FILE" | while IFS=',' read -r plant height leaf_count dry_weight; do
    echo "Processing plant: $plant" | tee -a "$LOG_FILE"
    
    # Run the Python script with parameters.
    # The height, leaf_count, and dry_weight values should be space-separated numbers.
    python3 Work/Q4/plant_plots.py --plant "$plant" --height $height --leaf_count $leaf_count --dry_weight $dry_weight >> "$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "Successfully processed $plant" | tee -a "$LOG_FILE"
    else
        echo "Error processing $plant" | tee -a "$LOG_FILE"
    fi
done

echo "CSV processing completed at: $(date)" >> "$LOG_FILE"

# move the the png files to the output folder Work/Q4/output
mv *.png Diagrams/

echo "Processing complete. Log file: $LOG_FILE | Output files: Diagrams/"

# Deactivate the virtual environment.
deactivate
