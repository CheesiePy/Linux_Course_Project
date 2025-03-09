#!/bin/bash
CSV_DIR="csv_files"
LOG_FILE="csv_history.log"
mkdir -p "$CSV_DIR"

function create_csv() {
    filename="$CSV_DIR/plant_$(date +%Y%m%d_%H%M%S).csv"
    echo "Plant,Height,LeafCount,DryWeight" > "$filename"
    echo "Created CSV: $filename"
}

function choose_csv() {
    echo "Available CSV files:"
    ls "$CSV_DIR"
    read -p "Enter CSV file name: " csvfile
    echo "$csvfile"
}

function display_csv() {
    csvfile=$(choose_csv)
    cat "$CSV_DIR/$csvfile"
}

function add_row() {
    csvfile=$(choose_csv)
    read -p "Enter Plant name: " plant
    read -p "Enter Height: " height
    read -p "Enter Leaf Count: " leaf
    read -p "Enter Dry Weight: " weight
    echo "$plant,$height,$leaf,$weight" >> "$CSV_DIR/$csvfile"
    echo "Row added."
}

function update_row() {
    csvfile=$(choose_csv)
    echo "Current contents:"
    nl "$CSV_DIR/$csvfile"
    read -p "Enter row number to update (excluding header): " row
    read -p "Enter new values (Plant,Height,LeafCount,DryWeight): " new_row
    awk -v r="$row" -v newline="$new_row" 'NR==1{print; next} {if(NR==r+1) print newline; else print}' "$CSV_DIR/$csvfile" > temp.csv && mv temp.csv "$CSV_DIR/$csvfile"
    echo "Row updated."
}

function delete_row() {
    csvfile=$(choose_csv)
    echo "Current contents:"
    nl "$CSV_DIR/$csvfile"
    read -p "Enter row number to delete (excluding header): " row
    awk -v r="$row" 'NR==1 || NR!=r+1' "$CSV_DIR/$csvfile" > temp.csv && mv temp.csv "$CSV_DIR/$csvfile"
    echo "Row deleted."
}

function highest_leaf() {
    csvfile=$(choose_csv)
    tail -n +2 "$CSV_DIR/$csvfile" | sort -t, -k3 -nr | head -n1
}

function menu() {
    while true; do
        echo "Menu:"
        echo "1. Create new CSV"
        echo "2. Choose CSV file"
        echo "3. Display CSV file"
        echo "4. Add a row"
        echo "5. Run Python diagram generation"
        echo "6. Update a row"
        echo "7. Delete a row"
        echo "8. Display plant with highest leaf count"
        echo "9. Exit"
        read -p "Select an option: " choice
        case $choice in
            1) create_csv ;;
            2) choose_csv ;;
            3) display_csv ;;
            4) add_row ;;
            5) echo "Running Python diagram generation..." ;;  # You can call your Python script here
            6) update_row ;;
            7) delete_row ;;
            8) highest_leaf ;;
            9) break ;;
            *) echo "Invalid option" ;;
        esac
        echo "--------------------"
    done
}

menu
echo "Command history logged" >> "$LOG_FILE"
history >> "$LOG_FILE"
