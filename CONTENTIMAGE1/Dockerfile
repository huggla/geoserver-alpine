ARG TAG="20190418"
ARG DESTDIR="/libjpegturbo"

FROM huggla/alpine as alpine

ARG LIBJPEGTURBO_VERSION="2.0.2"
ARG BUILDDEPS="build-base cmake nasm openjdk8 java-jna"
ARG DOWNLOAD="https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-$LIBJPEGTURBO_VERSION.tar.gz"
ARG JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget "$DOWNLOAD" \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && tar -xvp -f "$downloadDir/$(basename "$DOWNLOAD")" --strip-components=1 \
 && rm -rf "$downloadDir" \
 && cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DWITH_JAVA=1 -DREQUIRE_SIMD=1 -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
 && make tjtest
# && make install
 
#FROM huggla/busybox:$TAG as image
 
#ARG DESTDIR

#COPY --from=alpine $DESTDIR $DESTDIR
