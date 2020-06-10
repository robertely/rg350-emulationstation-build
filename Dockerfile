FROM fedora:31
MAINTAINER @robertely

RUN dnf -y install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN dnf -y install SDL2-devel freeimage-devel freetype-devel curl-devel alsa-lib-devel mesa-libGL-devel rapidjson-devel vlc-devel libvlcpp-devel
RUN dnf -y install wget git bzip2 tar make
RUN dnf -y group install "Development Tools"

# Add cross compiler toolchain http://www.gcw-zero.com/develop
RUN dnf -y install glibc.i686 libstdc++.i686 libgcc.i686
# COPY opendingux-gcw0-toolchain.2014-08-20.tar.bz2 /opt/opendingux-gcw0-toolchain.2014-08-20.tar.bz2
RUN cd /opt/ && wget http://www.gcw-zero.com/files/opendingux-gcw0-toolchain.2014-08-20.tar.bz2
RUN cd /opt && tar jxvf /opt/opendingux-gcw0-toolchain.2014-08-20.tar.bz2
ENV PATH="/opt/gcw0-toolchain/usr/bin:${PATH}"

RUN git clone \
    --depth=1 \
    --branch=master \
    --recursive \
    https://github.com/RetroPie/EmulationStation.git \
    /usr/local/src/EmulationStation

# /usr/include/vlc

RUN cd /usr/local/src/EmulationStation && \
    cmake -DCMAKE_INSTALL_PREFIX=. && \
    make

# RUN mkdir -p /usr/local/src/es/usr/bin \
#              /usr/local/src/es/usr/share/doc/emulationstation \
#              /usr/local/src/es/etc/emulationstation
# RUN cp /usr/local/src/EmulationStation/emulationstation /usr/local/src/es/usr/bin
# ADD files/DEBIAN /usr/local/src/es/DEBIAN
# ADD files/themes /usr/local/src/es/etc/emulationstation/themes
# ADD files/copyright /usr/local/src/es/usr/share/doc/emulationstation/copyright

# RUN find /usr/local/src/es -type d -perm -2000 -exec chmod g-s {} \;
# RUN cd  /usr/local/src/es && \
#     find usr/ -type f -exec md5sum {} \; > DEBIAN/md5sums && \
#     dpkg -b . /usr/local/src/emulationstation_2.0.1a-1_amd64.deb
