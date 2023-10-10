# https://hangarau.space/using-supervisord-as-the-init-process-of-a-docker-container/

FROM alpine:3.18 AS builder

RUN mkdir /usr/local/src && \
    apk update && apk upgrade && \
    apk add  --no-cache binutils git make clang gcc musl-dev
WORKDIR /usr/local/src
RUN git clone https://github.com/dennypage/dpinger.git
RUN cd dpinger && make

FROM alpine:3.18
LABEL maintainer="sshnoc.com"

ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM

RUN echo "I'm building for $TARGETPLATFORM $TARGETARCH $BUILDPLATFORM"

COPY --from=builder /usr/local/src/dpinger/dpinger /usr/bin/dpinger

COPY ./etc/supervisor.d /etc/supervisor.d
COPY ./etc/supervisord.conf /etc/
COPY ./*.py /
COPY ./*.sh /

RUN apk update && apk upgrade && \
    apk add --no-cache tini ca-certificates supervisor rsyslog python3 && \
    apk add --no-cache wireguard-tools-wg-quick fping screen && \
    apk add --no-cache dropbear && \
    chmod +x /*.sh && \
    mkdir /var/log/supervisor && \
    rm -rf /var/cache/apk/*

# Set environment variables.
# ENV HOME /root

EXPOSE 9001/tcp
# Define default command.
ENTRYPOINT ["/sbin/tini", "-v", "--"]
CMD [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]
