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

if len(unique_tiles_list) > 256:
    print("WARNING: More than 256 unique tiles! Reducing...")
    # Very simple reduction: keep first 256. For the rest, map to tile 0.
    for y in range(18):
        for x in range(20):
            if tile_map[y, x] >= 256:
                tile_map[y, x] = 0
    unique_tiles_list = unique_tiles_list[:256]

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
