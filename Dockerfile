FROM debian:stretch-slim

RUN echo "deb http://httpredir.debian.org/debian stretch-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      git \
      openssh-client \
      ca-certificates curl wget git gnupg apt-transport-https && \
    wget -O - https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    mkdir -p /usr/share/man/man1/ && \
    apt-get update && \
    apt-get install -y -t stretch-backports --no-install-recommends \
        ansible \
        php7.0-cli \
        openjdk-8-jdk-headless \
        nodejs \
        npm \
        yarn \
    && \
    wget https://dl.google.com/go/go1.11.4.linux-amd64.tar.gz && \
    tar -C /usr/local/ -zxf go1.11.4.linux-amd64.tar.gz && \
    rm -f go1.11.4.linux-amd64.tar.gz && \
    wget https://github.com/sass/dart-sass/releases/download/1.16.0/dart-sass-1.16.0-linux-x64.tar.gz && \
    tar -C /usr/local/ -zxf dart-sass-1.16.0-linux-x64.tar.gz && \
    rm -rf dart-sass-1.16.0-linux-x64.tar.gz && \
    /usr/bin/npm install gulp-cli -g && /usr/bin/npm install gulp -D && \
    apt-get clean && rm -rf /var/lib/apt/lists && \
    mkdir /sources && mkdir /sources/deploy && mkdir /sources/deploy/tmp && cd /sources

COPY . /sources/trellis

VOLUME /sources/site

ENV DEPLOY_USER=deploy PATH=/usr/local/sbin:/usr/local/bin:/usr/local/go/bin:/usr/local/dart-sass:/usr/sbin:/usr/bin:/sbin:/bin

WORKDIR /sources/trellis

ENTRYPOINT ["/bin/bash"]
CMD [ "ansible-playbook", "-e deploy_host=$ENV", "-i hosts", "deploy.yml"]
