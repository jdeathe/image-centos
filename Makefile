NAME =			centos
VERSION =		latest
VERSION_ALIASES =	7.3.1611 7.3 7
TITLE =			CentOS 7
DESCRIPTION =		CentOS 7
SOURCE_URL =		https://github.com/scaleway/image-centos
VENDOR_URL =		https://www.centos.org/
DEFAULT_IMAGE_ARCH =	x86_64


IMAGE_VOLUME_SIZE =	50G
IMAGE_BOOTSCRIPT =	latest
IMAGE_NAME =		CentOS 7 (beta)


# This is specific to distribution images
# -- to fetch latest code, run 'make sync-image-tools'
IMAGE_TOOLS_FLAVORS =   systemd,common,docker-based
IMAGE_TOOLS_CHECKOUT =  276916c5288895ab02e753e138f3701c94141f64


## Image tools  (https://github.com/scaleway/image-tools)
all:    docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
