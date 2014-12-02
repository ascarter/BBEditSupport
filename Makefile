#
# Makefile for BBEdit scripts
#

# Default to Dropbox if BBEdit support is found there otherwise use local
PREFIX=~/Dropbox/Application\ Support/BBEdit
ifeq ($(wildcard $(PREFIX)/*),)
	PREFIX=~/Library~/Application\ Support/BBEdit
endif

SOURCES := \
	Scripts/Project_Root.applescript \
	Scripts/Ctags/Create.applescript \
	Scripts/Ctags/Update.applescript \
	Attachment\ Scripts/Document.applescript

OBJECTS := $(SOURCES:.applescript=.scpt)

%.scpt : %.applescript
	osacompile -o "$@" "$<"

.DEFAULT: all

.PHONY: all clean install

all: $(OBJECTS)

clean:
	-rm -f $(OBJECTS)

install: all
	cp Scripts/Project_Root.scpt $(PREFIX)/Scripts/Project\ Root.scpt
	mkdir -p $(PREFIX)/Scripts/Ctags
	cp Scripts/Ctags/Create.scpt $(PREFIX)/Scripts/Ctags/Create.scpt
	cp Scripts/Ctags/Update.scpt $(PREFIX)/Scripts/Ctags/Update.scpt
	cp Attachment\ Scripts/Document.scpt $(PREFIX)/Attachment\ Scripts/Document.scpt
	cp Language\ Modules/*.plist $(PREFIX)/Language\ Modules/.
	cp Color\ Schemes/*.bbColorScheme $(PREFIX)/Color\ Schemes/.
	cp Preview\ CSS/*.css $(PREFIX)/Preview\ CSS/.
	cp Stationery/* $(PREFIX)/Stationery/.
	cp Text\ Filters/* $(PREFIX)/Text\ Filters/.

uninstall:
	-rm -f $(PREFIX)/Scripts/Project\ Root.scpt
	-rm -f $(PREFIX)/Scripts/Ctags/Create.scpt
	-rm -f $(PREFIX)/Scripts/Ctags/Update.scpt
	-rm -f $(PREFIX)/Attachment\ Scripts/Document.scpt
	-rm -f $(PREFIX)/Language\ Modules/AppleScript.plist
	-rm -f $(PREFIX)/Language\ Modules/protobuf.plist
	-rm -f $(PREFIX)/Language\ Modules/Rust.plist
