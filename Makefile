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

debian_pypi:
	docker pull debian:bullseye
	docker build . \
		--file docker/debian-pypi/Dockerfile \
		--build-arg BASE_IMAGE=debian:bullseye \
		--tag xrootd/xrootd:debian-pypi-runpath

ubuntu_pypi:
	docker pull ubuntu:20.04
	docker build . \
		--file docker/ubuntu/Dockerfile \
		--build-arg BASE_IMAGE=ubuntu:20.04 \
		--tag xrootd/xrootd:ubuntu-pypi \
		--tag xrootd/xrootd:issue-1668

centos7-pypi:
	docker pull gitlab-registry.cern.ch/linuxsupport/cc7-base:latest
	docker build . \
		--file docker/centos7-pypi/Dockerfile \
		--build-arg BASE_IMAGE=gitlab-registry.cern.ch/linuxsupport/cc7-base:latest \
		--tag xrootd/xrootd:issue-1668-centos

ubuntu_distutils:
	docker pull ubuntu:20.04
	docker build . \
		--file docker/use-distutils/Dockerfile \
		--build-arg BASE_IMAGE=ubuntu:20.04 \
		--tag xrootd/xrootd:issue-1668-setuptools-60-plus
