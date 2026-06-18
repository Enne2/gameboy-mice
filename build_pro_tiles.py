import os
from PIL import Image

# Meticulously crafted 8x8 organic tiles matching the mockup style
floors = [
    # 0: Clean floor
    [
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    ],
    # 1: Tiny pebble/crack
    [
        "00000000",
        "00100000",
        "00000000",
        "00000000",
        "00000000",
        "00000001",
        "00000000",
        "00000000"
    ],
    # 2: Subtle horizontal vein
    [
        "00000000",
        "00000000",
        "01100000",
        "00010000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    ],
    # 3: Diagonal crack
    [
        "00000000",
        "00000000",
        "00000000",
        "00000010",
        "00000100",
        "00001000",
        "00000000",
        "00000000"
    ],
    # 4: Forked crack
    [
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00100000",
        "00011000",
        "00000100",
        "00000000"
    ],
    # 5: Dots / dust
    [
        "00000000",
        "00000000",
        "00000000",
        "00010000",
        "00000000",
        "00001000",
        "00000000",
        "00000000"
    ]
]

walls = [
    # 0: Isolated bush
    [
        "00111100",
        "01122110",
        "11222211",
        "12222221",
        "12222221",
        "03333330",
        "00333300",
        "00000000"
    ],
    # 1: W connected (End pointing East)
    [
        "11111100",
        "11222110",
        "22222211",
        "22222221",
        "22222221",
        "33333330",
        "33333300",
        "00000000"
    ],
    # 2: S connected (End pointing North)
    [
        "00111100",
        "01122110",
        "11222211",
        "12222221",
        "12222221",
        "12222221",
        "12222221",
        "12222221"
    ],
    # 3: S, W connected (Top-Right Corner)
    [
        "11111100",
        "11222110",
        "22222211",
        "22222221",
        "22222221",
        "22222221",
        "22222221",
        "22222221"
    ],
    # 4: E connected (End pointing West)
    [
        "00111111",
        "01122211",
        "11222222",
        "12222222",
        "12222222",
        "03333333",
        "00333333",
        "00000000"
    ],
    # 5: E, W connected (Horizontal Straight)
    [
        "11111111",
        "11222211",
        "22222222",
        "22222222",
        "22222222",
        "33333333",
        "33333333",
        "00000000"
    ],
    # 6: E, S connected (Top-Left Corner)
    [
        "00111111",
        "01122211",
        "11222222",
        "12222222",
        "12222222",
        "12222222",
        "12222222",
        "12222222"
    ],
    # 7: E, S, W connected (Top T-Junction)
    [
        "11111111",
        "11222211",
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "22222222"
    ],
    # 8: N connected (End pointing South)
    [
        "12222221",
        "12222221",
        "12222221",
        "12222221",
        "12222221",
        "03333330",
        "00333300",
        "00000000"
    ],
    # 9: N, W connected (Bottom-Right Corner)
    [
        "22222221",
        "22222221",
        "22222221",
        "22222221",
        "22222221",
        "33333330",
        "33333300",
        "00000000"
    ],
    # 10: N, S connected (Vertical Straight)
    [
        "12222221",
        "12222221",
        "12222221",
        "12222221",
        "12222221",
        "12222221",
        "12222221",
        "12222221"
    ],
    # 11: N, S, W connected (Right T-Junction)
    [
        "22222221",
        "22222221",
        "22222221",
        "22222221",
        "22222221",
        "22222221",
        "22222221",
        "22222221"
    ],
    # 12: N, E connected (Bottom-Left Corner)
    [
        "12222222",
        "12222222",
        "12222222",
        "12222222",
        "12222222",
        "03333333",
        "00333333",
        "00000000"
    ],
    # 13: N, E, W connected (Bottom T-Junction)
    [
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "33333333",
        "33333333",
        "00000000"
    ],
    # 14: N, E, S connected (Left T-Junction)
    [
        "12222222",
        "12222222",
        "12222222",
        "12222222",
        "12222222",
        "12222222",
        "12222222",
        "12222222"
    ],
    # 15: N, E, S, W connected (Cross Junction)
    [
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "22222222",
        "22222222"
    ]
]

# Randomize texture inside the solid walls slightly for variation
import random
random.seed(12345)
for i in range(16):
    w = [list(r) for r in walls[i]]
    for r in range(1, 6):
        for c in range(1, 7):
            if w[r][c] == '2':
                if random.random() < 0.1:
                    w[r][c] = '1'
                elif random.random() < 0.1:
                    w[r][c] = '3'
    walls[i] = ["".join(row) for row in w]

# Add texture to horizontal/vertical segments
for r in range(1, 6):
    for c in range(1, 7):
        if walls[5][r][c] == '2' and random.random() < 0.15: walls[5][r][c] = '1'
        if walls[10][r][c] == '2' and random.random() < 0.15: walls[10][r][c] = '3'

tiles = floors + walls

def to_gb_format(lines):
    bytes_arr = []
    for line in lines:
        lo = hi = 0
        for i, char in enumerate(line):
            val = int(char)
            if val & 1: lo |= (1 << (7 - i))
            if val & 2: hi |= (1 << (7 - i))
        bytes_arr.append(lo)
        bytes_arr.append(hi)
    return bytes_arr

with open('src/tiles.c', 'w') as f:
    f.write('#include "tiles.h"\n\n')
    f.write(f'const unsigned char TileData[{len(tiles)*16}] = {{\n')
    
    # 6 Floors
    for i in range(6):
        f.write(f'    // Floor variant {i}\n')
        b = to_gb_format(floors[i])
        f.write('    ' + ', '.join(f"0x{val:02X}" for val in b) + ',\n')
        
    # 16 Walls
    for i in range(16):
        f.write(f'    // Wall {i}\n')
        b = to_gb_format(walls[i])
        f.write('    ' + ', '.join(f"0x{val:02X}" for val in b) + ',\n')
        
    f.write('};\n')

# Also generate a PNG preview so the user can see them
colors = {
    0: (224, 248, 208),
    1: (136, 192, 112),
    2: (52, 104, 86),
    3: (8, 24, 32)
}

cols = 6
rows = 4
img = Image.new('RGB', (cols * 10, rows * 10), (255, 255, 255))

for idx, t in enumerate(tiles):
    c = idx % cols
    r = idx // cols
    x_offset = c * 10 + 1
    y_offset = r * 10 + 1
    for ty in range(8):
        for tx in range(8):
            color = colors[int(t[ty][tx])]
            img.putpixel((x_offset + tx, y_offset + ty), color)

img = img.resize((cols * 10 * 4, rows * 10 * 4), Image.Resampling.NEAREST)
img.save('/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/pro_tiles_preview.png')

print("tiles.c and pro_tiles_preview.png generated!")
