FROM ghcr.io/linuxserver/baseimage-kasmvnc:amd64-ubuntujammy-42b6f332-ls134

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Metatrader Docker:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="jason"

ENV TITLE=Metatrader5
ENV WINEPREFIX="/config/.wine"


# Update package lists and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install required packages
RUN apt-get install -y \
    python3-pip \
    wget \
    && pip3 install --upgrade pip

# Add WineHQ repository key and APT source
RUN wget -q https://dl.winehq.org/wine-builds/winehq.key \
    && apt-key add winehq.key \
    && add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' \
    && rm winehq.key

# Add i386 architecture and update package lists
RUN dpkg --add-architecture i386 \
    && apt-get update

# Install WineHQ stable package and dependencies
RUN apt-get install --install-recommends -y \
    winehq-stable 

RUN apt-get install git -y

RUN  apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY /Metatrader /Metatrader
RUN chmod +x /Metatrader/start.sh
RUN chmod +x /Metatrader/pre_start.sh
COPY /root /

# RUN /Metatrader/pre_start.sh
# RUN chown -R 911:911 /config

EXPOSE 3000 8001
VOLUME /config
