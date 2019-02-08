.DEFAULT_GOAL: build

.REGISTRY	= hmcts.azurecr.io
.NAMESPACES	= hmcts/base/node

.REFS =	alpine-lts-8►8/alpine \
		alpine-lts-10►10/alpine \
		stretch-slim-lts-8►8/stretch-slim \
		stretch-slim-lts-10►10/stretch-slim

define run-docker
	docker build \
		-t $(.REGISTRY)/$(.NAMESPACES)/$(word 1,$(subst ►, ,$(1))) \
		-f $(word 2,$(subst ►, ,$(1)))/Dockerfile \
		.

endef

define run-test
	@./test-build.sh $(.REGISTRY)/$(.NAMESPACES)/$(1)

endef

build:
	$(foreach ref,$(.REFS),$(call run-docker,$(ref)))

test:
	$(foreach tag,$(.TAGS),$(call run-test,$(tag)))

.PHONY: build test
