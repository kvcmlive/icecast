
FROM alpine:latest as tailscale
WORKDIR /app
ENV TSFILE=tailscale_1.40.1_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1

FROM moul/icecast

RUN apt-get -qq -y update; apt-get -qq -y install ca-certificates iptables && rm -rf /var/cache/apk/*

COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

CMD ["/start-tailscale.sh"]

ADD ./start-tailscale.sh /start-tailscale.sh
