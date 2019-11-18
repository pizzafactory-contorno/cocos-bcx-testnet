FROM ubuntu:16.04 AS extractor

ARG VERSION=0.7.16

RUN apt-get update
RUN apt-get install -y git

SHELL [ "/bin/bash", "-c" ]
WORKDIR /
RUN git clone --depth=1 https://github.com/Cocos-BCX/cocos-bcx-node-bin.git

WORKDIR /cocos-bcx-node-bin/cli/testnet/$VERSION/linux/
RUN tar xzf cli_wallet.tar.gz
RUN md5sum -c sha256checksum
RUN cp cli_wallet /cli_wallet && chmod 755 /cli_wallet

WORKDIR /cocos-bcx-node-bin/fullnode/testnet/$VERSION/linux/
RUN tar xzf witness_node.tar.gz
RUN md5sum -c sha256checksum
RUN cp witness_node ../config/genesis.json / && chmod 755 /witness_node

WORKDIR /
RUN nohup /witness_node --genesis-json /genesis.json >& tmp.log & \
    sleep 3 && \
    while true; do \
      grep "Chain ID is" tmp.log > chainID.log && break; \
    done; \
    pkill witness_node
RUN cp /*_*_*/config.ini /


FROM pizzafactory0contorno/piatto:ubuntu-16.04

USER root
RUN apt-get update && \
    apt-get install -y \
      libbz2-dev \
      libdb++-dev \
      libdb-dev \
      libssl-dev \
      openssl \
      libreadline-dev \
      libcurl4-openssl-dev \
      libboost-all-dev
COPY --from=extractor /cli_wallet /witness_node /genesis.json /chainID.log /config.ini /
ADD entrypoint.sh /
USER user

EXPOSE 8060 8090

CMD [ "/witness_node" ]
