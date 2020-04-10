FROM alpine:3.8 as builder
ARG K8S_VERSION=v1.16.5
COPY entrypoint.sh /
RUN set -x                  && \
    apk --update upgrade    && \
    apk add ca-certificates && \
    rm -rf /var/cache/apk/* && \
    wget -O /kubectl https://storage.googleapis.com/kubernetes-release/release/$K8S_VERSION/bin/linux/amd64/kubectl && \
    chmod +x /kubectl /entrypoint.sh &&\
    wget -O /velero-v1.3.1-linux-amd64.tar.gz https://github.com/vmware-tanzu/velero/releases/download/v1.3.1/velero-v1.3.1-linux-amd64.tar.gz &&\
    tar zxvf /velero-v1.3.1-linux-amd64.tar.gz &&\ 
    chmod +x  /velero-v1.3.1-linux-amd64/velero

FROM alpine:3.8
COPY --from=builder /kubectl /usr/local/bin/kubectl
COPY --from=builder /velero-v1.3.1-linux-amd64/velero  /usr/local/bin/velero 
COPY --from=builder /entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["kubectl"]
