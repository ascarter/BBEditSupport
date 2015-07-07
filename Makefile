#
# Makefile for BBEdit scripts
#

# Default to Dropbox if BBEdit support is found there otherwise use local
PREFIX=~/Dropbox/Application\ Support/BBEdit
ifeq ($(wildcard $(PREFIX)/*),)
	PREFIX=~/Library~/Application\ Support/BBEdit
endif

SOURCES := \
	Scripts/ctags.applescript

OBJECTS := $(SOURCES:.applescript=.scpt)

%.scpt : %.applescript
	osacompile -o "$@" "$<"

.DEFAULT: all

.PHONY: all clean install uninstall

all: $(OBJECTS)

clean:
	-rm -f $(OBJECTS)

install: all
	cp Scripts/*.scpt $(PREFIX)/Scripts/.
	cp -R Clippings/* $(PREFIX)/Clippings/.
	cp Language\ Modules/*.plist $(PREFIX)/Language\ Modules/.
	cp Color\ Schemes/*.bbColorScheme $(PREFIX)/Color\ Schemes/.
	cp Preview\ CSS/*.css $(PREFIX)/Preview\ CSS/.
	cp Stationery/* $(PREFIX)/Stationery/.
	cp -R Text\ Filters/* $(PREFIX)/Text\ Filters/.

uninstall:
	-rm -f $(PREFIX)/Scripts/ctags.scpt
	-rm -f $(PREFIX)/Language\ Modules/AppleScript.plist
	-rm -f $(PREFIX)/Language\ Modules/protobuf.plist
	-rm -f $(PREFIX)/Language\ Modules/Rust.plist
