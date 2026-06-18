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
    ],
    'BLANK': [
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "00000000"
    ],
    'BORDER_H': [
        "00000000",
        "01111111",
        "00000000",
        "00000000",
        "00000000",
        "00000000",
        "01111111",
        "00000000"
    ]
}

def to_gb(tile):
    b = []
    for r in tile:
        lo = hi = 0
        for i, c in enumerate(r):
            if c == '1':
                hi |= (1 << (7 - i))
                lo |= (1 << (7 - i)) # 3 = white/black depending on palette. Wait, 3 is black. 0 is white.
                # Let's make text black on a white dialog!
                # If background is white (0), text is black (3).
                # So if '1', lo=1, hi=1.
        b.append(lo)
        b.append(hi)
    return b

with open('src/pause_gfx.c', 'w') as f:
    f.write('#include "pause_gfx.h"\n\n')
    f.write('const unsigned char PauseTiles[] = {\n')
    for k in ['P', 'A', 'U', 'S', 'E', 'BLANK', 'BORDER_H']:
        b = to_gb(letters[k])
        f.write('    ' + ','.join(f'0x{x:02X}' for x in b) + ',\n')
    f.write('};\n\n')
    
    # Dialog map: 7x3
    # Borders and blank background
    # Indices: 22=P, 23=A, 24=U, 25=S, 26=E, 27=BLANK, 28=BORDER_H
    
    # Row 0: all BORDER_H
    # Row 1: BLANK, P, A, U, S, E, BLANK
    # Row 2: all BORDER_H
    map_data = [
        28, 28, 28, 28, 28, 28, 28,
        27, 22, 23, 24, 25, 26, 27,
        28, 28, 28, 28, 28, 28, 28
    ]
    f.write('const unsigned char PauseMap[] = {\n    ')
    f.write(','.join(str(x) for x in map_data))
    f.write('\n};\n')

with open('src/pause_gfx.h', 'w') as f:
    f.write('#ifndef PAUSE_GFX_H\n#define PAUSE_GFX_H\n\n')
    f.write('extern const unsigned char PauseTiles[];\n')
    f.write('extern const unsigned char PauseMap[];\n\n')
    f.write('#endif\n')

print("Generated pause_gfx files")
