# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG TAG="20190917"
ARG IMAGETYPE="application"
ARG GEOSERVER_VERSION="2.15.2"
ARG CATALINA_HOME="/usr/local/tomcat"
ARG BASEIMAGE="huggla/tomcat-alpine:$TAG"
ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS="freetype ttf-font-awesome"
ARG BUILDDEPS="openjdk8"
ARG MAKEDIRS="$CATALINA_HOME/webapps/geoserver"
ARG DOWNLOADS="https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-libjpeg-turbo-plugin.zip https://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz https://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz"
ARG DESTDIR="/geoserver"
ARG BUILDCMDS=\
'   cd $DESTDIR '\
'&& /usr/lib/jvm/java-1.8-openjdk/bin/jar xvf $DOWNLOADSDIR/geoserver.war '\
'&& cp -a $DOWNLOADSDIR/*.jar $DOWNLOADSDIR/jai-1_1_3/lib/*.jar $DOWNLOADSDIR/jai_imageio-1_1/lib/*.jar WEB-INF/lib/ '\
'&& cd data '\
'&& tar -cvpf /finalfs/geos-data.tar.gz * '\
'&& cd .. '\
'&& rm -r data '\
'&& tar -cvpf /finalfs/geoserver.tar.gz * '\
'&& cp -a $DOWNLOADSDIR/jai-1_1_3/lib/*.so $DOWNLOADSDIR/jai_imageio-1_1/lib/*.so /usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/libfontmanager.so /finalfs/usr/local/lib/amd64/'
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/build:$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
ENV VAR_DATA_DIR="/geos-data" \
    VAR_MODULES_DIR="/geos-modules" \
    VAR_WITH_MANAGERS="false" \
    VAR_ROOT_APP="geoserver"
    
# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
