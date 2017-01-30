## -*- docker-image-name: "scaleway/centos:latest" -*-
FROM centos:7.3.1611

RUN (cd /lib/systemd/system/sysinit.target.wants/; \
		for i in *; \
			do [[ $i == systemd-tmpfiles-setup.service ]] || rm -f $i; \
		done; \
	); \
	rm -f /lib/systemd/system/multi-user.target.wants/*; \
	rm -f /etc/systemd/system/*.wants/*; \
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*; \
	rm -f /lib/systemd/system/anaconda.target.wants/*;

# Environment
ENV SCW_BASE_IMAGE="scaleway/centos:latest" \
	ARCH="x86_64"

# Adding and calling builder-enter
COPY ./overlay-${ARCH}/etc/yum.repos.d/ \
	/etc/yum.repos.d/
COPY ./overlay-image-tools/usr/local/sbin/scw-builder-enter \
	/usr/local/sbin/

RUN yum install -y \
		redhat-lsb-core \
		ntp \
		ntpdate \
		ssh \
		sudo \
	&& /usr/local/sbin/scw-builder-enter \
	&& yum clean all

# Patch rootfs
COPY ./overlay-image-tools \
	./overlay \
	./overlay-${ARCH} \
	/

# Enable Scaleway services.
# + Hotfix reboot (? disables network).
# + Clean rootfs from image-builder.
RUN systemctl enable \
		scw-generate-ssh-keys \
		scw-fetch-ssh-keys \
		scw-gen-machine-id \
		scw-kernel-check \
		scw-sync-kernel-modules \
	&& systemctl mask \
		network \
	&& /usr/local/sbin/scw-builder-leave

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/sbin/init"]
