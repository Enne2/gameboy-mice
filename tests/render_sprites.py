import os

def decode_gb_tile(data):
    pixels = [[0]*8 for _ in range(8)]
    for y in range(8):
        lsb = data[y*2]
        msb = data[y*2+1]
        for x in range(8):
            bit_lsb = (lsb >> (7 - x)) & 1
            bit_msb = (msb >> (7 - x)) & 1
            pixels[y][x] = (bit_msb << 1) | bit_lsb
    return pixels

RatSpriteData = [
    0x00, 0x00, 0x07, 0x07, 0x3F, 0x38, 0x5E, 0x71, 0x5B, 0x74, 0x3F, 0x38, 0x07, 0x07, 0x00, 0x00,
    0x00, 0x00, 0xF0, 0xF0, 0xC8, 0x08, 0xD4, 0x1C, 0xD4, 0x1C, 0xC8, 0x08, 0xF0, 0xF0, 0x00, 0x00,
    
    0x00, 0x00, 0x18, 0x18, 0x24, 0x3C, 0x3C, 0x3C, 0x3C, 0x24, 0x6E, 0x52, 0x7E, 0x42, 0x76, 0x4A,
    0x7E, 0x42, 0x7E, 0x42, 0x42, 0x42, 0x5A, 0x5A, 0x24, 0x3C, 0x18, 0x18, 0x00, 0x00, 0x00, 0x00
]

tiles = [decode_gb_tile(RatSpriteData[i*16:(i+1)*16]) for i in range(4)]

colors = {0: '  ', 1: '░░', 2: '▓▓', 3: '██'}
rgb_colors = {0: (255,255,255), 1: (170,170,170), 2: (85,85,85), 3: (0,0,0)}

def print_and_save(name, pixels_2d, width, height):
    print(f"--- {name} ---")
    for y in range(height):
        row_str = ""
        for x in range(width):
            row_str += colors[pixels_2d[y][x]]
        print(row_str)
    
    scale = 20
    with open(f"/tmp/{name}.ppm", "w") as f:
        f.write(f"P3\n{width*scale} {height*scale}\n255\n")
        for y in range(height):
            for sy in range(scale):
                for x in range(width):
                    c = pixels_2d[y][x]
                    rgb = rgb_colors[c]
                    for sx in range(scale):
                        f.write(f"{rgb[0]} {rgb[1]} {rgb[2]} ")
                f.write("\n")

right_pixels = [[0]*16 for _ in range(8)]
for y in range(8):
    for x in range(8):
        right_pixels[y][x] = tiles[0][y][x]
        right_pixels[y][x+8] = tiles[1][y][x]

left_pixels = [[0]*16 for _ in range(8)]
for y in range(8):
    for x in range(16):
        left_pixels[y][x] = right_pixels[y][15-x]

down_pixels = [[0]*8 for _ in range(16)]
for y in range(8):
    for x in range(8):
        down_pixels[y][x] = tiles[2][y][x]
        down_pixels[y+8][x] = tiles[3][y][x]

up_pixels = [[0]*8 for _ in range(16)]
for y in range(16):
    for x in range(8):
        up_pixels[y][x] = down_pixels[15-y][x]

print_and_save("sprite_right", right_pixels, 16, 8)
print_and_save("sprite_left", left_pixels, 16, 8)
print_and_save("sprite_down", down_pixels, 8, 16)
print_and_save("sprite_up", up_pixels, 8, 16)
