#
# Makefile for BBEdit scripts
#

# Default to Dropbox if BBEdit support is found there otherwise use local
PREFIX=~/Dropbox/Application\ Support/BBEdit
ifeq ($(wildcard $(PREFIX)/*),)
	PREFIX=~/Library~/Application\ Support/BBEdit
endif

SOURCES := \
	Scripts/ctags.applescript \
	Attachment\ Scripts/Document.applescript
OBJECTS := $(SOURCES:.applescript=.scpt)

%.scpt : %.applescript
	osacompile -o "$@" "$<"

.DEFAULT: all

.PHONY: all clean install

all: $(OBJECTS)

clean:
	-rm -f $(OBJECTS)

install:
	cp Scripts/ctags.scpt $(PREFIX)/Scripts/ctags.scpt
	cp Attachment\ Scripts/Document.scpt $(PREFIX)/Attachment\ Scripts/Document.scpt
	cp Language\ Modules/*.plist $(PREFIX)/Language\ Modules/.

uninstall:
	-rm -f $(PREFIX)/Scripts/ctags.scpt
	-rm -f $(PREFIX)/Attachment\ Scripts/Document.scpt
	-rm -f $(PREFIX)/Language\ Modules/AppleScript.plist
	-rm -f $(PREFIX)/Language\ Modules/protobuf.plist
	-rm -f $(PREFIX)/Language\ Modules/Rust.plist
