
FENNEL ?= $(HOME)/sources/fennel-1.6.1-x86_64

COLSRC := $(wildcard fnl/colors/*.fnl)
COLOUT := $(patsubst fnl/colors/%.fnl,colors/%.lua,$(COLSRC))

all: init.lua $(COLOUT) 

init.lua: fnl/init.fnl
	$(FENNEL) --compile $< > $@

colors/%.lua: fnl/colors/%.fnl
	mkdir -p colors/
	$(FENNEL) --compile $< > $@

