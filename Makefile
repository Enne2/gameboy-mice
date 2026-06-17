CC = /home/enne2/.local/gbdk/bin/lcc
CFLAGS = -Wl-yt1 -Wl-ya4

hello.gb: main.c
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f *.gb *.ihx *.cdb *.adb *.noi *.map *.lst *.sym *.rel

.PHONY: clean
