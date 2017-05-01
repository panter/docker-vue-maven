FROM maven:3.3.9-jdk-8


RUN apt-get update
RUN apt-get install sudo
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN sudo npm install node-gyp -g

# Add the Firefox release channel of the Debian Mozilla team:
RUN echo 'deb http://mozilla.debian.net/ jessie-backports firefox-release' >> \
  /etc/apt/sources.list \
  && curl -sL https://mozilla.debian.net/archive.asc | apt-key add -

# Install Firefox:
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    firefox \
    xvfb \
    xauth \
  # Remove obsolete files:
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Install geckodriver:
RUN export BASE_URL=https://github.com/mozilla/geckodriver/releases/download \
  && export VERSION=$(curl -sL \
    https://api.github.com/repos/mozilla/geckodriver/releases/latest | \
    grep tag_name | cut -d '"' -f 4) \
  && curl -sL \
  $BASE_URL/$VERSION/geckodriver-$VERSION-linux64.tar.gz | tar -xz \
  && mv geckodriver /usr/local/bin/geckodriver

RUN Xvfb :99 &
RUN export DISPLAY=:99