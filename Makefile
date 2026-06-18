CC = /home/enne2/.local/gbdk/bin/lcc
CFLAGS = -Wl-yt1 -Wl-ya4 -Isrc

SRC_DIR = src
OBJ_DIR = obj

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(OBJ_DIR)/bomb.o $(OBJ_DIR)/bomb_gfx.o $(OBJ_DIR)/cursor.o $(OBJ_DIR)/main.o $(OBJ_DIR)/maze.o $(OBJ_DIR)/mockup_gfx.o $(OBJ_DIR)/music.o $(OBJ_DIR)/numbers_gfx.o $(OBJ_DIR)/pause_gfx.o $(OBJ_DIR)/rat_bg.o $(OBJ_DIR)/rat.o $(OBJ_DIR)/tiles.o $(OBJ_DIR)/title_bg.o $(OBJ_DIR)/victory_bg.o

TARGET = maze.gb
AUDIO_TARGET = test_audio.gb
MOCKUP_TARGET = test_mockup.gb

all: $(TARGET) $(AUDIO_TARGET) $(MOCKUP_TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

$(AUDIO_TARGET): test_audio.c $(OBJ_DIR)/music.o
	$(CC) $(CFLAGS) -o $(AUDIO_TARGET) test_audio.c $(OBJ_DIR)/music.o

$(MOCKUP_TARGET): test_mockup.c src/mockup_gfx.c
	$(CC) $(CFLAGS) -o $(MOCKUP_TARGET) test_mockup.c src/mockup_gfx.c

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR) *.gb
