# ruby 2.1.3
# iojs 1.6.4
# openssh 6.7p1
# mysql 14.14 Distrib 5.5.42
# postgres 2.25.2
# sqlite3 3.8.7.1
#
# EXPOSE 22
# EXPOSE 3000
#
# ENV
# PATH=/root/.gem/ruby/2.2.0//bin:/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# RUBY_MAJOR=2.1
# RUBY_VERSION=2.1.3
# RUBY_DOWNLOAD_SHA256=5a4de38068eca8919cb087d338c0c2e3d72c9382c804fb27ab746e6c7819ab28
# GEM_HOME=/root/.gem/ruby/2.1.3/
# BUNDLE_APP_CONFIG=/root/.gem/ruby/2.1.3/
# NOTVISIBLE="in users profile"
# NPM_CONFIG_LOGLEVEL=info
# IOJS_VERSION=1.6.4
# HOME=/root

FROM ruby:2.1.3
MAINTAINER zchee <zcheeee@gmail.com>

RUN apt-get update && apt-get install -y openssh-server --no-install-recommends
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

RUN apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# gpg keys listed at https://github.com/iojs/io.js
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
  9554F04D7259F04124DE6B476D5A82AC7E37093B \
  DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
  FD3A5288F042B6850C66B31F09FE44734EB7990E

ENV NPM_CONFIG_LOGLEVEL info
ENV IOJS_VERSION 1.6.4

RUN curl -SLO "https://iojs.org/dist/v$IOJS_VERSION/iojs-v$IOJS_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://iojs.org/dist/v$IOJS_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " iojs-v$IOJS_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "iojs-v$IOJS_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "iojs-v$IOJS_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

RUN gem update --system
ENV GEM_HOME /root/.gem/ruby/${RUBY_MAJOR}.0/
RUN echo "GEM_HOME=/root/.gem/ruby/${RUBY_MAJOR}.0/" >> /root/.bashrc
ENV PATH $GEM_HOME/bin:$PATH
RUN echo "PATH=$GEM_HOME/bin:$PATH" >> /root/.bashrc

RUN gem install bundler && \
  	bundle config --global path "$GEM_HOME" && \
		bundle config --global bin "$GEM_HOME/bin" && \
  	bundle config --global jobs 10
ENV BUNDLE_APP_CONFIG $GEM_HOME
RUN echo "BUNDLE_APP_CONFIG=$GEM_HOME" >> /root/.bashrc

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install

EXPOSE 3000
CMD ["/usr/sbin/sshd", "-D"]
