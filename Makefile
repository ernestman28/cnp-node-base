.DEFAULT_GOAL: build

.REGISTRY	= hmcts.azurecr.io
.NAMESPACES	= hmcts/base/node

.CTX	= 8/alpine	10/alpine	8/stretch-slim		10/stretch-slim
.TAGS	= alpine-lts-8	alpine-lts-10	stretch-slim-lts-8	stretch-slim-lts-10

.IDXS	= $(shell for x in {1..$(words $(.TAGS))}; do echo $$x; done)
.PARAMS	= $(foreach x, $(.IDXS),$(word $(x),$(.TAGS))·$(word $(x),$(.CTX)))

define run-docker
	docker build \
		-t $(.REGISTRY)/$(.NAMESPACES)/$(word 1,$(subst ·, ,$(1))) \
		-f $(word 2,$(subst ·, ,$(1)))/Dockerfile \
		.

endef

define run-test
	@./test-build.sh $(.REGISTRY)/$(.NAMESPACES)/$(1)

endef

build:
	$(foreach param,$(.PARAMS),$(call run-docker,$(param)))

test:
	$(foreach tag,$(.TAGS),$(call run-test,$(tag)))

.PHONY: build test
