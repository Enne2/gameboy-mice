def encode_gb_tile(pixels):
    data = []
    for y in range(8):
        lsb = 0
        msb = 0
        for x in range(8):
            c = pixels[y][x]
            if c & 1: lsb |= (1 << (7 - x))
            if c & 2: msb |= (1 << (7 - x))
        data.extend([lsb, msb])
    return data

def print_hex(data):
    print(", ".join(f"0x{b:02X}" for b in data))

# Down Top Half
down_top = [
    [0,0,0,0,0,0,0,0],
    [0,0,0,3,3,0,0,0],
    [0,0,3,2,2,3,0,0],
    [0,0,3,3,3,3,0,0],
    [0,0,3,1,1,3,0,0],
    [0,3,1,2,1,1,3,0],
    [0,3,1,1,1,1,3,0],
    [0,3,1,1,2,1,3,0]
]

# Down Bottom Half
down_bot = [
    [0,3,1,1,1,1,3,0],
    [0,3,1,1,1,1,3,0],
    [0,3,0,0,0,0,3,0],
    [0,3,0,3,3,0,3,0],
    [0,0,3,2,2,3,0,0],
    [0,0,0,3,3,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
]

# Combine Down
down_full = down_top + down_bot

# Rotate CCW for Right (Wait: earlier we established CCW rotation maps nose to Right side)
# If Nose is at y=12, CCW rotation: new_x = y, new_y = 7 - x?
# For 16x8 from 8x16:
# new_width = 16, new_height = 8
# old_x in 0..7, old_y in 0..15
# Rotation CCW:
# X_new = old_y
# Y_new = 7 - old_x
right_full = [[0]*16 for _ in range(8)]
for oy in range(16):
    for ox in range(8):
        nx = oy
        ny = 7 - ox
        right_full[ny][nx] = down_full[oy][ox]

# Split into two 8x8 tiles
right_left = [row[:8] for row in right_full]
right_right = [row[8:] for row in right_full]

data0 = encode_gb_tile(right_left)
data1 = encode_gb_tile(right_right)
data2 = encode_gb_tile(down_top)
data3 = encode_gb_tile(down_bot)

print("Tile 0 (Right Left):")
print_hex(data0)
print("Tile 1 (Right Right):")
print_hex(data1)
print("Tile 2 (Down Top):")
print_hex(data2)
print("Tile 3 (Down Bot):")
print_hex(data3)
