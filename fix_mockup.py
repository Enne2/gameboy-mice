from PIL import Image
import numpy as np

img_path = '/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/gb_mockup_1781772641040.png'
img = Image.open(img_path).convert('RGB')
img = img.resize((160, 144), Image.Resampling.LANCZOS)

gray = img.convert('L')
arr = np.array(gray)

quantized = np.zeros_like(arr, dtype=np.uint8)
quantized[arr >= 192] = 0
quantized[(arr >= 128) & (arr < 192)] = 1
quantized[(arr >= 64) & (arr < 128)] = 2
quantized[arr < 64] = 3

# Patch out rats and bombs with floor color (0) or hedge color depending on position
def patch(x1, x2, y1, y2, color=0):
    quantized[y1:y2, x1:x2] = color

# Rat 1 (left)
patch(8, 24, 76, 92, 0)
# Rat 2 (top mid)
patch(52, 68, 44, 56, 0)
# Rat 3 (right mid)
patch(108, 124, 60, 72, 0)
# Rat 4 (bottom right)
patch(124, 140, 88, 100, 0)
# Bomb
patch(106, 118, 104, 116, 0)
# UI icons
patch(120, 140, 0, 10, 0) # Bomb/Rat UI

tile_map = np.zeros((18, 20), dtype=np.uint16)

def tile_to_bytes(tile):
    res = []
    for row in range(8):
        lo = hi = 0
        for col in range(8):
            val = tile[row, col]
            if val & 1: lo |= (1 << (7 - col))
            if val & 2: hi |= (1 << (7 - col))
        res.append(lo)
        res.append(hi)
    return tuple(res)

unique_tiles_map = {}
unique_tiles_list = []

for y in range(18):
    for x in range(20):
        tile = quantized[y*8:(y+1)*8, x*8:(x+1)*8]
        t_bytes = tile_to_bytes(tile)
        if t_bytes not in unique_tiles_map:
            unique_tiles_map[t_bytes] = len(unique_tiles_list)
            unique_tiles_list.append(t_bytes)
        tile_map[y, x] = unique_tiles_map[t_bytes]

print(f"Total unique tiles before reduction: {len(unique_tiles_list)}")

def tile_diff(t1, t2):
    return sum(bin(a^b).count('1') for a, b in zip(t1, t2))

if len(unique_tiles_list) > 256:
    print("Reducing tiles...")
    
    # Precompute diffs
    diffs = {}
    for i in range(len(unique_tiles_list)):
        for j in range(i+1, len(unique_tiles_list)):
            diffs[(i, j)] = tile_diff(unique_tiles_list[i], unique_tiles_list[j])
            
    while len(unique_tiles_list) > 256:
        # Find best pair
        best_pair = min(diffs, key=diffs.get)
        i, j = best_pair
        
        # Merge j into i
        for r in range(18):
            for c in range(20):
                if tile_map[r, c] == j:
                    tile_map[r, c] = i
                elif tile_map[r, c] > j:
                    tile_map[r, c] -= 1
                    
        unique_tiles_list.pop(j)
        
        # Recompute diffs dict (remove keys with j, shift > j)
        new_diffs = {}
        for k, v in diffs.items():
            ki, kj = k
            if ki == j or kj == j: continue
            if ki > j: ki -= 1
            if kj > j: kj -= 1
            new_diffs[(ki, kj)] = v
            
        diffs = new_diffs

print(f"Reduced to {len(unique_tiles_list)} unique tiles.")

with open('src/mockup_gfx.c', 'w') as f:
    f.write('#include "mockup_gfx.h"\n\n')
    f.write(f'const unsigned char MockupTileData[{len(unique_tiles_list) * 16}] = {{\n')
    for t in unique_tiles_list:
        f.write('    ' + ', '.join(f"0x{b:02X}" for b in t) + ',\n')
    f.write('};\n\n')
    
    f.write('const unsigned char MockupMapData[360] = {\n')
    for y in range(18):
        f.write('    ' + ', '.join(f"{tile_map[y, x]}" for x in range(20)) + ',\n')
    f.write('};\n')

with open('src/mockup_gfx.h', 'w') as f:
    f.write('#ifndef MOCKUP_GFX_H\n#define MOCKUP_GFX_H\n\n')
    f.write('extern const unsigned char MockupTileData[];\n')
    f.write('extern const unsigned char MockupMapData[];\n')
    f.write('#endif\n')

print("Mockup C files generated.")
