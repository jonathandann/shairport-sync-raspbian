FROM balenalib/raspberry-pi-debian:buster

RUN apt-get update && apt-get upgrade

RUN apt-get install -y \
  build-essential \
  git \
  xmltoman \
  autoconf \
  automake \
  avahi-daemon \
  libavahi-client-dev \
  libtool \
  libpopt-dev \
  libconfig-dev \
  libasound2-dev \
  libssl-dev

RUN git clone https://github.com/mikebrady/shairport-sync.git
WORKDIR shairport-sync 
RUN autoreconf -fi
RUN ./configure \
  --sysconfdir=/etc \
  --with-alsa \
  --with-avahi \
  --with-ssl=openssl
RUN make -j $(nproc)
RUN make install

WORKDIR /

RUN rm -rf shairport-sync
RUN apt-get remove -y \
  build-essential \
  git \
  xmltoman \
  autoconf \
  automake

COPY etc/shairport-sync.conf /etc/shairport-sync.conf
COPY start.sh /start.sh
RUN chmod +x /start.sh

ENV AIRPLAY_NAME $(hostname)
ENTRYPOINT [  "/start.sh" ]