ARG TAG="20190418"
ARG DESTDIR="/libjpegturbo"

FROM huggla/alpine as alpine

ARG LIBJPEGTURBO_VERSION="1.5.3"
ARG BUILDDEPS="build-base cmake nasm openjdk8 autoconf automake libtool"
ARG DOWNLOAD="https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-$LIBJPEGTURBO_VERSION.tar.gz"
ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk" \
    JAVAC="/usr/lib/jvm/java-1.8-openjdk/bin/javac" \
    JAR="/usr/lib/jvm/java-1.8-openjdk/bin/jar" \
    JNI_CFLAGS="-I/usr/lib/jvm/java-1.8-openjdk/include -I/usr/lib/jvm/java-1.8-openjdk/include/linux"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget "$DOWNLOAD" \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && tar -xvp -f "$downloadDir/$(basename "$DOWNLOAD")" --strip-components=1 \
 && rm -rf "$downloadDir" \
 && autoreconf -fiv \
 && JNI_CFLAGS='-I/usr/lib/jvm/java-1.8-openjdk/include -I/usr/lib/jvm/java-1.8-openjdk/include/linux' ./configure --prefix=/usr --with-java \
#&& cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DWITH_JAVA=1 -DREQUIRE_SIMD=1 -DCMAKE_POSITION_INDEPENDENT_CODE=1 \
 && make \
 && make install
 
FROM huggla/busybox:$TAG as image
 
ARG DESTDIR

COPY --from=alpine $DESTDIR $DESTDIR
