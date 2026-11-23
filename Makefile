# CoCo SDC repacks - top-level build
#
#   make all            init the submodules, then build every repack
#   make <game>         build one repack (e.g. make rick_dangerous)
#   make verify         verify every repack's image
#   make submodules     check out the submodules at their recorded commits
#   make update         move the submodules to their remotes' latest commits
#   make test-dmpkg     run dmpkg's own test suite
#   make clean          clean every repack
#   make help           list targets (default)
#
# Each repack under repacks/ with a Makefile is built with its own Makefile
# (make -C repacks/<game> all); variables given here (PYTHON, LWASM, LWFLAGS,
# DMPKG) pass through to it.

DMPKG   ?= $(abspath tools/dmpkg)
export DMPKG

SUBMODULE_STAMP := $(DMPKG)/Makefile
REPACKS := $(patsubst repacks/%/Makefile,%,$(wildcard repacks/*/Makefile))

.PHONY: all verify submodules update test-dmpkg clean help $(REPACKS)
.DEFAULT_GOAL := help

all: $(REPACKS)

# an uninitialized submodule is an empty directory: check it out on demand
$(SUBMODULE_STAMP):
	git submodule update --init --recursive

submodules:
	git submodule sync --recursive
	git submodule update --init --recursive

update:
	git submodule update --init --recursive --remote
	@git submodule status --recursive

$(REPACKS): $(SUBMODULE_STAMP)
	$(MAKE) -C repacks/$@ all

verify: $(SUBMODULE_STAMP)
	@set -e; for r in $(REPACKS); do $(MAKE) -C repacks/$$r verify; done

test-dmpkg: $(SUBMODULE_STAMP)
	$(MAKE) -C $(DMPKG) test

clean:
	@set -e; for r in $(REPACKS); do $(MAKE) -C repacks/$$r clean; done

help:
	@echo 'Targets:'
	@echo '  all          init the submodules, then build every repack'
	@echo '  <game>       build one repack: $(REPACKS)'
	@echo '  verify       verify every repack'"'"'s image'
	@echo '  submodules   check out the submodules at their recorded commits'
	@echo '  update       move the submodules to their remotes'"'"' latest commits'
	@echo '  test-dmpkg   run dmpkg'"'"'s test suite'
	@echo '  clean        clean every repack'
	@echo '  help         show this message (default)'
	@echo ''
	@echo 'Variables (passed through to the repack Makefiles):'
	@echo '  DMPKG  = $(DMPKG)'
