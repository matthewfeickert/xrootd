default: image

image:
	docker pull neubauergroup/centos-build-base:3.8.11
	docker build . \
		--file docker/Dockerfile \
		--build-arg BUILDER_IMAGE=neubauergroup/centos-build-base:3.8.11 \
		--tag xrootd/xrootd:debug-pr-1585

centos7:
	docker build . \
		--file docker/centos7/Dockerfile \
		--tag xrootd/xrootd:centos7

debian:
	docker build . \
		--file docker/debian/Dockerfile \
		--tag xrootd/xrootd:debian
