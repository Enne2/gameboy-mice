from PIL import Image
import numpy as np

# 0: Floor (Lightest)
# 1: Light Green
# 2: Dark Green
# 3: Black
colors = {
    0: (224, 248, 208), # GB Lightest
    1: (136, 192, 112), # GB Light
    2: (52, 104, 86),   # GB Dark
    3: (8, 24, 32)      # GB Darkest
}

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
    t = [list("00000000") for _ in range(8)]
    top = 0 if n else 2
    bottom = 8 if s else 6
    left = 0 if w else 2
    right = 8 if e else 6
    for r in range(top, bottom):
        for c in range(left, right):
            t[r][c] = "2"
    if not n:
        for c in range(left, right):
            t[1][c] = "1"
            t[2][c] = "1"
    if not s:
        for c in range(left, right):
            t[6][c] = "3"
            t[7][c] = "3"
    if not n and not w:
        t[1][2] = "0"; t[1][3] = "1"; t[2][2] = "1"
    if not n and not e:
        t[1][7] = "0"; t[1][6] = "1"; t[1][5] = "1"; t[2][7] = "0"; t[2][6] = "1"
    if not s and not w:
        t[7][2] = "0"; t[7][3] = "3"; t[6][2] = "3"
    if not s and not e:
        t[7][7] = "0"; t[7][6] = "3"; t[6][7] = "0"; t[6][6] = "3"
    if n and s and e and w:
        t[3][3] = "1"; t[4][5] = "3"
    return ["".join(row) for row in t]

tiles = [floor_tile]
for mask in range(16):
    n = (mask & 8) != 0
    e = (mask & 4) != 0
    s = (mask & 2) != 0
    w = (mask & 1) != 0
    tiles.append(make_autotile(n, e, s, w))

# Render to a 17x1 grid (or 4x5)
cols = 4
rows = 5
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

# Scale up by 4x for visibility
img = img.resize((cols * 10 * 4, rows * 10 * 4), Image.Resampling.NEAREST)
img.save('/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/tileset_preview.png')
print("Generated tileset_preview.png")
