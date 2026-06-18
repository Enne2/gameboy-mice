import os

tiles = {
    "floor": [
        "00000000",
        "00010000",
        "00100000",
        "00000000",
        "00000001",
        "00000010",
        "00000000",
        "00001000",
    ],
    "hedge": [
        "12121121",
        "22322322",
        "12112112",
        "23223223",
        "11212112",
        "22322322",
        "12112121",
        "23223223",
    ],
    "hedge_top": [
        "00000000",
        "01111111",
        "12121121",
        "22322322",
        "11212112",
        "23223223",
        "12112121",
        "22322322",
    ],
    "frame_tl": [
        "33333333",
        "31111111",
        "31222222",
        "31200000",
        "31200000",
        "31200000",
        "31200000",
        "31200000",
    ],
    "frame_tr": [
        "33333333",
        "11111113",
        "22222213",
        "00000213",
        "00000213",
        "00000213",
        "00000213",
        "00000213",
    ],
    "frame_bl": [
        "31200000",
        "31200000",
        "31200000",
        "31200000",
        "31200000",
        "31222222",
        "31111111",
        "33333333",
    ],
    "frame_br": [
        "00000213",
        "00000213",
        "00000213",
        "00000213",
        "00000213",
        "22222213",
        "11111113",
        "33333333",
    ],
    "frame_t": [
        "33333333",
        "11111111",
        "22222222",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
    ],
    "frame_b": [
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "22222222",
        "11111111",
        "33333333",
    ],
    "frame_l": [
        "31200000",
        "31200000",
        "31200000",
        "31200000",
        "31200000",
        "31200000",
        "31200000",
        "31200000",
    ],
    "frame_r": [
        "00000213",
        "00000213",
        "00000213",
        "00000213",
        "00000213",
        "00000213",
        "00000213",
        "00000213",
    ],
}

def to_gb_format(lines):
    bytes_arr = []
    for line in lines:
        lo = 0
        hi = 0
        for i, char in enumerate(line):
            val = int(char)
            if val & 1:
                lo |= (1 << (7 - i))
            if val & 2:
                hi |= (1 << (7 - i))
        bytes_arr.append(lo)
        bytes_arr.append(hi)
    return bytes_arr

with open("src/mockup_gfx.c", "w") as f:
    f.write('#include "mockup_gfx.h"\n\n')
    f.write('const unsigned char MockupTileData[] = {\n')
    
    for name, art in tiles.items():
        b = to_gb_format(art)
        f.write('    // ' + name + '\n')
        f.write('    ' + ', '.join(f"0x{val:02X}" for val in b) + ',\n')
        
    f.write('};\n')

with open("src/mockup_gfx.h", "w") as f:
    f.write('#ifndef MOCKUP_GFX_H\n#define MOCKUP_GFX_H\n\n')
    f.write('extern const unsigned char MockupTileData[];\n')
    f.write('#endif\n')

print("Generato mockup_gfx.c e .h")
