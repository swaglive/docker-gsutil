ARG             base=python:3-alpine

FROM            ${base}

ARG             version=5.10
ARG             CRCMOD_VERSION=1.7
ARG             DOCKERIZE_VERSION=0.6.1

WORKDIR         /root

COPY            .boto .boto

ENTRYPOINT      ["dockerize", "-template", ".boto:.boto", "gsutil"]
CMD             ["version", "-l"]

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
                wget -O - https://github.com/jwilder/dockerize/releases/download/v${DOCKERIZE_VERSION}/dockerize-alpine-linux-amd64-v${DOCKERIZE_VERSION}.tar.gz | tar xz -C /usr/local/bin
