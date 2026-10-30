FROM debian:bookworm

ARG herdr_core_VERSION
ARG BUILD_VERSION
ARG FULL_VERSION
ARG ARCH
ARG HERDR_CORE_RELEASE

RUN mkdir -p /output/DEBIAN /output/usr/bin /output/usr/share/doc/herdr-core

# Upstream's static binary, extracted by build_debian.sh. Only herdr-core:
# no hc alias, because httpcode already ships /usr/bin/hc.
COPY ${HERDR_CORE_RELEASE}/herdr-core /output/usr/bin/herdr-core
RUN chmod 755 /output/usr/bin/herdr-core

COPY output/DEBIAN/control /output/DEBIAN/
COPY output/DEBIAN/postinst /output/DEBIAN/postinst
RUN chmod 755 /output/DEBIAN/postinst
COPY output/copyright /output/usr/share/doc/herdr-core/
COPY output/changelog.Debian /output/usr/share/doc/herdr-core/
COPY output/README.md /output/usr/share/doc/herdr-core/

RUN sed -i "s/FULL_VERSION/$FULL_VERSION/" /output/usr/share/doc/herdr-core/changelog.Debian
RUN sed -i "s/herdr_core_VERSION/$herdr_core_VERSION/" /output/DEBIAN/control
RUN sed -i "s/BUILD_VERSION/$BUILD_VERSION/" /output/DEBIAN/control
RUN sed -i "s/SUPPORTED_ARCHITECTURES/$ARCH/" /output/DEBIAN/control

RUN dpkg-deb -Zxz --build /output /herdr-core_${FULL_VERSION}.deb
