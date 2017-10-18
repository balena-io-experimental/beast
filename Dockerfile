FROM resin/rpi-raspbian:jessie-20160511

RUN apt-get update && \
    apt-get -yq --no-install-recommends install \
    fbi \
    imagemagick && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ./prestart.sh && ./start.sh
