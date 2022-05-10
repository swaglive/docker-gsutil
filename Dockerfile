ARG             base=python:3-alpine

FROM            ${base}

ARG             GSUTIL_VERSION=5.10
ARG             CRCMOD_VERSION=1.7

ENV             BOTO_PATH=/home/.boto

COPY            .boto /home/.boto

ENTRYPOINT      ["gsutil"]
CMD             ["version", "-l"]

RUN             apk add --virtual .build-deps \
                    ca-certificates \
                    python3-dev \
                    libffi-dev \
                    build-base && \
                pip install \
                    gsutil==${GSUTIL_VERSION} \
                    crcmod==${CRCMOD_VERSION} && \
                python -c 'import crcmod._crcfunext' && \
                apk add --virtual .run-deps \
                    ca-certificates && \
                apk del .build-deps
