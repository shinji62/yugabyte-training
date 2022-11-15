FROM ubuntu:20.04

LABEL org.label-schema.name="benchmark-tools-yugabyte" \
    org.label-schema.description="Dockerfile which include " \
    org.label-schema.vcs-url="https://github.com/shinji62/yugabyte-training" \
    org.label-schema.vendor="Etourneau Gwenn" \
    org.label-schema.schema-version="1.0"

RUN apt-get update \
    && apt-get install -y --no-install-recommends  \
    automake  \
    ca-certificates \ 
    curl \
    git \
    libaio-dev \
    libpq-dev \
    libtool \
    make \
    pkg-config \
    python

ADD get_clients.sh /tmp/get_clients.sh

RUN chmod +x /tmp/get_clients.sh \
    && /tmp/get_clients.sh && rm /tmp/get_clients.sh

# Compile / Install sysbench
RUN git clone https://github.com/yugabyte/sysbench.git \
    && cd sysbench && ./autogen.sh && ./configure --with-pgsql --without-mysql --disable-dependency-tracking   && make -j && make install \
    && cp src/sysbench /usr/local/bin/ \
    && apt-get purge -y --auto-remove ca-certificates automake libtool make vim pkg-config \
    && rm -rf /var/lib/apt/lists/*

