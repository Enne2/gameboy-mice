import os
from PIL import Image
import numpy as np

img_path = '/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/test_mockup_clean.png'
img = Image.open(img_path).convert('RGB')
img = img.resize((160, 144), Image.Resampling.LANCZOS)
gray = img.convert('L')
arr = np.array(gray)

quantized = np.zeros_like(arr, dtype=np.uint8)
quantized[arr >= 192] = 0
quantized[(arr >= 128) & (arr < 192)] = 1
quantized[(arr >= 64) & (arr < 128)] = 2
quantized[arr < 64] = 3

is_wall = np.zeros((18, 20), dtype=bool)
for y in range(18):
    for x in range(20):
        tile = quantized[y*8:(y+1)*8, x*8:(x+1)*8]
        if np.sum(tile > 0) > 32:
            is_wall[y, x] = True

for y in range(18):
    is_wall[y, 0] = False
    is_wall[y, 19] = False
for x in range(20):
    is_wall[0, x] = False
    is_wall[16, x] = False
    is_wall[17, x] = False

mockup_extracted = {}

# We'll extract 6 floor tiles to give variety!
floors = []
for y in range(2, 15):
    for x in range(2, 18):
        if not is_wall[y, x]:
            floors.append(quantized[y*8:(y+1)*8, x*8:(x+1)*8])
            if len(floors) == 6:
                break
    if len(floors) == 6: break

# If we couldn't find 6, just pad
while len(floors) < 6:
    floors.append(np.zeros((8, 8), dtype=np.uint8))

for y in range(1, 16):
    for x in range(1, 19):
        if is_wall[y, x]:
            n = is_wall[y-1, x]
            s = is_wall[y+1, x]
            e = is_wall[y, x+1]
            w = is_wall[y, x-1]
            mask = (8 if n else 0) | (4 if e else 0) | (2 if s else 0) | (1 if w else 0)
            if mask not in mockup_extracted:
                mockup_extracted[mask] = quantized[y*8:(y+1)*8, x*8:(x+1)*8]

# Ensure all 16 masks exist
# If a mask is missing, try to synthesize it by rotating/flipping or just defaulting to mask 15
base_wall = mockup_extracted.get(15, np.full((8,8), 2, dtype=np.uint8))

def patch_mask(mask):
    if mask in mockup_extracted:
        return mockup_extracted[mask]
    
    # Very simple synthesis using the base wall 15, and floor tiles to cut the edges
    t = np.copy(base_wall)
    f = floors[0]
    n = (mask & 8) != 0
    e = (mask & 4) != 0
    s = (mask & 2) != 0
    w = (mask & 1) != 0
    if not n:
        t[0,:] = f[0,:]
        t[1,:] = 1 # highlight
    if not s:
        t[6,:] = 3
        t[7,:] = f[7,:]
    if not w:
        t[:,0] = f[:,0]
        t[:,1] = 2
    if not e:
        t[:,7] = f[:,7]
        t[:,6] = 2
    return t

walls = []
for mask in range(16):
    walls.append(patch_mask(mask))

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

print("tiles.c generated directly from mockup!")
