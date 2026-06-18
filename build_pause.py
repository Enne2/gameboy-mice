letters = {
    'P': [
        "00000000",
        "01111100",
        "01000100",
        "01111100",
        "01000000",
        "01000000",
        "01000000",
        "00000000"
    ],
    'A': [
        "00000000",
        "00111000",
        "01000100",
        "01000100",
        "01111100",
        "01000100",
        "01000100",
        "00000000"
    ],
    'U': [
        "00000000",
        "01000100",
        "01000100",
        "01000100",
        "01000100",
        "01000100",
        "00111000",
        "00000000"
    ],
    'S': [
        "00000000",
        "00111100",
        "01000000",
        "00111000",
        "00000100",
        "01000100",
        "00111000",
        "00000000"
    ],
    'E': [
        "00000000",
        "01111100",
        "01000000",
        "01111000",
        "01000000",
        "01000000",
        "01111100",
        "00000000"
    ]
}

def to_gb(tile):
    b = []
    for r in tile:
        lo = hi = 0
        for i, c in enumerate(r):
            # 3 for text (black), 1 for background (white using OBP1)
            val = 3 if c == '1' else 1
            if val & 1: lo |= (1 << (7 - i))
            if val & 2: hi |= (1 << (7 - i))
        b.append(lo)
        b.append(hi)
    return b

with open('src/pause_gfx.c', 'w') as f:
    f.write('#include "pause_gfx.h"\n\n')
    f.write('const unsigned char PauseTiles[] = {\n')
    for k in ['P', 'A', 'U', 'S', 'E']:
        b = to_gb(letters[k])
        f.write('    ' + ','.join(f'0x{x:02X}' for x in b) + ',\n')
    f.write('};\n\n')

with open('src/pause_gfx.h', 'w') as f:
    f.write('#ifndef PAUSE_GFX_H\n#define PAUSE_GFX_H\n\n')
    f.write('extern const unsigned char PauseTiles[];\n\n')
    f.write('#endif\n')

print("Generated pause_gfx files with solid white backgrounds.")
