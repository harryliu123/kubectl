FROM bitnami/kubectl:latest

USER root
COPY . /
RUN chmod +x /entrypoint.sh

USER 1001

ENTRYPOINT ["/entrypoint.sh"]

CMD ["kubectl"]
