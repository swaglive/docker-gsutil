ARG             base=python:3-alpine

FROM            ${base} as gsutil

RUN             apk add --no-cache --virtual .build-deps \
                    curl && \
                curl -sL https://storage.googleapis.com/pub/gsutil.tar.gz | tar xz && \
                apk del .build-deps

###

FROM            ${base}

ARG             CRCMOD_VERSION=1.7

ENV             PATH="/gsutil/bin:${PATH}"

ENTRYPOINT      ["gsutil"]
CMD             ["version", "-l"]

WORKDIR         /gsutil

RUN             apk add --virtual .build-deps \
                    ca-certificates \
                    python3-dev \
                    build-base && \
                pip install crcmod==${CRCMOD_VERSION} && \
                python -c 'import crcmod._crcfunext' && \
                apk add --virtual .run-deps \
                    ca-certificates && \
                apk del .build-deps

COPY            --from=gsutil /gsutil bin

COPY            .boto /home/.boto
ENV             BOTO_PATH=/home/.boto
