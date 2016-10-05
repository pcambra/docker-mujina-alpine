FROM maven:3.3.9-jdk-8-alpine

ENV PYTHON_VERSION=2.7.12-r0
ENV PY_PIP_VERSION=8.1.2-r0
ENV SUPERVISOR_VERSION=3.3.0

RUN apk update && \
    apk add --no-cache --virtual .build-deps \
      git \
      python=$PYTHON_VERSION \
      py-pip=$PY_PIP_VERSION && \
    rm -rf /var/cache/apk/* && \
    pip install supervisor==$SUPERVISOR_VERSION

RUN mkdir -p /usr/local/etc && \
    cd /usr/local/etc && \
    git clone https://github.com/OpenConext/Mujina.git && \
    cd Mujina && \
    mvn clean install

COPY supervisord.conf /etc/supervisord.conf
COPY mujina-load.sh /usr/local/etc/mujina-load.sh
RUN chmod +x /usr/local/etc/mujina-load.sh

EXPOSE 8080 9090

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
