FROM amazonlinux:2.0.20181114

ARG version
ARG target_version

RUN yum update -y
RUN yum -y install \
  autoconf \
  automake \
  fontconfig-devel \
  fuse-devel \
  gcc-c++ \
  gettext-devel \
  gtk3-devel \
  gzip \
  libtool \
  make \
  pkgconfig \
  rpm-build \
  tar \
  which \
  xz

RUN mkdir /app
WORKDIR /app
RUN curl -LO https://github.com/flatpak/xdg-desktop-portal/archive/$target_version.tar.gz
RUN tar xzf $target_version.tar.gz

ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/pkgconfig
RUN mkdir -p /opt/albuild-xdg-desktop-portal/$version

ARG albuild_flatpak_version=0.2.0
ARG albuild_flatpak_buildno=1
RUN curl -LO https://github.com/albuild/flatpak/releases/download/v0.2.0/albuild-flatpak-$albuild_flatpak_version-$albuild_flatpak_buildno.amzn2.x86_64.rpm
RUN yum -y install albuild-flatpak-$albuild_flatpak_version-$albuild_flatpak_buildno.amzn2.x86_64.rpm
ENV PKG_CONFIG_PATH=/opt/albuild-flatpak/$albuild_flatpak_version/ostree/lib/pkgconfig:$PKG_CONFIG_PATH

ARG glib2_rpm_version=2.56.1-2
RUN curl -LO http://mirror.centos.org/centos/7/os/x86_64/Packages/glib2-$glib2_rpm_version.el7.x86_64.rpm
RUN curl -LO http://mirror.centos.org/centos/7/os/x86_64/Packages/glib2-devel-$glib2_rpm_version.el7.x86_64.rpm
RUN yum install -y glib2-$glib2_rpm_version.el7.x86_64.rpm glib2-devel-$glib2_rpm_version.el7.x86_64.rpm

WORKDIR /app/xdg-desktop-portal-$target_version
RUN env NOCONFIGURE=1 ./autogen.sh
RUN ./configure prefix=/usr --enable-static --enable-geoclue=no --enable-pipewire=no
RUN make
RUN make DESTDIR=/dest install
RUN cp -r /dest/usr/* /usr
ENV PKG_CONFIG_PATH=/opt/albuild-xdg-desktop-portal/$version/geoclue/lib/pkgconfig:$PKG_CONFIG_PATH

ARG xdg_desktop_portal_gtk_version=1.2.0
WORKDIR /app
RUN curl -LO https://github.com/flatpak/xdg-desktop-portal-gtk/releases/download/1.2.0/xdg-desktop-portal-gtk-$xdg_desktop_portal_gtk_version.tar.xz
RUN tar Jxf xdg-desktop-portal-gtk-$xdg_desktop_portal_gtk_version.tar.xz
WORKDIR /app/xdg-desktop-portal-gtk-$xdg_desktop_portal_gtk_version
RUN ./configure prefix=/usr
RUN make
RUN make DESTDIR=/dest install

RUN mkdir -p /root/rpmbuild/{SOURCES,SPECS}
WORKDIR /root/rpmbuild
ADD rpm.spec SPECS
RUN sed -i "s,{{VERSION}},$version," SPECS/rpm.spec >/dev/null
RUN sed -i "s,{{SOURCE0}},https://github.com/flatpak/xdg-desktop-portal/archive/$target_version.tar.gz," SPECS/rpm.spec >/dev/null
RUN sed -i "s,{{SOURCE1}},https://github.com/flatpak/xdg-desktop-portal-gtk/releases/download/1.2.0/xdg-desktop-portal-gtk-$xdg_desktop_portal_gtk_version.tar.xz," SPECS/rpm.spec >/dev/null
RUN find /dest -type f | sed 's,^/dest,,' >> SPECS/rpm.spec
RUN find /dest -type l | sed 's,^/dest,,' >> SPECS/rpm.spec
RUN rpmbuild -bb SPECS/rpm.spec
