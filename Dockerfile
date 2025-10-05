FROM ubuntu:24.04
RUN --mount=type=bind,source=./setup.sh,target=/setup.sh \
    --mount=type=bind,source=./package.tar.gz,target=/package.tar.gz \
    sh -x /setup.sh
COPY app /app/
EXPOSE 5980/tcp
EXPOSE 8118/tcp
ENTRYPOINT ["sh", "/app/entrypoint.sh"]
