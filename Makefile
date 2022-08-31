export FULL_VERSION_RELEASE="$$(cat ./VERSION)"
export FULL_VERSION="$$(cat ./VERSION)-regen-dh"
export TESTS_FOLDER=$$(TEMP_VAR=$${TESTS_REPORT:-$${PWD}/target/test-reports}; echo $${TEMP_VAR})
export DOCKER_REPO="alekslitvinenk/openvpn"
export CBRANCH=$$(git rev-parse --abbrev-ref HEAD | tr / -)

.PHONY: build build-release build-local build-dev build-test build-branch install clean test test-branch run

all: build

build:
	@echo "Making production version ${FULL_VERSION} of DockOvpn"
	docker build -t "${DOCKER_REPO}:${FULL_VERSION}" -t "${DOCKER_REPO}:latest" . --no-cache
	docker push "${DOCKER_REPO}:${FULL_VERSION}"
	docker push "${DOCKER_REPO}:latest"

build-release:
	@echo "Making manual release version ${FULL_VERSION_RELEASE} of DockOvpn"
	docker build -t "${DOCKER_REPO}:${FULL_VERSION_RELEASE}" -t ${FULL_VERSION} -t alekslitvinenk/openvpn:latest . --no-cache
	docker push "${DOCKER_REPO}:${FULL_VERSION_RELEASE}"
	docker push "${DOCKER_REPO}:latest"
	# Note: This is by design that we don't push ${FULL_VERSION} to repo

build-local:
	@echo "Making version of DockOvpn for testing on local machine"
	docker build -t "${DOCKER_REPO}:local" . --no-cache

build-dev:
	@echo "Making development version of DockOvpn"
	docker build -t "${DOCKER_REPO}:dev" . --no-cache
	docker push "${DOCKER_REPO}:dev"

build-test:
	@echo "Making testing version of DockOvpn"
	docker build -t "${DOCKER_REPO}:test" . --no-cache
	docker push "${DOCKER_REPO}:test"

build-branch:
	@echo "Making build for branch: ${DOCKER_REPO}:${CBRANCH}"
	docker build -t "${DOCKER_REPO}:${CBRANCH}" --no-cache --progress plain .
	docker push "${DOCKER_REPO}:${CBRANCH}"

install:
	@echo "Installing DockOvpn ${FULL_VERSION}"

clean:
	@echo "Remove directory with generated reports"
	rm -rf ${TESTS_FOLDER}
	@echo "Remove shared volume with configs"
	docker volume rm Dockovpn_data

# https://github.com/dockovpn/dockovpn-it
test:
	@echo "Running tests for DockOvpn ${FULL_VERSION}"
	@echo "Test reports will be saved in ${TESTS_FOLDER}"
	docker pull alekslitvinenk/dockovpn-it:1.0.0
	docker run \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${TESTS_FOLDER}:/target/test-reports \
	-v Dockovpn_data:/opt/Dockovpn_data \
	-e DOCKER_IMAGE_TAG=latest \
	-e RUNNER_CONTAINER=dockovpn-it \
	--network host \
	--name dockovpn-it \
	--rm \
	alekslitvinenk/dockovpn-it:1.0.0 test

# https://github.com/dockovpn/dockovpn-it
# For testing locally on macOS or Windows (where DockerDesktop is running)
test-branch:
	@echo "Running tests for DockOvpn ${CBRANCH}"
	@echo "Test reports will be saved in ${TESTS_FOLDER}"
	docker pull alekslitvinenk/dockovpn-it:1.0.0
	docker run \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${TESTS_FOLDER}:/target/test-reports \
	-v Dockovpn_data:/opt/Dockovpn_data \
	-e DOCKER_IMAGE_TAG=${CBRANCH} \
	-e RUNNER_CONTAINER=dockovpn-it \
	-e LOCAL_HOST="0.0.0.0" \
	--network host \
	--name dockovpn-it \
	--rm \
	alekslitvinenk/dockovpn-it:1.0.0 test

run:
	docker run --cap-add=NET_ADMIN \
	-v openvpn_conf:/opt/Dockovpn_data \
	-p 1194:1194/udp -p 80:8080/tcp \
	-e HOST_ADDR=localhost \
	--rm \
	${DOCKER_REPO}
