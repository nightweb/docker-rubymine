FROM ruby:2.2.1
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
ENV IOJS_VERSION 2.0.0

RUN curl -SLO "https://iojs.org/dist/v$IOJS_VERSION/iojs-v$IOJS_VERSION-linux-x64.tar.gz" \
  && curl -SLO "https://iojs.org/dist/v$IOJS_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " iojs-v$IOJS_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "iojs-v$IOJS_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "iojs-v$IOJS_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc

RUN gem update --system
ENV GEM_HOME /root/.gem/ruby/${RUBY_MAJOR}.0/
RUN echo "export GEM_HOME=/root/.gem/ruby/${RUBY_MAJOR}.0/" >> /root/.bashrc
ENV PATH $GEM_HOME/bin:$PATH
RUN echo "export PATH=$GEM_HOME/bin:$PATH" >> /root/.bashrc

RUN gem install bundler && \
    bundle config --global path "$GEM_HOME" && \
    bundle config --global bin "$GEM_HOME/bin" && \
    bundle config --global jobs 10
ENV BUNDLE_APP_CONFIG $GEM_HOME
RUN echo "export BUNDLE_APP_CONFIG=$GEM_HOME" >> /root/.bashrc

RUN mkdir -p /usr/src/app

WORKDIR /tmp
ENV ZSH_VERSION 5.0.7
RUN curl -SLO "http://jaist.dl.sourceforge.net/project/zsh/zsh/${ZSH_VERSION}/zsh-${ZSH_VERSION}.tar.bz2"
RUN tar -jxf "zsh-${ZSH_VERSION}.tar.bz2"
WORKDIR zsh-${ZSH_VERSION}
RUN ./configure --prefix=/usr/local --enable-multibyte --enable-locale --with-tcsetpgrp
RUN make && make install

RUN echo '/usr/local/bin/zsh' >> /etc/shells
RUN chsh -s /usr/local/bin/zsh root

ENV HOME /root
RUN git clone --recursive https://github.com/sorin-ionescu/prezto.git "$HOME/.zprezto"

RUN mv /root/.zprezto/runcoms/zlogin /root/.zlogin &&\
    mv /root/.zprezto/runcoms/zlogout /root/.zlogout &&\
    mv /root/.zprezto/runcoms/zpreztorc /root/.zpreztorc &&\
    mv /root/.zprezto/runcoms/zprofile /root/.zprofile &&\
    mv /root/.zprezto/runcoms/zshenv /root/.zshenv &&\
    mv /root/.zprezto/runcoms/zshrc /root/.zshrc

RUN echo "`cat /root/.bashrc`" >> /root/.zshrc

WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
# ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install

EXPOSE 3000
CMD ["/usr/sbin/sshd", "-D"]
