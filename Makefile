PREFIX ?= /usr/local
BIN = $(DESTDIR)$(PREFIX)/bin
CPPFLAGS = -Wall -fno-strict-aliasing -fpermissive -fwrapv
LDFLAGS += -lm
all: pifm

clean:
	rm -f pifm *.o

install: pifm
	cp pifm $(BIN)

uninstall:
	rm $(BIN)/pifm
