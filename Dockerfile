FROM huggla/tomcat-alpine

ENV GEOSERVER_VERSION="2.8.5" \
    GDAL_VERSION="1.11.4" \
    ANT_VERSION="1.9.7" \
#    LD_LIBRARY_PATH="/usr/local/lib/" \
    GEOSERVER_HOME="/opt/geoserver" \
    _POSIX2_VERSION="199209"

RUN apk add --no-cache --virtual .build-deps g++ libstdc++ make swig \
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
 && wget http://data.boundlessgeo.com/suite/jai/jai-1_1_3-lib-linux-amd64-jdk.bin "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin" \
 && cd "$JAVA_HOME" \
 && echo "yes" | sh "$downloadDir/jai-1_1_3-lib-linux-amd64-jdk.bin" \
 && wget http://data.opengeo.org/suite/jai/jai_imageio-1_1-lib-linux-amd64-jdk.bin && \
    echo "yes" | sh jai_imageio-1_1-lib-linux-amd64-jdk.bin && \
    rm jai_imageio-1_1-lib-linux-amd64-jdk.bin

# Get GeoServer
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-bin.zip -O ~/geoserver.zip && \
    unzip ~/geoserver.zip -d /opt && mv -v /opt/geoserver* /opt/geoserver && \
    rm ~/geoserver.zip

# Get OGR plugin
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-ogr-wfs-plugin.zip -O ~/geoserver-ogr-plugin.zip &&\
    unzip -o ~/geoserver-ogr-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib/ && \
    rm ~/geoserver-ogr-plugin.zip

# Get GDAL plugin
RUN wget -c http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-gdal-plugin.zip -O ~/geoserver-gdal-plugin.zip &&\
    unzip -o ~/geoserver-gdal-plugin.zip -d /opt/geoserver/webapps/geoserver/WEB-INF/lib/ && \
    rm ~/geoserver-gdal-plugin.zip

# Replace GDAL Java bindings
RUN rm -rf $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/imageio-ext-gdal-bindings-1.9.2.jar
RUN cp /usr/share/gdal.jar $GEOSERVER_HOME/webapps/geoserver/WEB-INF/lib/gdal.jar

# Expose GeoServer's default port
EXPOSE 8080
CMD ["/opt/geoserver/bin/startup.sh"]
