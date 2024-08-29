FROM maven:3.8.6-jdk-8-slim AS stage-atlas

ENV	MAVEN_OPTS "-Xms2g -Xmx2g -Dhttp.socketTimeout=60000 -Dhttp.connectionTimeout=60000 -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true -Dmaven.wagon.httpconnectionManager.ttlSeconds=120 -Dmaven.wagon.http.retryHandler.count=3"

ENV ATLAS_VERSION 2.3.0


RUN curl -L -O https://github.com/apache/atlas/archive/refs/tags/release-$ATLAS_VERSION.zip \
    && apt-get update \
    && apt-get install -y unzip \
    && unzip release-$ATLAS_VERSION.zip \
	&& cd atlas-release-$ATLAS_VERSION/ \
	&& mvn clean -DskipTests package -Pdist,embedded-hbase-solr \
	&& mv distro/target/apache-atlas-*-bin.tar.gz /apache-atlas.tar.gz

FROM centos:7

COPY --from=stage-atlas /apache-atlas.tar.gz /apache-atlas.tar.gz

RUN sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo \
	&& sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo \
	&& sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo

RUN yum update -y \
	&& yum install -y python python36 python36-devel java-1.8.0-openjdk java-1.8.0-openjdk-devel net-tools \
	&& yum -y groupinstall "Development Tools" \
	&& yum -y install gcc openssl-devel bzip2-devel libffi-devel \
	&& yum clean all

RUN groupadd hadoop && \
	useradd -m -d /opt/atlas -g hadoop atlas

RUN pip3 install amundsenatlastypes==1.2.2

USER atlas

RUN cd /opt \
	&& tar xzf /apache-atlas.tar.gz -C /opt/atlas --strip-components=1

COPY model /tmp/model
COPY resources/atlas-setup.sh /tmp
COPY resources/credentials /tmp
COPY resources/init_amundsen.py /tmp

COPY resources/atlas-application.properties /opt/atlas/conf/

USER root
ADD resources/entrypoint.sh /entrypoint.sh
RUN rm -rf /apache-atlas.tar.gz

USER atlas

ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]

EXPOSE 21000
