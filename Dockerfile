FROM resin/rpi-raspbian:jessie-20160511

RUN apt-get update && apt-get -y install fbi imagemagick

COPY . /usr/src/app
WORKDIR /usr/src/app

CMD ./prestart.sh && ./start.sh
