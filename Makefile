PREFIX ?= /usr/local
BIN = $(DESTDIR)$(PREFIX)/bin
CPPFLAGS = -Wall -fno-strict-aliasing -fpermissive -fwrapv
LDFLAGS += -lm
all: pifm

clean:
	rm -f pifm *.o

install: pifm
	cp pifm $(BIN)
	cp pifmplay $(BIN)

uninstall:
	rm $(BIN)/pifm $(BIN)/pifmplay

deps:
	apt-get install ffmpeg sox libsox-fmt-all
