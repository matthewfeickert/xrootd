default: centos7

centos7_base:
	docker build . \
		--file docker/centos7-base/Dockerfile \
		--build-arg BASE_IMAGE=gitlab-registry.cern.ch/linuxsupport/cc7-base:latest \
		--tag xrootd/xrootd:centos7-base

centos7:
	docker build . \
		--file docker/centos7/Dockerfile \
		--build-arg BASE_IMAGE=gitlab-registry.cern.ch/linuxsupport/cc7-base:latest \
		--tag xrootd/xrootd:centos7

centos7-rpm:
	docker build . \
		--file docker/centos7_rpm/Dockerfile \
		--build-arg BASE_IMAGE=gitlab-registry.cern.ch/linuxsupport/cc7-base:latest \
		--tag xrootd/xrootd:centos7-rpm

debian_bullseye:
	docker build . \
		--file docker/debian/Dockerfile \
		--build-arg BASE_IMAGE=debian:bullseye \
		--tag xrootd/xrootd:debian
