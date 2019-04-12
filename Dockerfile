ARG TAG="20190411"
ARG CATALINA_HOME="/usr/local/tomcat"
ARG BASEIMAGE="huggla/tomcat-alpine:openjdk-$TAG"
#ARG CONTENTIMAGE1="huggla/build-gdal"
#ARG CONTENTSOURCE1="/gdal"
ARG ADDREPOS="https://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS="openjdk8-jre libjpeg-turbo"
ARG RUNDEPS_UNTRUSTED="ttf-font-awesome"
#ARG BUILDDEPS="openjdk8"
ARG GEOSERVER_VERSION="2.15.0"
ARG MAKEDIRS="$CATALINA_HOME/webapps/geoserver"
ARG DOWNLOADS="https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip https://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-libjpeg-turbo-plugin.zip https://sourceforge.net/projects/libjpeg-turbo/files/2.0.2/libjpeg-turbo-2.0.2-jws.zip"
ARG BUILDCMDS=\
"   cd /imagefs/usr/local/lib "\
"&& CATALINA_HOME=/imagefs$CATALINA_HOME "\
"&& JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk "\
"&& wget https://demo.geo-solutions.it/share/github/imageio-ext/releases/1.1.X/1.1.28/native/gdal/linux/gdal192-Ubuntu12-gcc4.6.3-x86_64.tar.gz "\
"&& tar -xvp -f gdal192-Ubuntu12-gcc4.6.3-x86_64.tar.gz "\
"&& cp -a javainfo/imageio-ext-gdal-bindings-1.9.2.jar \$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/ "\
"&& rm -rf javainfo* "\
#"&& echo 'yes' | sh \$downloadsDir/jai-1_1_3-lib-linux-amd64-jre.bin "\
#"&& echo 'yes' | sh \$downloadsDir/jai_imageio-1_1-lib-linux-amd64-jre.bin "\
"&& cd \$CATALINA_HOME/webapps/geoserver "\
#"&& \$JAVA_HOME/bin/jar xvf \$downloadsDir/geoserver.war "\
"&& unzip -q \$downloadsDir/geoserver.war "\
"&& cp -a \$downloadsDir/ljtlinux64.jar WEB-INF/lib/ "\
"&& rm -f \$downloadsDir/ljt* "\
"&& cp -a \$downloadsDir/*.jar WEB-INF/lib/"
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
