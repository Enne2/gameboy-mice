import sys
from PIL import Image
import numpy as np
import collections

img_path = '/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/rat_king_boss_1781730936484.png'
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

# Draw GAME OVER text directly onto the pixel data
font = {
    'G': [" ### ", "#   #", "#    ", "# ###", "#   #", "#   #", " ### "],
    'A': [" ### ", "#   #", "#   #", "#####", "#   #", "#   #", "#   #"],
    'M': ["#   #", "## ##", "# # #", "#   #", "#   #", "#   #", "#   #"],
    'E': ["#####", "#    ", "#    ", "#### ", "#    ", "#    ", "#####"],
    'O': [" ### ", "#   #", "#   #", "#   #", "#   #", "#   #", " ### "],
    'V': ["#   #", "#   #", "#   #", "#   #", "#   #", " # # ", "  #  "],
    'R': ["#### ", "#   #", "#   #", "#### ", "# #  ", "#  # ", "#   #"],
    '!': ["  #  ", "  #  ", "  #  ", "  #  ", "     ", "  #  ", "  #  "],
    ' ': ["     ", "     ", "     ", "     ", "     ", "     ", "     "]
}

text_str = "GAME OVER!"
scale = 2
char_w = 5 * scale
char_h = 7 * scale
spacing = 1 * scale
start_x = (160 - len(text_str) * (char_w + spacing)) // 2
start_y = 144 - char_h - 4

# Keep track of which pixels are text
is_text_mask = np.zeros_like(palette_img, dtype=bool)

box_pad = 2
for y in range(start_y - box_pad, start_y + char_h + box_pad):
    for x in range(start_x - box_pad, start_x + len(text_str) * (char_w + spacing) + box_pad):
        if 0 <= y < 144 and 0 <= x < 160:
            palette_img[y, x] = 3 # Black background
            is_text_mask[y, x] = True

for i, char in enumerate(text_str):
    if char in font:
        glyph = font[char]
        for row in range(7):
            for col in range(5):
                if glyph[row][col] == '#':
                    for sy in range(scale):
                        for sx in range(scale):
                            py = start_y + row * scale + sy
                            px = start_x + i * (char_w + spacing) + col * scale + sx
                            if 0 <= py < 144 and 0 <= px < 160:
                                palette_img[py, px] = 0 # White text
                                is_text_mask[py, px] = True

tiles = []
is_text_tile = []
for y in range(0, 144, 8):
    for x in range(0, 160, 8):
        tile = palette_img[y:y+8, x:x+8]
        t_tuple = tuple(map(tuple, tile))
        tiles.append(t_tuple)
        is_text_tile.append(np.any(is_text_mask[y:y+8, x:x+8]))

unique_tiles = list(collections.OrderedDict.fromkeys(tiles))

if len(unique_tiles) > 256:
    print("WARNING: More than 256 unique tiles! Reducing...")
    
    # Priority 1: Text tiles
    text_unique = list(collections.OrderedDict.fromkeys([tiles[i] for i in range(len(tiles)) if is_text_tile[i]]))
    
    # Priority 2: Most frequent tiles
    counts = collections.Counter(tiles)
    for t in text_unique:
        del counts[t] # already added
    
    most_common = [t for t, c in counts.most_common(256 - len(text_unique))]
    
    reduced_unique = text_unique + most_common
    
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

# Reconstruct image to check visual quality
preview_img = np.zeros((144, 160), dtype=np.uint8)
for i, t in enumerate(tiles):
    y = (i // 20) * 8
    x = (i % 20) * 8
    preview_img[y:y+8, x:x+8] = np.array(t)

# Save preview as image (colors 0=White, 1=LightGray, 2=DarkGray, 3=Black)
color_map = {0: 255, 1: 170, 2: 85, 3: 0}
preview_rgb = np.zeros((144, 160, 3), dtype=np.uint8)
for y in range(144):
    for x in range(160):
        c = color_map[preview_img[y, x]]
        preview_rgb[y, x] = [c, c, c]

Image.fromarray(preview_rgb).save('/tmp/preview_gameover.png')
print("Saved preview to /tmp/preview_gameover.png")

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

with open('src/rat_bg.h', 'w') as f:
    f.write("#ifndef RAT_BG_H\n#define RAT_BG_H\n\n#include <stdint.h>\n\n")
    f.write(f"extern const uint8_t rat_bg_tiles[{len(c_tiles) * 16}];\n")
    f.write(f"extern const uint8_t rat_bg_map[{len(tile_map)}];\n\n#endif\n")

with open('src/rat_bg.c', 'w') as f:
    f.write("#include \"rat_bg.h\"\n\n")
    f.write(f"const uint8_t rat_bg_tiles[{len(c_tiles) * 16}] = {{\n")
    for tile in c_tiles:
        f.write("    " + ", ".join([f"0x{b:02X}" for b in tile]) + ",\n")
    f.write("};\n\n")
    f.write(f"const uint8_t rat_bg_map[{len(tile_map)}] = {{\n")
    for i in range(0, len(tile_map), 20):
        f.write("    " + ", ".join([f"0x{b:02X}" for b in tile_map[i:i+20]]) + ",\n")
    f.write("};\n")

print("Generated src/rat_bg.h and src/rat_bg.c")
