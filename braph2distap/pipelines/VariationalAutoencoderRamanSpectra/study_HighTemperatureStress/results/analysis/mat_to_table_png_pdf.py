#!/usr/bin/env python3
"""
Batch Generate Table PNGs from MAT Files
----------------------------------------
Loads .mat files with Raman spectral data and generates tables as PNGs + PDFs.

Data format:
- 3 columns → [raw wavenumber, rounded wavenumber, absolute area]
- 2 columns → [rounded wavenumber, absolute area]

Output:
- Always a 2-column table with:
    1. Rounded wavenumber (cm^-1)
    2. A(ν̃) (a.u.)

Features:
- Clears terminal before running
- Auto-checks and installs required packages
- Reads all files matching a pattern (default: *.mat)
- Splits into 50-row chunks
- All tables are placed in a single row
- Tables are horizontally centered
- Saves both PNG and PDF for each file
"""

import importlib
import subprocess
import sys
import os
from pathlib import Path
import glob
import math
import matplotlib.pyplot as plt

# === Clear terminal ===
def clear_terminal():
    os.system('cls' if os.name == 'nt' else 'clear')

clear_terminal()

# === Auto-install helper ===
def install_and_import(package, import_name=None):
    try:
        return importlib.import_module(import_name or package)
    except ImportError:
        print(f"[INFO] Installing missing package: {package}")
        subprocess.check_call([sys.executable, "-m", "pip", "install", package])
        return importlib.import_module(import_name or package)

# === Ensure dependencies ===
sio = install_and_import("scipy.io", "scipy.io")
pd = install_and_import("pandas")

# === User Input ===
pattern = "ranked_sig_pks_*.mat"
chunk_size = 50

# === Process all matching files ===
files = sorted(glob.glob(pattern))
if not files:
    print(f"[WARNING] No files found matching pattern: {pattern}")
    sys.exit(0)

for mat_file in files:
    mat_path = Path(mat_file)
    output_base = mat_path.stem + "_table"
    print(f"[INFO] Processing {mat_file} → {output_base}.png / .pdf")

    # Load MAT file
    mat = sio.loadmat(mat_file)

    # Auto-detect first non-metadata variable
    data = None
    for k, v in mat.items():
        if not k.startswith("__"):
            data = v
            break
    if data is None:
        print(f"[ERROR] No valid data found in {mat_file}")
        continue

    # === Normalize shape ===
    data = data.squeeze()
    if data.ndim == 3 and data.shape[2] == 1:
        data = data[:, :, 0]
    if data.ndim == 1 and data.size == 3:
        data = data.reshape(1, 3)
    if data.ndim == 2 and data.shape[0] == 3 and data.shape[1] != 3:
        data = data.T

    if data.ndim != 2 or data.shape[1] < 2:
        print(f"[ERROR] {mat_file} does not have usable structure (got {data.shape}).")
        continue

    # === Adaptive column selection ===
    if data.shape[1] >= 3:
        df = pd.DataFrame({
            r"$\tilde{\nu}$ (cm$^{-1}$)": data[:, -2],
            r"$A(\tilde{\nu})$ (a.u.)": data[:, -1]
        })
    else:
        df = pd.DataFrame({
            r"$\tilde{\nu}$ (cm$^{-1}$)": data[:, 0],
            r"$A(\tilde{\nu})$ (a.u.)": data[:, 1]
        })

    # Round last column
    last_col = df.columns[-1]
    df[last_col] = df[last_col].round(2)

    # === Split into chunks (50 rows each) ===
    n_chunks = math.ceil(len(df) / chunk_size)
    chunks = [df.iloc[i*chunk_size:(i+1)*chunk_size] for i in range(n_chunks)]

    # === Build figure with exactly n_chunks subplots in 1 row ===
    fig, axes = plt.subplots(
        1, n_chunks,
        figsize=(11.7, 3.5),  # A4 width, adjust height for table size
        squeeze=False
    )
    axes = axes[0]  # flatten single row

    for idx, chunk in enumerate(chunks):
        ax = axes[idx]
        ax.axis("off")

        if chunk.empty:
            continue

        table = ax.table(
            cellText=chunk.values,
            colLabels=chunk.columns,
            loc="upper center",
            cellLoc="center"
        )
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.scale(0.6, 1.0)

        for (row, col), cell in table.get_celld().items():
            if row == 0:
                cell.set_text_props(weight="bold")

    plt.subplots_adjust(
        wspace=0.05,
        left=0.05, right=0.95, top=0.9, bottom=0.1
    )

    # Save both PNG + PDF
    plt.savefig(output_base + ".png", dpi=300, bbox_inches="tight")
    plt.savefig(output_base + ".pdf", bbox_inches="tight")
    plt.close(fig)

    print(f"[SUCCESS] Saved {output_base}.png and {output_base}.pdf")

print("[DONE] All matching MAT files processed.")