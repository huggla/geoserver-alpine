ARG TAG="20190411"
ARG CATALINA_HOME="/usr/local/tomcat"
ARG BASEIMAGE="huggla/tomcat-alpine:openjdk-$TAG"
#ARG CONTENTIMAGE1="huggla/build-gdal"
#ARG CONTENTSOURCE1="/gdal"
ARG RUNDEPS="openjdk8-jre ttf-dejavu"
ARG BUILDDEPS="openjdk8"
ARG GEOSERVER_VERSION="2.15.0"
ARG MAKEDIRS="$CATALINA_HOME/webapps/geoserver"
ARG DOWNLOADS="https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-ogr-wfs-plugin.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-gdal-plugin.zip https://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64-jre.bin https://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64-jre.bin"
ARG BUILDCMDS=\
"   cd /imagefs/usr/local "\
"&& CATALINA_HOME=/imagefs$CATALINA_HOME "\
"&& JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk "\
"&& echo 'yes' | sh \$downloadsDir/jai-1_1_3-lib-linux-amd64-jre.bin "\
"&& echo 'yes' | sh \$downloadsDir/jai_imageio-1_1-lib-linux-amd64-jre.bin "\
"&& cd \$CATALINA_HOME/webapps/geoserver "\
"&& \$JAVA_HOME/bin/jar xvf \$downloadsDir/geoserver.war "\
"&& cp -a \$downloadsDir/*.jar WEB-INF/lib/"
ARG REMOVEDIRS="$CATALINA_HOME/webapps/geoserver/data"
ARG REMOVEFILES="$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/imageio-ext-gdal-bindings-*.jar"

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
