# Bomb and Explosion Sprites
sprites_ascii = {
    "bomb_3": [
        "   ##   ",
        "  ####  ",
        " ###### ",
        " ###### ",
        " ###### ",
        " ###### ",
        "  ####  ",
        "        "
    ],
    "bomb_2": [
        "        ",
        "   ##   ",
        "  ####  ",
        " ###### ",
        " ###### ",
        "  ####  ",
        "        ",
        "        "
    ],
    "bomb_1": [
        "        ",
        "        ",
        "   ##   ",
        "  ####  ",
        "  ####  ",
        "   ##   ",
        "        ",
        "        "
    ],
    "exp_center": [
        "##    ##",
        "# #  # #",
        "  ####  ",
        " ###### ",
        " ###### ",
        "  ####  ",
        "# #  # #",
        "##    ##"
    ],
    "exp_horiz": [
        "        ",
        "        ",
        "########",
        " ###### ",
        " ###### ",
        "########",
        "        ",
        "        "
    ],
    "exp_vert": [
        "  ####  ",
        "  ####  ",
        " ###### ",
        " ###### ",
        " ###### ",
        " ###### ",
        "  ####  ",
        "  ####  "
    ]
}

print("const unsigned char BombSpriteData[] = {")
for name, data in sprites_ascii.items():
    print(f"    // {name}")
    bytes_arr = []
    for row in data:
        lb = 0
        hb = 0
        for x, char in enumerate(row):
            if char == '#':
                lb |= (1 << (7 - x))
                hb |= (1 << (7 - x))
        bytes_arr.append(lb)
        bytes_arr.append(hb)
    hex_str = ", ".join([f"0x{b:02X}" for b in bytes_arr])
    print(f"    {hex_str},")
print("};")
