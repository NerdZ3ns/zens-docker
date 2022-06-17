#!/bin/bash

# Uncomment community [multilib] repository
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

# Update
pacman -Syyu --needed --noconfirm 2>&1 | grep -v "warning: could not get file information"

# Install Basic Packages
pacman -Sy --needed --noconfirm \
	sudo nano git curl wget rsync aria2 rclone \
	python3 python-pip zip unzip cmake graphviz \
	make neofetch speedtest-cli inetutils cpio \
	jdk8-openjdk lzip dpkg openssl ccache repo \
	libelf base-devel openssh lz4 jq go ncurses \
	bison flex ninja uboot-tools z3 glibc dpkg \
	multilib-devel bc htop python-setuptools   \
	util-linux man tmate tmux screen mlocate \
        unace unrar p7zip patchelf lld llvm imagemagick \
	sharutils uudeview arj cabextract file-roller \
	dtc brotli axel gawk detox clang gcc gcc-libs \
	flatpak zsh asp kmod pahole xmlto python-sphinx \
	python-sphinx_rtd_theme svn

# zsh
chsh -s /bin/zsh root
curl -sL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Install Some pip packages
pip install \
	twrpdtgen telegram-send backports.lzma docopt \
	extract-dtb protobuf pycrypto docopt zstandard \
	setuptools

# pip git packages
pip install \
	git+https://github.com/samloader/samloader.git

# Create a non-root user for AUR
useradd -m -G wheel -s /bin/bash testuser
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# AUR Packages
sudo -u testuser yay -S --needed --noconfirm \
	rename

# Setup the Android Build Environment
cd /tmp/scripts
sudo chmod -R a+rwx .
sudo -u testuser bash ./aosp-build-env.sh
cd -

# Fix pod2man missing error
export PATH=/usr/bin/core_perl:$PATH

# Create a symlink for z3
ln -s /usr/lib/libz3.so /usr/lib/libz3.so.4
