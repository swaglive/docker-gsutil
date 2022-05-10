ARG             base=python:3-alpine

FROM            ${base}

ARG             GSUTIL_VERSION=5.10

ARG             CRCMOD_VERSION=1.7

ENTRYPOINT      ["gsutil"]
CMD             ["version", "-l"]

RUN             apk add --virtual .build-deps \
                    ca-certificates \
                    python3-dev \
                    libffi-dev \
                    build-base && \
                pip install crcmod==${CRCMOD_VERSION} && \
                python -c 'import crcmod._crcfunext' && \
                pip install gsutil==${GSUTIL_VERSION} && \
                apk add --virtual .run-deps \
                    ca-certificates && \
                apk del .build-deps

COPY            .boto /home/.boto
ENV             BOTO_PATH=/home/.boto
