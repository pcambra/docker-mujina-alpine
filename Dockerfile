FROM maven:3.3.9-jdk-8-alpine

ENV PYTHON_VERSION=2.7.14-r0
ENV PY_PIP_VERSION=9.0.0-r1
ENV SUPERVISOR_VERSION=3.3.0
ENV MUJINA_VERSION=mujina-4.1.3


RUN apk add --update \
      git \
      python=$PYTHON_VERSION \
      py2-pip=$PY_PIP_VERSION && \
    rm -rf /var/cache/apk/* && \
    pip install supervisor==$SUPERVISOR_VERSION

RUN mkdir -p /usr/local/etc && \
    cd /usr/local/etc && \
    git clone https://github.com/OpenConext/Mujina.git && \
    cd Mujina && \
    git checkout tags/$MUJINA_VERSION && \
    mvn clean install

COPY supervisord.conf /etc/supervisord.conf
COPY mujina-load.sh /usr/local/etc/mujina-load.sh
RUN chmod +x /usr/local/etc/mujina-load.sh

EXPOSE 8080 9090

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
