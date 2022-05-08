ARG             base=python:3-alpine

FROM            ${base} as google-cloud-sdk

ARG             version=384.0.1

RUN             apk add --no-cache --virtual .build-deps \
                    curl && \
                curl -sL https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${version}-linux-x86_64.tar.gz | tar xz && \
                apk del .build-deps

###

FROM            ${base}

ARG             CRCMOD_VERSION=1.7

ENV             PATH="/google-cloud-sdk/bin:${PATH}"

ENTRYPOINT      ["gsutil"]
CMD             ["version", "-l"]

WORKDIR         /google-cloud-sdk

RUN             apk add --virtual .build-deps \
                    ca-certificates \
                    python3-dev \
                    build-base && \
                pip install crcmod==${CRCMOD_VERSION} && \
                python -c 'import crcmod._crcfunext' && \
                apk add --virtual .run-deps \
                    ca-certificates && \
                apk del .build-deps

COPY            --from=google-cloud-sdk /google-cloud-sdk/bin bin
COPY            --from=google-cloud-sdk /google-cloud-sdk/platform platform
COPY            --from=google-cloud-sdk /google-cloud-sdk/lib lib
