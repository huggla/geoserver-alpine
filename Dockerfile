ARG TAG="20190401"
ARG CATALINA_HOME="/usr/local/tomcat"
ARG BASEIMAGE="huggla/tomcat-alpine:openjdk-$TAG"
#ARG CONTENTIMAGE1="huggla/build-gdal"
#ARG CONTENTSOURCE1="/gdal"
ARG BUILDDEPS="openjdk8"
ARG GEOSERVER_VERSION="2.13.0"
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
"&& cp -a \$downloadsDir/*.jar WEB-INF/lib/ "\
"&& sed '/<display-name>/q' WEB-INF/web.xml > WEB-INF/web.xml.tmp1 "\
"&& sed -n '/<filter>/,\$p' WEB-INF/web.xml > WEB-INF/web.xml.tmp2 "\
"&& mv WEB-INF/web.xml WEB-INF/web.xml.org"
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

#--------Generic template (don't edit)--------
USER starter
ONBUILD USER root
#---------------------------------------------

ENV VAR_context1_serviceStrategy="PARTIAL-BUFFER2" \
    VAR_context2_PARTIAL_BUFFER_STRATEGY_SIZE="50" \
    VAR_context3_contextConfigLocation="classpath*:/applicationContext.xml classpath*:/applicationSecurityContext.xml" \
    VAR_context4_GEOSERVER_DATA_DIR="/geos-data"
    
#FROM huggla/build-gdal as gdal
#FROM anapsix/alpine-java:9_jdk as jdk
#FROM huggla/tomcat-oracle

#COPY --from=gdal /opt/gdal /opt/gdal
#COPY --from=gdal /usr/share/gdal.jar /usr/share/gdal.jar
#COPY --from=jdk /opt/jdk /opt/jdk-full

#ENV GEOSERVER_VERSION="2.13.0"

#RUN downloadDir="$(mktemp -d)" \
# && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip -O "$downloadDir/geoserver.zip" \
# && unzip "$downloadDir/geoserver.zip" geoserver.war -d "$CATALINA_HOME/webapps" \
# && cd "$CATALINA_HOME/webapps" \
# && mkdir geoserver \
# && cd geoserver \
# && jar xvf "$CATALINA_HOME/webapps/geoserver.war" \
# && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-ogr-wfs-plugin.zip -O "$downloadDir/geoserver-ogr-plugin.zip" \
# && unzip -o "$downloadDir/geoserver-ogr-plugin.zip" -d "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib" \
# && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-gdal-plugin.zip -O "$downloadDir/geoserver-gdal-plugin.zip" \
# && unzip -o "$downloadDir/geoserver-gdal-plugin.zip" -d "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib" \
# && rm -rf $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/imageio-ext-gdal-bindings-*.jar \

# && cp /usr/share/gdal.jar "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/gdal.jar" \
# && wget http://data.boundlessgeo.com/suite/jai/jai-1_1_3-lib-linux-amd64-jdk.bin -O "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin"
# && JAVA_HOME="/opt/jdk-full" \
# && cd "$JAVA_HOME" \
# && echo "yes" | sh "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin" \
# && wget http://data.opengeo.org/suite/jai/jai_imageio-1_1-lib-linux-amd64-jdk.bin -O "$downloadDir/jai_imageio-1_1-lib-linux-amd64-jdk.bin" \
# && echo "yes" | sh "$downloadDir/jai_imageio-1_1-lib-linux-amd64-jdk.bin" \
# && rm -rf "$downloadDir"
