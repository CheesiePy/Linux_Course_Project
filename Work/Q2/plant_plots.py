# plant_plots.py
import argparse
import matplotlib.pyplot as plt

def main():
    parser = argparse.ArgumentParser(description="Plot plant data")
    parser.add_argument("--plant", type=str, required=True)
    parser.add_argument("--height", type=float, nargs='+', required=True)
    parser.add_argument("--leaf_count", type=int, nargs='+', required=True)
    parser.add_argument("--dry_weight", type=float, nargs='+', required=True)
    args = parser.parse_args()

    plt.figure()
    plt.plot(args.height, args.leaf_count, marker='o')
    plt.title(f"{args.plant} - Height vs. Leaf Count")
    plt.xlabel("Height")
    plt.ylabel("Leaf Count")
    output_file = f"{args.plant}_plot.png"
    plt.savefig(output_file)
    print(f"Diagram saved as {output_file}")

if __name__ == "__main__":
    main()
