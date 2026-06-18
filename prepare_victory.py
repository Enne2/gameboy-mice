import sys
from PIL import Image
import numpy as np
import collections

img_path = '/tmp/victory_cropped.png'
try:
    img = Image.open(img_path).convert('L')
except Exception as e:
    print(f"Error opening image: {e}")
    sys.exit(1)

w, h = img.size
target_ratio = 160 / 144
img_ratio = w / h
if img_ratio > target_ratio:
    new_w = int(h * target_ratio)
    left = (w - new_w) // 2
    img = img.crop((left, 0, left + new_w, h))
else:
    new_h = int(w / target_ratio)
    top = (h - new_h) // 2
    img = img.crop((0, top, w, top + new_h))

img = img.resize((160, 144), Image.Resampling.LANCZOS)
np_img = np.array(img)
palette_img = np.zeros_like(np_img)
palette_img[np_img < 64] = 3
palette_img[(np_img >= 64) & (np_img < 128)] = 2
palette_img[(np_img >= 128) & (np_img < 192)] = 1
palette_img[np_img >= 192] = 0

tiles = []
for y in range(0, 144, 8):
    for x in range(0, 160, 8):
        tile = palette_img[y:y+8, x:x+8]
        t_tuple = tuple(map(tuple, tile))
        tiles.append(t_tuple)

unique_tiles = list(collections.OrderedDict.fromkeys(tiles))

if len(unique_tiles) > 256:
    print("WARNING: More than 256 unique tiles! Reducing...")
    counts = collections.Counter(tiles)
    most_common = [t for t, c in counts.most_common(256)]
    reduced_unique = most_common
    for i in range(len(tiles)):
        if tiles[i] not in reduced_unique:
            t_arr = np.array(tiles[i])
            best_match = 0
            best_dist = float('inf')
            for j, ru in enumerate(reduced_unique):
                dist = np.sum((t_arr - np.array(ru))**2)
                if dist < best_dist:
                    best_dist = dist
                    best_match = j
            tiles[i] = reduced_unique[best_match]
    unique_tiles = reduced_unique
    print(f"Reduced to {len(unique_tiles)} unique tiles.")

tile_map = [unique_tiles.index(t) for t in tiles]

c_tiles = []
for tile in unique_tiles:
    tile_data = []
    for row in tile:
        low_byte = 0
        high_byte = 0
        for x, color in enumerate(row):
            if color & 1:
                low_byte |= (1 << (7 - x))
            if color & 2:
                high_byte |= (1 << (7 - x))
        tile_data.append(low_byte)
        tile_data.append(high_byte)
    c_tiles.append(tile_data)

with open('src/victory_bg.h', 'w') as f:
    f.write("#ifndef VICTORY_BG_H\n#define VICTORY_BG_H\n\n#include <stdint.h>\n\n")
    f.write(f"extern const uint8_t victory_bg_tiles[{len(c_tiles) * 16}];\n")
    f.write(f"extern const uint8_t victory_bg_map[{len(tile_map)}];\n\n#endif\n")

with open('src/victory_bg.c', 'w') as f:
    f.write("#include \"victory_bg.h\"\n\n")
    f.write(f"const uint8_t victory_bg_tiles[{len(c_tiles) * 16}] = {{\n")
    for tile in c_tiles:
        f.write("    " + ", ".join([f"0x{b:02X}" for b in tile]) + ",\n")
    f.write("};\n\n")
    f.write(f"const uint8_t victory_bg_map[{len(tile_map)}] = {{\n")
    for i in range(0, len(tile_map), 20):
        f.write("    " + ", ".join([f"0x{b:02X}" for b in tile_map[i:i+20]]) + ",\n")
    f.write("};\n")

print("Generated src/victory_bg.h and src/victory_bg.c")
