FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y dialog git && \
    rm -rf /var/lib/apt/lists/*

COPY ./scripts /root/install/
RUN chmod +x /root/install/install.sh

WORKDIR /root/install
ENTRYPOINT ["/root/install/install.sh"]