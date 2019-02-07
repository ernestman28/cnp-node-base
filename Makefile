.DEFAULT_GOAL: build

.REGISTRY 	= 	hmcts.azurecr.io
.TAG_PREFIX = 	hmcts/base/node

.CTX		= 	8/alpine 		10/alpine		8/stretch-slim		10/stretch-slim
.TAGS		=	alpine-lts-8 	alpine-lts-10	stretch-slim-lts-8	stretch-slim-lts-10

.INDEXES 	= $(shell for x in {1..$(words $(.TAGS))}; do echo $$x; done)
.COMMANDS 	= $(foreach x,\
				$(.INDEXES),\
				docker·build·-t·$(.REGISTRY)/$(.TAG_PREFIX)/$(word $(x),$(.TAGS))·-f·$(word $(x),$(.CTX))/Dockerfile·.\
			)

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

define run-cmd
$(subst ·,$(SPACE),$(1))

endef

build:
	$(foreach cmd,$(.COMMANDS),$(call run-cmd,$(cmd)))

.phony: build
