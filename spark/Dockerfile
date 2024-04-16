FROM ubuntu:22.04 as base

LABEL maintainer="Lucas Miguel Ponce <lucasmsp@dcc.ufmg.br>"

ENV TERM=xterm\
    TZ=America/Sao_Paulo\
    DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
      python3 \
      python3-pip \
      python3-dev \
      python3-tk \
      python3-setuptools \
      openjdk-8-jdk \
      curl \
  && rm -rf /var/lib/apt/lists/*

ENV SPARK_VERSION=3.4
ENV HADOOP_VERSION=3
ENV SPARK_BASE_URL=https://downloads.apache.org/spark/

ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $PYTHONPATH:$SPARK_HOME/python:${SPARK_HOME}/python/lib/pyspark.zip:${SPARK_HOME}/python/lib/py4j-*.zip
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="${PATH}:${JAVA_HOME}"

# Get latest spark based on major.minor version
RUN SPARK_LATEST_VERSION=$(\
      curl -sL ${SPARK_BASE_URL} | \
      grep -Eo "spark-${SPARK_VERSION}\.[0-9]{1}" | \
      head -1 \
    ) \
  && SPARK_HADOOP_PKG=${SPARK_LATEST_VERSION}-bin-hadoop${HADOOP_VERSION} \
  && SPARK_HADOOP_URL=${SPARK_BASE_URL}/${SPARK_LATEST_VERSION}/${SPARK_HADOOP_PKG}.tgz \
  && curl -sL ${SPARK_HADOOP_URL} | tar -xz -C /usr/local/  &&\
    mv /usr/local/$SPARK_HADOOP_PKG $SPARK_HOME &&\
    ln -s /usr/local/spark /opt/spark

COPY ./entrypoint.sh /opt/
ENTRYPOINT [ "/opt/entrypoint.sh" ]
