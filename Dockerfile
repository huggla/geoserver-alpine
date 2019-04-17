ARG TAG="20190411"
ARG LIBJPEGTURBO_VERSION="2.0.2"
ARG CONTENTIMAGE1="huggla/libjpegturbo:$LIBJPEGTURBO_VERSION"
ARG CONTENTSOURCE1="/libjpegturbo/usr/lib/libturbojpeg.so.0.2.0"
ARG CONTENTDESTINATION1="/imagefs/usr/local/lib/amd64/libturbojpeg.so"
ARG CATALINA_HOME="/usr/local/tomcat"
ARG BASEIMAGE="huggla/tomcat-alpine:openjdk-$TAG"
ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS="freetype"
ARG RUNDEPS_UNTRUSTED="ttf-font-awesome"
ARG BUILDDEPS="openjdk8"
ARG GEOSERVER_VERSION="2.15.0"
ARG MAKEDIRS="$CATALINA_HOME/webapps/geoserver"
ARG DOWNLOADS="https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-libjpeg-turbo-plugin.zip https://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz https://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz"
ARG BUILDCMDS=\
"   cd /imagefs$CATALINA_HOME/webapps/geoserver "\
"&& /usr/lib/jvm/java-1.8-openjdk/bin/jar xvf \$downloadsDir/geoserver.war "\
"&& cp -a \$downloadsDir/*.jar \$downloadsDir/jai-1_1_3/lib/*.jar \$downloadsDir/jai_imageio-1_1/lib/*.jar WEB-INF/lib/ "\
"&& cd /imagefs/usr/local/lib/amd64 "\
"&& cp -a \$downloadsDir/jai-1_1_3/lib/*.so \$downloadsDir/jai_imageio-1_1/lib/*.so /usr/lib/jvm/java-1.8-openjdk/jre/lib/amd64/libfontmanager.so ./ "\
"&& cd /imagefs "\
"&& (find * ! -type d ! -type c -type l ! -path 'var/cache/*' ! -path 'tmp/*' -prune -exec echo -n \"/{}>\" \\; -exec readlink \"{}\" \\; && find * ! -type d ! -type c ! -type l ! -path 'var/cache/*' ! -path 'tmp/*' -prune -exec md5sum \"{}\" \\; | awk '{first=\$1; \$1=\"\"; print \$0\">\"first}' | sed 's|^ |/|') | sort -u -o /tmp/onbuild/exclude.filelist.new -"

#"&& ln -s ../../../lib/libturbojpeg.so.0.2.0 libturbojpeg.so"
ARG REMOVEDIRS="$CATALINA_HOME/webapps/geoserver/data"

#--------Generic template (don't edit)--------
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$TAG}} as init
FROM ${BUILDIMAGE:-huggla/build} as build
FROM ${BASEIMAGE:-huggla/base:$TAG} as image
ARG CONTENTSOURCE1
ARG CONTENTSOURCE1="${CONTENTSOURCE1:-/}"
ARG CONTENTDESTINATION1
ARG CONTENTDESTINATION1="${CONTENTDESTINATION1:-/buildfs/}"
ARG CONTENTSOURCE2
ARG CONTENTSOURCE2="${CONTENTSOURCE2:-/}"
ARG CONTENTDESTINATION2
ARG CONTENTDESTINATION2="${CONTENTDESTINATION2:-/buildfs/}"
ARG CONTENTSOURCE3
ARG CONTENTSOURCE3="${CONTENTSOURCE3:-/}"
ARG CONTENTDESTINATION3
ARG CONTENTDESTINATION3="${CONTENTDESTINATION3:-/buildfs/}"
ARG CLONEGITSDIR
ARG DOWNLOADSDIR
ARG MAKEDIRS
ARG MAKEFILES
ARG EXECUTABLES
ARG STARTUPEXECUTABLES
ARG EXPOSEFUNCTIONS
ARG GID0WRITABLES
ARG GID0WRITABLESRECURSIVE
ARG LINUXUSEROWNED
ARG LINUXUSEROWNEDRECURSIVE
COPY --from=build /imagefs /
#---------------------------------------------

ENV VAR_DATA_DIR="/geos-data" \
    VAR_WITH_MANAGERS="false" \
    VAR_ROOT_APP="geoserver"

#--------Generic template (don't edit)--------
USER starter
ONBUILD USER root
#---------------------------------------------
