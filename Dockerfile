FROM debian:11

# get wget and pip
RUN apt update && apt install wget python3-pip -y

# import key
RUN mkdir -p /etc/apt/keyrings
RUN wget -q -O /etc/apt/keyrings/mopidy-archive-keyring.gpg https://apt.mopidy.com/mopidy.gpg

# add apt repo
RUN wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/bullseye.list

# install mopidy
RUN apt update && apt install -y mopidy

# install GStreamer
RUN apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 gstreamer1.0-pulseaudio

# install extensions from pip
RUN pip3 install Mopidy-Iris
RUN pip3 install Mopidy-Party
RUN pip3 install Mopidy-YouTube
RUN pip3 install Mopidy-Mixcloud
RUN pip3 install Mopidy-SomaFM
RUN pip3 install Mopidy-TuneIn
RUN pip3 install Mopidy-MPD
RUN pip3 install yt-dlp

# create directories
RUN mkdir /home/mopidy && chown -R mopidy /home/mopidy

# copy config file
COPY config/mopidy.conf /home/mopidy/conf/mopidy.conf

# copy run script
COPY config/run.sh /home/mopidy/run.sh
RUN chmod +x /home/mopidy/run.sh

# switch to non-root user
USER mopidy

# expose interfaces
EXPOSE 6680
EXPOSE 6600

# run mopidy by default
CMD [ "/home/mopidy/run.sh" ]