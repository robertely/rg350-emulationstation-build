FROM fedora:31
MAINTAINER @robertely

RUN dnf -y install wget git bzip2 tar
RUN dnf -y group install "Development Tools"
RUN dnf -y install cmake make

# Add cross compiler toolchain http://www.gcw-zero.com/develop
# COPY opendingux-gcw0-toolchain.2014-08-20.tar.bz2 /opt/opendingux-gcw0-toolchain.2014-08-20.tar.bz2
RUN cd /opt/ && wget http://www.gcw-zero.com/files/opendingux-gcw0-toolchain.2014-08-20.tar.bz2
RUN cd /opt && tar jxvf /opt/opendingux-gcw0-toolchain.2014-08-20.tar.bz2
RUN dnf -y install glibc.i686 libstdc++.i686 libgcc.i686
ENV PATH="/opt/gcw0-toolchain/usr/bin:${PATH}"

# Some of these are noarch, perhaps i can copy pasta
# RUN dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
# RUN dnf -y install SDL2-devel freeimage-devel freetype-devel curl-devel alsa-lib-devel mesa-libGL-devel rapidjson-devel vlc-devel libvlcpp-devel

# Checkout emulationstation
RUN git clone \
    --depth=1 \
    --branch=master \
    --recursive \
    https://github.com/RetroPie/EmulationStation.git \
    /usr/local/src/EmulationStation

# What for debugging
# RUN dnf -y install vim file which tree findutils
# RUN dnf -y install 'dnf-command(download)' cpio

RUN cd /usr/local/src/EmulationStation && cmake \
    -DCMAKE_INSTALL_PREFIX=. \
    -DCMAKE_TOOLCHAIN_FILE=/opt/gcw0-toolchain/usr/share/buildroot/toolchainfile.cmake

# RUN cd /usr/local/src/EmulationStation && make
