ROOT = .

define module_install_template =
$(1)-install:
	@if test -d $$(HOME)/$(1); then \
		echo "ERROR: Module $$(HOME)/$(1) already exists, call:"; \
		echo -e "\tmake $(1)-rm\tto remove it and try again."; \
		echo -e "\tmake $(1)-reset\tto reset to the dotfiles version."; \
		exit 1; \
	else \
		mkdir -p $$(HOME)/$$(dir $(1)); \
		echo "COPY: $$(ROOT)/$(1) -> $$(HOME)/$(1)"; \
		cp -r $(ROOT)/$(1) $(HOME)/$(1); \
	fi
endef

define module_import_template =
$(1)-import:
	@if ! test -d $$(HOME)/$(1); then \
		echo "ERROR: Module $$(HOME)/$(1) does not exist"; \
		exit 1; \
	else \
		cp -r $(HOME)/$(1)/* $(ROOT)/$(1); \
	fi
endef

define module_rm_template =
$(1)-rm:
	rm -rf $$(HOME)/$(1)
endef

define module_reset_template =
$(1)-reset: $(1)-rm
	@$(MAKE) $(1)-install
endef

EXCLUDE = $(addsuffix %,$(addprefix $(ROOT)/,Makefile README.md .git))
FILES := $(filter-out $(EXCLUDE),$(shell find $(ROOT) -type f))
FILES_HOME := $(patsubst $(ROOT)/%,$(HOME)/%,$(FILES))
MODULES := $(patsubst $(ROOT)/%/,%,$(sort $(filter-out ./,$(dir $(FILES)))))
NON_MODULE_FILES := $(filter-out $(patsubst %,$(ROOT)/%/%,$(MODULES)),$(FILES))

modules:
	@echo $(MODULES) | tr ' ' '\n'

import:
	@for file in $(FILES_HOME); do \
	test -e $$file || { echo "File $$file does not exist"; exit 1; }; \
	cp -f $$file $$(echo $$file | sed "s,$(HOME),$(ROOT),g"); \
	done

install:
	@for file in $(FILES_HOME); do \
	mkdir -p $$(dirname $$file); \
	echo "COPY: $$(echo $$file | sed "s,$(HOME),$(ROOT),g") -> $$file"; \
	cp -f $$(echo $$file | sed "s,$(HOME),$(ROOT),g") $$file; \
	done

$(foreach module,$(MODULES),$(eval $(call module_install_template,$(module))))
$(foreach module,$(MODULES),$(eval $(call module_import_template,$(module))))
$(foreach module,$(MODULES),$(eval $(call module_rm_template,$(module))))
$(foreach module,$(MODULES),$(eval $(call module_reset_template,$(module))))

.PHONY: import modules install
