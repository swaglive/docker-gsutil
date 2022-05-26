ARG             base=python:3-alpine

FROM            ${base}

ARG             version=5.10
ARG             CRCMOD_VERSION=1.7
ARG             DOCKERIZE_VERSION=v0.6.1

COPY            .boto.tmpl /root/.boto.tmpl

RUN             apk add --virtual .build-deps \
                    ca-certificates \
                    python3-dev \
                    libffi-dev \
                    build-base && \
                pip install \
                    gsutil==${version} \
                    crcmod==${CRCMOD_VERSION} && \
                python -c 'import crcmod._crcfunext' && \
                apk add --virtual .run-deps \
                    ca-certificates && \
                apk del .build-deps && \
                wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz && \
                tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz && \
                rm dockerize-alpine-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

ENTRYPOINT      ["dockerize", "-template", "/root/.boto.tmpl:/root/.boto", "gsutil"]
CMD             ["version", "-l"]
