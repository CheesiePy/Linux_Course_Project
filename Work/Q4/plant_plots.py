#!/usr/bin/env python3
import argparse
import matplotlib.pyplot as plt

def cleaned_float(value):
    """Strip extra whitespace, quotes, and commas, then convert to float."""
    # First remove all surrounding whitespace, then remove quotes, then remove commas.
    cleaned = value.strip().strip('"\'' ).replace(',', '')
    try:
        return float(cleaned)
    except Exception as e:
        raise argparse.ArgumentTypeError(f"Invalid float value: {value}") from e

def cleaned_int(value):
    """Strip extra whitespace, quotes, and commas, then convert to int."""
    cleaned = value.strip().strip('"\'' ).replace(',', '')
    try:
        return int(cleaned)
    except Exception as e:
        raise argparse.ArgumentTypeError(f"Invalid int value: {value}") from e

parser = argparse.ArgumentParser(description="Plot plant data.")
parser.add_argument('--plant', type=str, required=True, help='Name of the plant')
parser.add_argument('--height', type=cleaned_float, nargs='+', required=True, help='Space separated heights')
parser.add_argument('--leaf_count', type=cleaned_int, nargs='+', required=True, help='Space separated leaf counts')
parser.add_argument('--dry_weight', type=cleaned_float, nargs='+', required=True, help='Space separated dry weights')

args = parser.parse_args()

# For demonstration, print the cleaned inputs.
print("Plant:", args.plant)
print("Heights:", args.height)
print("Leaf counts:", args.leaf_count)
print("Dry weights:", args.dry_weight)

# Insert your plotting code here if needed.



plt.figure()
plt.plot(args.height, args.leaf_count, marker='o')
plt.title(f"{args.plant} - Height vs. Leaf Count")
plt.xlabel("Height")
plt.ylabel("Leaf Count")
output_file = f"{args.plant}_plot.png"
plt.savefig(output_file)
print(f"Diagram saved as {output_file}")
