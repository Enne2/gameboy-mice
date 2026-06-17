import sys

rat_art = [
"  ######                        ######  ",
" ########                      ######## ",
"##########                    ##########",
" ##########                  ########## ",
"  ########                    ########  ",
"   ######  ..................  ######   ",
"          ....................          ",
"         ......................         ",
"        ........................        ",
"       ....++++..........++++....       ",
"      ....++++++........++++++....      ",
"      ...++++++++......++++++++...      ",
"     ...++++++++++....++++++++++...     ",
"     ...+++####+++....+++####+++...     ",
"     ...++######++....++######++...     ",
"     ...++######++....++######++...     ",
"     ...+++####+++....+++####+++...     ",
"      ...++++++++......++++++++...      ",
"      ...++++++++......++++++++...      ",
"       ...++++++........++++++...       ",
"       ..........................       ",
"        ........................        ",
"         .....++++++++++++.....         ",
"          ...+############+...          ",
"           ..+##++####++##+..           ",
"           ..+##++####++##+..           ",
"            .+############+.            ",
"             .++++++++++++.             ",
"              ............              ",
"               ..........               ",
"                ........                ",
"                 ......                 "
]

# 40x32 pixels = 5x4 tiles
WIDTH_TILES = len(rat_art[0]) // 8
HEIGHT_TILES = len(rat_art) // 8

def char_to_color(c):
    if c == ' ': return 0
    if c == '.': return 1
    if c == '+': return 2
    if c == '#': return 3
    return 0

tiles = []
for ty in range(HEIGHT_TILES):
    for tx in range(WIDTH_TILES):
        tile_data = []
        for y in range(8):
            row_str = rat_art[ty*8 + y][tx*8 : tx*8 + 8]
            low_byte = 0
            high_byte = 0
            for x in range(8):
                color = char_to_color(row_str[x])
                if color & 1:
                    low_byte |= (1 << (7 - x))
                if color & 2:
                    high_byte |= (1 << (7 - x))
            tile_data.append(low_byte)
            tile_data.append(high_byte)
        tiles.append(tile_data)

with open('src/game_over_face.h', 'w') as f:
    f.write("#ifndef GAME_OVER_FACE_H\n")
    f.write("#define GAME_OVER_FACE_H\n\n")
    f.write("#include <stdint.h>\n\n")
    f.write(f"extern const uint8_t game_over_face_tiles[{len(tiles) * 16}];\n\n")
    f.write("#endif\n")

with open('src/game_over_face.c', 'w') as f:
    f.write("#include \"game_over_face.h\"\n\n")
    f.write(f"const uint8_t game_over_face_tiles[{len(tiles) * 16}] = {{\n")
    for tile in tiles:
        f.write("    " + ", ".join([f"0x{b:02X}" for b in tile]) + ",\n")
    f.write("};\n")

print("Generated src/game_over_face.h and src/game_over_face.c")
