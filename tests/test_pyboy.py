"""
Script per validare e testare la ROM su emulatore in modalità headless.
Questo file è utile per l'automazione dei test o come integrazione CI.
Utilizza PyBoy per eseguire 5 secondi di emulazione ed esportare uno screenshot.
"""
from pyboy import PyBoy
import sys

def main():
    try:
        # Avvia l'emulatore PyBoy disattivando la finestra nativa ("null")
        pyboy = PyBoy('maze.gb', window='null')
        
        # Effettua l'avanzamento esatto di 5 secondi (300 frame a 60 fps logici)
        for _ in range(60 * 5):
            pyboy.tick()
            
        # Salva un fotogramma esatto dell'esito della generazione su file
        pyboy.screen.image.save('/tmp/maze_gb.png')
        pyboy.stop()
        
        print("Test passed: Screenshot saved to /tmp/maze_gb.png")
    except Exception as e:
        print(f"Test failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
