export FULL_VERSION_RELEASE="$$(cat ./VERSION)"
export FULL_VERSION="$$(cat ./VERSION)-regen-dh"
export TESTS_FOLDER=$$(TEMP_VAR=$${TESTS_REPORT:-$${PWD}/target/test-reports}; echo $${TEMP_VAR})

.PHONY: build build-release build-local build-dev build-test install clean test run

all: build

build:
	@echo "Making production version ${FULL_VERSION} of DockOvpn"
	docker build -t alekslitvinenk/openvpn:${FULL_VERSION} -t alekslitvinenk/openvpn:latest . --no-cache
	docker push alekslitvinenk/openvpn:${FULL_VERSION}
	docker push alekslitvinenk/openvpn:latest

build-release:
	@echo "Making manual release version ${FULL_VERSION_RELEASE} of DockOvpn"
	docker build -t alekslitvinenk/openvpn:${FULL_VERSION_RELEASE} -t ${FULL_VERSION} -t alekslitvinenk/openvpn:latest . --no-cache
	docker push alekslitvinenk/openvpn:${FULL_VERSION_RELEASE}
	docker push alekslitvinenk/openvpn:latest
	# Note: This is by design that we don't push ${FULL_VERSION} to repo

build-local:
	@echo "Making version of DockOvpn for testing on local machine"
	docker build -t alekslitvinenk/openvpn:local . --no-cache

build-dev:
	@echo "Making development version of DockOvpn"
	docker build -t alekslitvinenk/openvpn:dev . --no-cache
	docker push alekslitvinenk/openvpn:dev

build-test:
	@echo "Making testing version of DockOvpn"
	docker build -t alekslitvinenk/openvpn:test . --no-cache
	docker push alekslitvinenk/openvpn:test

install:
	@echo "Installing DockOvpn ${FULL_VERSION}"

clean:
	@echo "Remove firectory with generated reports"
	rm -rf ${TESTS_FOLDER}
	@echo "Remove shared volume with configs"
	docker volume rm Dockovpn_data

test:
	@echo "Running tests for DockOvpn ${FULL_VERSION}"
	@echo "Test reports will be saved in ${TESTS_FOLDER}"
	docker run \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${TESTS_FOLDER}:/target/test-reports \
	-v Dockovpn_data:/opt/Dockovpn_data \
	-e DOCKER_IMAGE_TAG=latest \
	-e RUNNER_CONTAINER=dockovpn-it \
	--network host \
	--name dockovpn-it \
	--rm \
	alekslitvinenk/dockovpn-it test

run:
	docker run --cap-add=NET_ADMIN \
	-v openvpn_conf:/opt/Dockovpn_data \
	-p 1194:1194/udp -p 80:8080/tcp \
	-e HOST_ADDR=localhost \
	--rm \
	alekslitvinenk/openvpn
