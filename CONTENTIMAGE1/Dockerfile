ARG TAG="20190411"
ARG DESTDIR="/libjpegturbo"

FROM huggla/alpine as alpine

ARG LIBJPEGTURBO_VERSION="2.0.2"
ARG BUILDDEPS="build-base cmake nasm openjdk8"
ARG DOWNLOAD="https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-$LIBJPEGTURBO_VERSION.tar.gz"
ARG JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"
ARG CFLAGS="-Os -fomit-frame-pointer"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget "$DOWNLOAD" \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && tar -xvp -f "$downloadDir/$(basename "$DOWNLOAD")" --strip-components=1 \
 && rm -rf "$downloadDir" \
 && cmake \
       -DCMAKE_INSTALL_PREFIX=/usr \
       -DCMAKE_INSTALL_LIBDIR=/usr/lib \
       -DBUILD_SHARED_LIBS=True \
       -DCMAKE_BUILD_TYPE=MinSizeRel \
       -DCMAKE_C_FLAGS="$CFLAGS" \
       -DWITH_JPEG8=1 \
       -DWITH_JAVA=1 \
 && make \
 && make -j1 install
 
FROM huggla/busybox:$TAG as image
 
ARG DESTDIR

COPY --from=alpine $DESTDIR $DESTDIR
