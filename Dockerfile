#QGIS 3.8.2 on Ubuntu 18.04
# Pull base image.
FROM ubuntu:18.04

# Install the bases and upgrade the system
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential gnupg && \
  apt-get install -y software-properties-common && \
  rm -rf /var/lib/apt/lists/*

#Install preliminary files
RUN \
  apt-get update && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y install ca-certificates apt-utils wget tzdata && \
  wget --no-check-certificate -O - https://qgis.org/downloads/qgis-2019.gpg.key | gpg --batch --yes --import && \
  gpg --yes --batch --fingerprint 51F523511C7028C3 && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-key 51F523511C7028C3 && \
  /bin/ln -sf /usr/share/zoneinfo/Etc/Zulu  /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata 

#Install the actual QGIS package, than perform cleanup
RUN \
  add-apt-repository -s 'deb https://qgis.org/ubuntu/ bionic main' && \
  apt-get update && \
  apt-get install -y python-qgis qgis qgis-plugin-grass python-numpy python-scipy python-matplotlib && \
  apt-get remove -y --purge qt4-qmake cmake-data qt4-linguist-tools libqt4-dev-bin && \
  apt-get remove -y --purge libqt4* libgtk* libsane gfortran-5 *gnome* libsane *pango* glib* *gphoto* && \
  apt-get remove -y --purge build-essential gnupg software-properties-common apt-utils wget && \
  apt-get clean

#Create directories to be used 
RUN \
  mkdir -p /root/ && \
  mkdir -p /root/qgis38-files 

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
CMD ["qgis"]