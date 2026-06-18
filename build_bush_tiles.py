import random
import numpy as np
from PIL import Image

# 0: Floor
# 1: Highlight
# 2: Midtone
# 3: Shadow

random.seed(1234) # deterministic

# Base seamless vegetation pattern (8x8)
base_veg = [
    [2, 1, 2, 2, 3, 2, 2, 1],
    [1, 2, 2, 1, 2, 2, 3, 2],
    [2, 2, 3, 2, 2, 1, 2, 2],
    [3, 2, 2, 1, 2, 2, 2, 3],
    [2, 1, 2, 2, 3, 2, 2, 2],
    [2, 2, 2, 3, 2, 1, 2, 2],
    [2, 3, 2, 2, 2, 2, 1, 2],
    [1, 2, 2, 1, 2, 3, 2, 2]
]
base_veg = np.array(base_veg, dtype=np.uint8)

# To avoid repeating exactly the same pattern, we can roll it slightly per mask
# Or we just use it.
walls = []

def make_bush(n, e, s, w, mask_idx):
    # Start with base vegetation
    t = np.roll(np.roll(base_veg, mask_idx % 8, axis=0), (mask_idx // 2) % 8, axis=1).copy()
    
    # Carve N
    if not n:
        # Jagged top edge:
        # col 0..7 randomly floor or highlight
        for c in range(8):
            depth = random.choice([0, 1])
            for r in range(depth):
                t[r, c] = 0
            t[depth, c] = 1 # highlight on the leaf tip
            t[depth+1, c] = 1 # more highlight
            
    # Carve S
    if not s:
        for c in range(8):
            depth = random.choice([0, 1])
            for r in range(8 - depth, 8):
                t[r, c] = 0
            t[7 - depth, c] = 3 # shadow on the bottom leaf
            t[6 - depth, c] = 3
            
    # Carve W
    if not w:
        for r in range(8):
            depth = random.choice([0, 1])
            for c in range(depth):
                t[r, c] = 0
            # Ensure the edge isn't floor, make it a midtone/shadow
            if t[r, depth] == 0: t[r, depth] = 2
            
    # Carve E
    if not e:
        for r in range(8):
            depth = random.choice([0, 1])
            for c in range(8 - depth, 8):
                t[r, c] = 0
            if t[r, 7 - depth] == 0: t[r, 7 - depth] = 2

    # Fix Corners if isolated
    if not n and not w:
        t[0, 0] = t[0, 1] = t[1, 0] = 0
        t[1, 1] = 1
    if not n and not e:
        t[0, 7] = t[0, 6] = t[1, 7] = 0
        t[1, 6] = 1
    if not s and not w:
        t[7, 0] = t[7, 1] = t[6, 0] = 0
        t[6, 1] = 3
    if not s and not e:
        t[7, 7] = t[7, 6] = t[6, 7] = 0
        t[6, 6] = 3

    return t

for mask in range(16):
    n = (mask & 8) != 0
    e = (mask & 4) != 0
    s = (mask & 2) != 0
    w = (mask & 1) != 0
    walls.append(make_bush(n, e, s, w, mask))

floors = [
    # 0: Clean floor
    np.array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ], dtype=np.uint8),
    # 1: Tiny pebble/crack
    np.array([
        [0,0,0,0,0,0,0,0],
        [0,0,1,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,1],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ], dtype=np.uint8),
    # 2: Subtle horizontal vein
    np.array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,1,1,0,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ], dtype=np.uint8),
    # 3: Diagonal crack
    np.array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,1,0],
        [0,0,0,0,0,1,0,0],
        [0,0,0,0,1,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ], dtype=np.uint8),
    # 4: Forked crack
    np.array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,1,0,0,0,0,0],
        [0,0,0,1,1,0,0,0],
        [0,0,0,0,0,1,0,0],
        [0,0,0,0,0,0,0,0]
    ], dtype=np.uint8),
    # 5: Dots / dust
    np.array([
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,1,0,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,1,0,0,0],
        [0,0,0,0,0,0,0,0],
        [0,0,0,0,0,0,0,0]
    ], dtype=np.uint8)
]

def to_gb_format(tile_np):
    bytes_arr = []
    for r in range(8):
        lo = hi = 0
        for c in range(8):
            val = int(tile_np[r, c])
            if val & 1: lo |= (1 << (7 - c))
            if val & 2: hi |= (1 << (7 - c))
        bytes_arr.append(lo)
        bytes_arr.append(hi)
    return bytes_arr

with open('src/tiles.c', 'w') as f:
    f.write('#include "tiles.h"\n\n')
    f.write(f'const unsigned char TileData[{(6+16)*16}] = {{\n')
    
    for i, fl in enumerate(floors):
        f.write(f'    // Floor variant {i}\n')
        b = to_gb_format(fl)
        f.write('    ' + ', '.join(f"0x{val:02X}" for val in b) + ',\n')
        
    for i, w in enumerate(walls):
        f.write(f'    // Wall {i}\n')
        b = to_gb_format(w)
        f.write('    ' + ', '.join(f"0x{val:02X}" for val in b) + ',\n')
        
    f.write('};\n')

colors = {
    0: (224, 248, 208),
    1: (136, 192, 112),
    2: (52, 104, 86),
    3: (8, 24, 32)
}

cols = 6
rows = 4
img = Image.new('RGB', (cols * 10, rows * 10), (255, 255, 255))
tiles = floors + walls
for idx, t in enumerate(tiles):
    c = idx % cols
    r = idx // cols
    x_offset = c * 10 + 1
    y_offset = r * 10 + 1
    for ty in range(8):
        for tx in range(8):
            color = colors[int(t[ty, tx])]
            img.putpixel((x_offset + tx, y_offset + ty), color)

img = img.resize((cols * 10 * 4, rows * 10 * 4), Image.Resampling.NEAREST)
img.save('/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/bush_tiles_preview.png')

print("tiles.c generated with bush tiles!")
