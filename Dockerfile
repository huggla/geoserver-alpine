FROM huggla/tomcat-alpine

USER root

ENV GEOSERVER_VERSION="2.8.5" \
    GDAL_VERSION="1.11.4" \
    ANT_VERSION="1.9.7" \
#    LD_LIBRARY_PATH="/usr/local/lib/" \
    _POSIX2_VERSION="199209"

RUN apk add --no-cache --virtual .build-deps g++ make swig openjdk$JAVA_MAJOR \
 && apk add --no-cache libstdc++ \
 && downloadDir="$(mktemp -d)" \
 && buildDir="$(mktemp -d)" \
 && wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz -O "$downloadDir/gdal.tar.gz" \
 && tar xzf "$downloadDir/gdal.tar.gz" -C "$buildDir" \
 && cd "$buildDir/gdal-${GDAL_VERSION}" \
 && ./configure  --with-java=$JAVA_HOME \
 && make \
 && make install \
 && wget http://mirrors.ae-online.de/apache/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz -O "$downloadDir/ant.tar.gz" \
 && tar xzf "$downloadDir/ant.tar.gz" -C "$downloadDir" \
 && mv "$downloadDir/apache-ant-${ANT_VERSION}/bin/ant" /usr/local/bin/ant \
 && cd "$buildDir/gdal-${GDAL_VERSION}/swig/java" \
 && sed -i '/JAVA_HOME =/d' java.opt \
 && make \
 && make install \
 && mv *.so /usr/local/lib/ \
 && mv "$buildDir/gdal-${GDAL_VERSION}/swig/java/gdal.jar" /usr/share/gdal.jar \
 && apk del .build-deps \
 && rm -rf "$buildDir" \
 && wget http://data.boundlessgeo.com/suite/jai/jai-1_1_3-lib-linux-amd64-jdk.bin -O "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin" \
 && cd "$JAVA_HOME" \
 && echo "yes" | sh "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin" \
 && wget http://data.opengeo.org/suite/jai/jai_imageio-1_1-lib-linux-amd64-jdk.bin -O "$downloadDir/jai_imageio-1_1-lib-linux-amd64-jdk.bin" \
 && echo "yes" | sh "$downloadDir/jai_imageio-1_1-lib-linux-amd64-jdk.bin" \
 && wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip -O "$downloadDir/geoserver.zip" \
 && unzip "$downloadDir/geoserver.zip" geoserver.war -d /usr/local/tomcat/webapps \
 && catalina.sh configtest \
 && wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-ogr-wfs-plugin.zip -O "$downloadDir/geoserver-ogr-plugin.zip" \
 && unzip -o "$downloadDir/geoserver-ogr-plugin.zip" -d /opt/geoserver/webapps/geoserver/WEB-INF/lib \
 && wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-gdal-plugin.zip -O "$downloadDir/geoserver-gdal-plugin.zip" \
 && unzip -o "$downloadDir/geoserver-gdal-plugin.zip" -d /opt/geoserver/webapps/geoserver/WEB-INF/lib \
 && rm -rf /usr/local/tomcat/webapps/geoserver/WEB-INF/lib/imageio-ext-gdal-bindings-1.9.2.jar \
 && cp /usr/share/gdal.jar /usr/local/tomcat/webapps/geoserver/WEB-INF/lib/gdal.jar \
 && rm -rf "$downloadDir"

USER sudoer
