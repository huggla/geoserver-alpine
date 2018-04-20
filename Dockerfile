FROM huggla/tomcat-alpine

USER root

ENV GEOSERVER_VERSION="2.8.5" \
    GDAL_VERSION="1.11.4" \
    ANT_VERSION="1.9.11" \
    ANT_HOME="/usr/local/ant" \
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib/" \
    _POSIX2_VERSION="199209" \
    JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk" \
    PATH="$PATH:/usr/local/ant/bin"

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
 && wget https://www.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz -O "$downloadDir/ant.tar.gz" \
 && tar xzf "$downloadDir/ant.tar.gz" -C "$downloadDir" \
 && mkdir /usr/local/ant \
 && mv "$downloadDir/apache-ant-${ANT_VERSION}/bin" /usr/local/ant/bin \
 && mv "$downloadDir/apache-ant-${ANT_VERSION}/lib" /usr/local/ant/lib \
 && cd "$buildDir/gdal-${GDAL_VERSION}/swig/java" \
 && sed -i '/JAVA_HOME =/d' java.opt \
 && make \
 && make install \
 && mv *.so /usr/local/lib/ \
 && mv "$buildDir/gdal-${GDAL_VERSION}/swig/java/gdal.jar" /usr/share/gdal.jar \
 && rm -rf "$buildDir" \
 && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip -O "$downloadDir/geoserver.zip" \
 && unzip "$downloadDir/geoserver.zip" geoserver.war -d "$CATALINA_HOME/webapps" \
 && JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk/jre" /usr/lib/jvm/java-1.8-openjdk/bin/jar xvf "$CATALINA_HOME/webapps/geoserver.war" -C "$CATALINA_HOME/webapps" \
 && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-ogr-wfs-plugin.zip -O "$downloadDir/geoserver-ogr-plugin.zip" \
 && unzip -o "$downloadDir/geoserver-ogr-plugin.zip" -d "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib" \
 && wget http://iweb.dl.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/extensions/geoserver-$GEOSERVER_VERSION-gdal-plugin.zip -O "$downloadDir/geoserver-gdal-plugin.zip" \
 && unzip -o "$downloadDir/geoserver-gdal-plugin.zip" -d "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib" \
 && rm -rf "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/imageio-ext-gdal-bindings-1.9.2.jar" \
 && cp /usr/share/gdal.jar "$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/gdal.jar" \
 && apk del .build-deps \
 && rm -rf "$downloadDir"

ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk/jre"

USER sudoer
