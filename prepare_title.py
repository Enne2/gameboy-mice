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

# Simple 5x7 font
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
    'B': ["#### ", "#   #", "#   #", "#### ", "#   #", "#   #", "#### "],
    'O': [" ### ", "#   #", "#   #", "#   #", "#   #", "#   #", " ### "],
    'W': ["#   #", "#   #", "#   #", "# # #", "## ##", "#   #", "#   #"],
    'S': [" ### ", "#   #", "#    ", " ### ", "    #", "#   #", " ### "],
    'Y': ["#   #", "#   #", " # # ", "  #  ", "  #  ", "  #  ", "  #  "],
    'T': ["#####", "  #  ", "  #  ", "  #  ", "  #  ", "  #  ", "  #  "],
    'U': ["#   #", "#   #", "#   #", "#   #", "#   #", "#   #", " ### "],
    'N': ["#   #", "##  #", "# # #", "#  ##", "#   #", "#   #", "#   #"],
    'O': [" ### ", "#   #", "#   #", "#   #", "#   #", "#   #", " ### "],
    'V': ["#   #", "#   #", "#   #", "#   #", "#   #", " # # ", "  #  "],
    'L': ["#    ", "#    ", "#    ", "#    ", "#    ", "#    ", "#####"],
    'I': [" ### ", "  #  ", "  #  ", "  #  ", "  #  ", "  #  ", " ### "],
    'C': [" ### ", "#   #", "#    ", "#    ", "#    ", "#   #", " ### "],
    'D': ["#### ", "#   #", "#   #", "#   #", "#   #", "#   #", "#### "],
    'F': ["#####", "#    ", "#    ", "#### ", "#    ", "#    ", "#    "],
    'G': [" ### ", "#   #", "#    ", "# ###", "#   #", "#   #", " ### "],
    'T': ["#####", "  #  ", "  #  ", "  #  ", "  #  ", "  #  ", "  #  "],
    ' ': ["     ", "     ", "     ", "     ", "     ", "     ", "     "]
}
# Map lowercases to uppercases for simplicity
for c in "abcdefghijklmnopqrstuvwxyz":
    if c.upper() in font:
        font[c] = font[c.upper()]

is_text_mask = np.zeros_like(palette_img, dtype=bool)

def draw_text(text, start_y, scale=1, align="center"):
    char_w = 5 * scale
    char_h = 7 * scale
    spacing = 1 * scale
    if align == "center":
        start_x = (160 - len(text) * (char_w + spacing)) // 2
    else:
        start_x = align
        
    box_pad = 2 * scale
    for y in range(start_y - box_pad, start_y + char_h + box_pad):
        for x in range(start_x - box_pad, start_x + len(text) * (char_w + spacing) + box_pad):
            if 0 <= y < 144 and 0 <= x < 160:
                palette_img[y, x] = 3 # Black background
                is_text_mask[y, x] = True

    for i, char in enumerate(text):
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

# Title: MICE MAZE
draw_text("MICE MAZE", 10, scale=2)

# Subtitle
draw_text("A GAME BY MATTEO", 45, scale=1)
draw_text("BECAUSE HE WAS BORED", 55, scale=1)

# Press start
draw_text("PRESS START", 125, scale=1)

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
    text_unique = list(collections.OrderedDict.fromkeys([tiles[i] for i in range(len(tiles)) if is_text_tile[i]]))
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

print("Generated src/title_bg.h and src/title_bg.c")
