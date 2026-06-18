import os

# 0: Floor
# 1: Light Green
# 2: Dark Green
# 3: Black

floor_tile = [
    "00000000",
    "00010000",
    "00100000",
    "00000000",
    "00000000",
    "00000010",
    "00001000",
    "00000000",
]

def make_autotile(n, e, s, w):
    # base is floor
    t = [list("00000000") for _ in range(8)]
    
    # define boundaries
    top = 0 if n else 2
    bottom = 8 if s else 6
    left = 0 if w else 2
    right = 8 if e else 6
    
    # fill with dark green
    for r in range(top, bottom):
        for c in range(left, right):
            t[r][c] = "2"
            
    # Add highlight (1) to the top edge
    if not n:
        for c in range(left, right):
            t[1][c] = "1"
            t[2][c] = "1"
            
    # Add shadow (3) to the bottom edge
    if not s:
        for c in range(left, right):
            t[6][c] = "3"
            t[7][c] = "3"
            
    # Add rounded corners
    if not n and not w:
        t[1][2] = "0"; t[1][3] = "1"; t[2][2] = "1"
    if not n and not e:
        t[1][7] = "0"; t[1][6] = "1"; t[1][5] = "1"; t[2][7] = "0"; t[2][6] = "1"
    if not s and not w:
        t[7][2] = "0"; t[7][3] = "3"; t[6][2] = "3"
    if not s and not e:
        t[7][7] = "0"; t[7][6] = "3"; t[6][7] = "0"; t[6][6] = "3"

    # Add some texture
    if n and s and e and w:
        t[3][3] = "1"; t[4][5] = "3"
        
    return ["".join(row) for row in t]

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

tiles = [floor_tile]
for mask in range(16):
    n = (mask & 8) != 0
    e = (mask & 4) != 0
    s = (mask & 2) != 0
    w = (mask & 1) != 0
    tiles.append(make_autotile(n, e, s, w))

with open('src/tiles.c', 'w') as f:
    f.write('#include "tiles.h"\n\n')
    f.write(f'const unsigned char TileData[{len(tiles)*16}] = {{\n')
    for i, t in enumerate(tiles):
        f.write(f'    // Tile {i} (Mask {i-1 if i>0 else "Floor"})\n')
        b = to_gb_format(t)
        f.write('    ' + ', '.join(f"0x{val:02X}" for val in b) + ',\n')
    f.write('};\n')

print("tiles.c generated with autotiles!")
