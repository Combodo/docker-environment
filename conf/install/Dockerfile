FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y dialog git locales && \
    rm -rf /var/lib/apt/lists/*

RUN locale-gen fr_FR.UTF-8

COPY . /root/install/
RUN chmod +x /root/install/install.sh

WORKDIR /root/install
ENTRYPOINT ["/root/install/install.sh"]