

.PHONY: docker-build docker-shell print-build-args \
	default build \
	print-docker-hub-image

SHELL=bash

default:
	echo pass

######
# docker stuff

REPO=phlummox

IMAGE_NAME=bionic-build-essential

IMAGE_VERSION=0.1.0

CTR_NAME=build-ctr

print-image-name:
	@echo $(IMAGE_NAME)

print-image-version:
	@echo $(IMAGE_VERSION)

GIT_REF=$(shell git rev-parse HEAD)
GIT_COMMIT_DATE=$(shell git show -s --format=%cI $(GIT_REF))
GIT_TAGS=$(shell git tag -l)

print-build-args:
	@printf '%s %s\n' '--build-arg GIT_REF=$(GIT_REF)' \
		'--build-arg GIT_COMMIT_DATE=$(GIT_COMMIT_DATE)' \
		'--build-arg VERSION=$(IMAGE_VERSION)'

print-docker-hub-image:
	@printf '%s' "$(REPO)/$(IMAGE_NAME)"

docker-build:
	docker build \
		-f Dockerfile $(TAGS_TO_ADD) $(TAGS_IN) \
		-t $(REPO)/$(IMAGE_NAME):$(IMAGE_VERSION) .

docker-shell:
	docker -D run -e DISPLAY -it --rm  --net=host  \
		--name $(CTR_NAME) \
		-v $$PWD:/work --workdir=/work \
		$(MOUNT) \
		$(REPO)/$(IMAGE_NAME):$(IMAGE_VERSION) bash



