"""Remove backgrounds from character images and save as transparent PNGs."""
import sys
import os

try:
    from rembg import remove
    from PIL import Image
except ImportError:
    print("Installing required packages...")
    import subprocess
    subprocess.check_call([sys.executable, "-m", "pip", "install", "rembg[cpu]", "pillow"])
    from rembg import remove
    from PIL import Image

# Artifact directory with source images
ARTIFACT_DIR = r"C:\Users\Adi Livnat\.gemini\antigravity-ide\brain\c496be7a-31c4-4691-8673-f1aa50000d9c"
# Output directory
OUTPUT_DIR = r"C:\Users\Adi Livnat\Desktop\inua\projects\Images"

# Map of source filenames to output filenames
characters = {
    "grace_v2_1782384331454.png": "grace_nobg.png",
    "gift_v2_1782384322995.png": "gift_nobg.png",
    "inua_v4_1782384312823.png": "inua_female_nobg.png",
    "trust_v2_1782384342319.png": "trust_nobg.png",
    "faith_v2_1782384303661.png": "faith_nobg.png",
}

for src_name, out_name in characters.items():
    src_path = os.path.join(ARTIFACT_DIR, src_name)
    out_path = os.path.join(OUTPUT_DIR, out_name)
    
    if not os.path.exists(src_path):
        print(f"SKIP: {src_name} not found")
        continue
    
    print(f"Processing {src_name} -> {out_name}...")
    with open(src_path, "rb") as f:
        input_data = f.read()
    
    output_data = remove(input_data)
    
    # Save the result
    with open(out_path, "wb") as f:
        f.write(output_data)
    
    print(f"  Saved: {out_path}")

print("\nDone! All characters processed.")
