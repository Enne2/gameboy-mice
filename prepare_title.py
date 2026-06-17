import sys
from PIL import Image
import numpy as np
import collections

img_path = '/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/rat_bomb_escape_1781732127266.png'
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

font = {
    'A': [" ### ", "#   #", "#   #", "#####", "#   #", "#   #", "#   #"],
    'B': ["#### ", "#   #", "#   #", "#### ", "#   #", "#   #", "#### "],
    'C': [" ### ", "#   #", "#    ", "#    ", "#    ", "#   #", " ### "],
    'D': ["#### ", "#   #", "#   #", "#   #", "#   #", "#   #", "#### "],
    'E': ["#####", "#    ", "#    ", "#### ", "#    ", "#    ", "#####"],
    'F': ["#####", "#    ", "#    ", "#### ", "#    ", "#    ", "#    "],
    'G': [" ### ", "#   #", "#    ", "# ###", "#   #", "#   #", " ### "],
    'H': ["#   #", "#   #", "#   #", "#####", "#   #", "#   #", "#   #"],
    'I': [" ### ", "  #  ", "  #  ", "  #  ", "  #  ", "  #  ", " ### "],
    'M': ["#   #", "## ##", "# # #", "#   #", "#   #", "#   #", "#   #"],
    'Z': ["#####", "    #", "   # ", "  #  ", " #   ", "#    ", "#####"],
    'P': ["#### ", "#   #", "#   #", "#### ", "#    ", "#    ", "#    "],
    'R': ["#### ", "#   #", "#   #", "#### ", "# #  ", "#  # ", "#   #"],
    'O': [" ### ", "#   #", "#   #", "#   #", "#   #", "#   #", " ### "],
    'W': ["#   #", "#   #", "#   #", "# # #", "## ##", "#   #", "#   #"],
    'S': [" ### ", "#   #", "#    ", " ### ", "    #", "#   #", " ### "],
    'Y': ["#   #", "#   #", " # # ", "  #  ", "  #  ", "  #  ", "  #  "],
    'T': ["#####", "  #  ", "  #  ", "  #  ", "  #  ", "  #  ", "  #  "],
    'U': ["#   #", "#   #", "#   #", "#   #", "#   #", "#   #", " ### "],
    'N': ["#   #", "##  #", "# # #", "#  ##", "#   #", "#   #", "#   #"],
    'V': ["#   #", "#   #", "#   #", "#   #", "#   #", " # # ", "  #  "],
    'L': ["#    ", "#    ", "#    ", "#    ", "#    ", "#    ", "#####"],
    '!': ["  #  ", "  #  ", "  #  ", "  #  ", "     ", "  #  ", "  #  "],
    ' ': ["     ", "     ", "     ", "     ", "     ", "     ", "     "]
}

is_text_mask = np.zeros_like(palette_img, dtype=bool)

def draw_text(text, start_y_tiles, scale=1):
    tile_w = 8 * scale
    tile_h = 8 * scale
    start_x_tiles = (20 - len(text) * scale) // 2
    
    start_y = start_y_tiles * 8
    start_x = start_x_tiles * 8
    
    # Draw black box perfectly aligned to tile grid
    for y in range(start_y, start_y + tile_h):
        for x in range(start_x, start_x + len(text) * tile_w):
            if 0 <= y < 144 and 0 <= x < 160:
                palette_img[y, x] = 3
                is_text_mask[y, x] = True

    for i, char in enumerate(text):
        if char in font:
            glyph = font[char]
            # Center the 5x7 glyph inside the 8x8 logic
            offset_x = (8 - 5) // 2
            offset_y = (8 - 7) // 2
            
            for row in range(7):
                for col in range(5):
                    if glyph[row][col] == '#':
                        for sy in range(scale):
                            for sx in range(scale):
                                py = start_y + (row + offset_y) * scale + sy
                                px = start_x + i * tile_w + (col + offset_x) * scale + sx
                                if 0 <= py < 144 and 0 <= px < 160:
                                    palette_img[py, px] = 0
                                    is_text_mask[py, px] = True

# Align to 8x8 grid strictly
draw_text("MICE!", 1, scale=2)
draw_text("A GAME BY MATTEO", 5, scale=1)
draw_text("BECAUSE HE WAS BORED", 6, scale=1)
draw_text("PRESS START", 16, scale=1)

tiles = []
is_text_tile = []
for y in range(0, 144, 8):
    for x in range(0, 160, 8):
        tile = palette_img[y:y+8, x:x+8]
        t_tuple = tuple(map(tuple, tile))
        tiles.append(t_tuple)
        is_text_tile.append(np.any(is_text_mask[y:y+8, x:x+8]))

unique_tiles = list(collections.OrderedDict.fromkeys(tiles))

print(f"Total tiles: {len(tiles)}")
print(f"Unique tiles before reduction: {len(unique_tiles)}")

if len(unique_tiles) > 256:
    print("WARNING: More than 256 unique tiles! Reducing...")
    text_unique = list(collections.OrderedDict.fromkeys([tiles[i] for i in range(len(tiles)) if is_text_tile[i]]))
    print(f"Text unique tiles: {len(text_unique)}")
    
    counts = collections.Counter(tiles)
    for t in text_unique:
        del counts[t]
        
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

tile_map = [unique_tiles.index(t) for t in tiles]

# Preview to ensure it's not broken
preview_img = np.zeros((144, 160), dtype=np.uint8)
for i, t in enumerate(tiles):
    y = (i // 20) * 8
    x = (i % 20) * 8
    preview_img[y:y+8, x:x+8] = np.array(t)

color_map = {0: 255, 1: 170, 2: 85, 3: 0}
preview_rgb = np.zeros((144, 160, 3), dtype=np.uint8)
for y in range(144):
    for x in range(160):
        c = color_map[preview_img[y, x]]
        preview_rgb[y, x] = [c, c, c]

Image.fromarray(preview_rgb).save('/tmp/preview_title_fixed.png')

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

with open('src/title_bg.h', 'w') as f:
    f.write("#ifndef TITLE_BG_H\n#define TITLE_BG_H\n\n#include <stdint.h>\n\n")
    f.write(f"extern const uint8_t title_bg_tiles[{len(c_tiles) * 16}];\n")
    f.write(f"extern const uint8_t title_bg_map[{len(tile_map)}];\n\n#endif\n")

with open('src/title_bg.c', 'w') as f:
    f.write("#include \"title_bg.h\"\n\n")
    f.write(f"const uint8_t title_bg_tiles[{len(c_tiles) * 16}] = {{\n")
    for tile in c_tiles:
        f.write("    " + ", ".join([f"0x{b:02X}" for b in tile]) + ",\n")
    f.write("};\n\n")
    f.write(f"const uint8_t title_bg_map[{len(tile_map)}] = {{\n")
    for i in range(0, len(tile_map), 20):
        f.write("    " + ", ".join([f"0x{b:02X}" for b in tile_map[i:i+20]]) + ",\n")
    f.write("};\n")
