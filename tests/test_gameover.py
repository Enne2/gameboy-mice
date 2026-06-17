import sys
from pyboy import PyBoy
import cv2
import numpy as np

def main():
    pyboy = PyBoy('maze.gb', window='null')
    # Run for 400 frames to let the game over screen render and boot sequence finish
    for _ in range(400):
        pyboy.tick()
    
    # Save screenshot
    img_path = '/tmp/gameover_test.png'
    pyboy.screen.image.save(img_path)
    
    # Draw grid with OpenCV
    img = cv2.imread(img_path)
    for x in range(0, 160, 8):
        cv2.line(img, (x, 0), (x, 144), (0, 255, 0), 1)
    for y in range(0, 144, 8):
        cv2.line(img, (0, y), (160, y), (0, 255, 0), 1)
    cv2.imwrite('/tmp/gameover_grid.png', img)
    print("Saved grid image to /tmp/gameover_grid.png")

    print("Screen tilemap:")
    for y in range(18):
        line = ""
        for x in range(20):
            tile_id = pyboy.memory[0x9800 + y * 32 + x]
            # Default font mapping: Space is 0x20. ASCII maps directly!
            if 0x20 <= tile_id <= 0x7E:
                line += chr(tile_id)
            else:
                line += "."
        print(f"{y:02d}: '{line}'")

    pyboy.stop()

if __name__ == '__main__':
    main()
