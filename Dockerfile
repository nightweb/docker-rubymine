FROM ruby:2.2.0
MAINTAINER zchee <zcheeee@gmail.com>

RUN bundle config --global jobs 4

RUN apt-get update && apt-get install -y openssh-server --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22

RUN apt-get update && apt-get install -y nodejs mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN gem update --system
ENV GEM_HOME /root/.gem/ruby/2.2.0/
ENV PATH $GEM_HOME/bin:$PATH

RUN gem install bundler ruby-debug-ide debase \
  && bundle config --global path "$GEM_HOME" \
  && bundle config --global bin "$GEM_HOME/bin"
ENV BUNDLE_APP_CONFIG $GEM_HOME

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ONBUILD COPY Gemfile /usr/src/app/
ONBUILD COPY Gemfile.lock /usr/src/app/
ONBUILD RUN bundle install

EXPOSE 3000
CMD ["/usr/sbin/sshd", "-D"]
