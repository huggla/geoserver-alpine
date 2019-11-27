# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="1.1-edge"
ARG TAG="20191112"
ARG IMAGETYPE="application"
ARG GEOSERVER_VERSION="2.16.0"
ARG TOMCAT_VERSION="9.0.20"
ARG CATALINA_HOME="/usr/local/tomcat"
ARG BASEIMAGE="huggla/tomcat-alpine:$TOMCAT_VERSION-$TAG"
ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS="freetype ttf-font-awesome"
ARG BUILDDEPS="openjdk8"
ARG DESTDIR="/webapps-nobind/geoserver"
ARG DOWNLOADS="https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-libjpeg-turbo-plugin.zip https://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz https://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz"
ARG BUILDCMDS=\
'   cd $DESTDIR '\
'&& /usr/lib/jvm/java-1.8-openjdk/bin/jar xf $DOWNLOADSDIR/geoserver.war '\
'&& cp -a $DOWNLOADSDIR/*.jar $DOWNLOADSDIR/jai-1_1_3/lib/*.jar $DOWNLOADSDIR/jai_imageio-1_1/lib/*.jar WEB-INF/lib/ '\
'&& cd data '\
'&& rm -rf coverages/* data/* demo gwc gwc-layers layergroups/* www/* workspaces/* README.rst '\
'&& tar -cvpf /finalfs/geos-data.tar.gz * '\
'&& cd .. '\
'&& rm -r data '\
'&& cp -a $DOWNLOADSDIR/jai-1_1_3/lib/*.so $DOWNLOADSDIR/jai_imageio-1_1/lib/*.so /usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/libfontmanager.so /finalfs/usr/local/lib/amd64/'
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/sam_$SaM_VERSION:base-$TAG}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/sam_$SaM_VERSION:build-$TAG} as build
FROM ${BASEIMAGE:-huggla/sam_$SaM_VERSION:base-$TAG} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
ENV VAR_DATA_DIR="/geos-data" \
    VAR_ADD_MODULES_DIR="/geos-modules" \
    VAR_WITH_MANAGERS="false" \
    VAR_ROOT_APP="geoserver"
    
# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
