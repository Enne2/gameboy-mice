from PIL import Image, ImageDraw
import numpy as np

# 1. GENERATE MY TILES
floor_tile = [
    "00000000", "00010000", "00100000", "00000000",
    "00000000", "00000010", "00001000", "00000000",
]

def make_autotile(n, e, s, w):
    t = [list("00000000") for _ in range(8)]
    top = 0 if n else 2
    bottom = 8 if s else 6
    left = 0 if w else 2
    right = 8 if e else 6
    for r in range(top, bottom):
        for c in range(left, right): t[r][c] = "2"
    if not n:
        for c in range(left, right): t[1][c] = "1"; t[2][c] = "1"
    if not s:
        for c in range(left, right): t[6][c] = "3"; t[7][c] = "3"
    if not n and not w: t[1][2] = "0"; t[1][3] = "1"; t[2][2] = "1"
    if not n and not e: t[1][7] = "0"; t[1][6] = "1"; t[1][5] = "1"; t[2][7] = "0"; t[2][6] = "1"
    if not s and not w: t[7][2] = "0"; t[7][3] = "3"; t[6][2] = "3"
    if not s and not e: t[7][7] = "0"; t[7][6] = "3"; t[6][7] = "0"; t[6][6] = "3"
    if n and s and e and w: t[3][3] = "1"; t[4][5] = "3"
    return ["".join(row) for row in t]

my_tiles = [floor_tile]
for mask in range(16):
    n = (mask & 8) != 0; e = (mask & 4) != 0; s = (mask & 2) != 0; w = (mask & 1) != 0
    my_tiles.append(make_autotile(n, e, s, w))

# 2. EXTRACT MOCKUP TILES
img_path = '/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/test_mockup_clean.png'
img = Image.open(img_path).convert('RGB')
img = img.resize((160, 144), Image.Resampling.LANCZOS)
gray = img.convert('L')
arr = np.array(gray)
quantized = np.zeros_like(arr, dtype=np.uint8)
quantized[arr >= 192] = 0
quantized[(arr >= 128) & (arr < 192)] = 1
quantized[(arr >= 64) & (arr < 128)] = 2
quantized[arr < 64] = 3

is_wall = np.zeros((18, 20), dtype=bool)
for y in range(18):
    for x in range(20):
        tile = quantized[y*8:(y+1)*8, x*8:(x+1)*8]
        # A tile is a wall if it has enough dark pixels (> 50% non-zero)
        if np.sum(tile > 0) > 32:
            is_wall[y, x] = True

# We shouldn't count the UI frame at the bottom (y >= 16) and border
# as normal walls for extraction, or they might mess up the neighbors.
for y in range(18):
    is_wall[y, 0] = False
    is_wall[y, 19] = False
for x in range(20):
    is_wall[0, x] = False
    is_wall[16, x] = False
    is_wall[17, x] = False

mockup_extracted = {}
# find floor
for y in range(2, 15):
    for x in range(2, 18):
        if not is_wall[y, x]:
            mockup_extracted['floor'] = quantized[y*8:(y+1)*8, x*8:(x+1)*8]
            break
    if 'floor' in mockup_extracted: break

for y in range(1, 16):
    for x in range(1, 19):
        if is_wall[y, x]:
            n = is_wall[y-1, x]
            s = is_wall[y+1, x]
            e = is_wall[y, x+1]
            w = is_wall[y, x-1]
            mask = (8 if n else 0) | (4 if e else 0) | (2 if s else 0) | (1 if w else 0)
            if mask not in mockup_extracted:
                mockup_extracted[mask] = quantized[y*8:(y+1)*8, x*8:(x+1)*8]

# 3. RENDER THE COMPARISON
colors = {
    0: (224, 248, 208),
    1: (136, 192, 112),
    2: (52, 104, 86),
    3: (8, 24, 32)
}

cols = 4
rows = 5 # 17 pairs: row 0 is floor, then 16 masks
cell_w = 20 # 8 for my tile + 2 padding + 8 for mockup + 2 padding
cell_h = 10

out_img = Image.new('RGB', (cols * cell_w, rows * cell_h), (255, 255, 255))

def draw_my_tile(t_idx, x_off, y_off):
    t = my_tiles[t_idx]
    for ty in range(8):
        for tx in range(8):
            color = colors[int(t[ty][tx])]
            out_img.putpixel((x_off + tx, y_off + ty), color)

def draw_mockup_tile(m_idx, x_off, y_off):
    key = 'floor' if m_idx == 0 else (m_idx - 1)
    if key in mockup_extracted:
        t = mockup_extracted[key]
        for ty in range(8):
            for tx in range(8):
                color = colors[int(t[ty, tx])]
                out_img.putpixel((x_off + tx, y_off + ty), color)
    else:
        # draw a red cross if missing
        for ty in range(8):
            for tx in range(8):
                if ty == tx or ty == 7 - tx:
                    out_img.putpixel((x_off + tx, y_off + ty), (255, 0, 0))
                else:
                    out_img.putpixel((x_off + tx, y_off + ty), (200, 200, 200))

for idx in range(17):
    c = idx % cols
    r = idx // cols
    x_offset = c * cell_w
    y_offset = r * cell_h
    
    draw_my_tile(idx, x_offset + 1, y_offset + 1)
    draw_mockup_tile(idx, x_offset + 11, y_offset + 1)

out_img = out_img.resize((cols * cell_w * 4, rows * cell_h * 4), Image.Resampling.NEAREST)
out_img.save('/home/enne2/.gemini/antigravity/brain/69a2b2a9-088f-47ee-9f3c-9ba7ac332992/comparison_preview.png')
print("Generated comparison_preview.png")
