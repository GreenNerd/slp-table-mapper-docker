#FROM ubuntu:18.04
#
#MAINTAINER Fanxy 'fan1997603@vip.qq.com'
#
#RUN echo 2.0.`date +%Y%m%d` > /VERSION
#
#ENV RUBY_VERSION=2.5.0
#
#RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
#RUN apt-get update && apt-get install -y apt-utils
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
#                                                      curl \
#                                                      git-core \
#                                                      build-essential \
#                                                      libssl-dev libreadline-dev zlib1g-dev \
#                                                      graphicsmagick \
#                                                      tzdata \
#                                                      libjemalloc-dev \
#                                                      libpq-dev \
#                                                      nodejs
#
#RUN echo "Asia/Shanghai" > /etc/timezone && rm /etc/localtime
#RUN dpkg-reconfigure -f noninteractive tzdata
#
## set locale
#RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#        && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#ENV LANG en_US.utf8
#
#ENV RUBY_BUILD_MIRROR_URL=https://cache.ruby-china.org
#RUN echo 'gem: --no-document' >> /usr/local/etc/gemrc && \
#    mkdir /src && cd /src && \
#    git clone https://github.com/rbenv/ruby-build.git && \
#    cd /src/ruby-build && ./install.sh && \
#    cd / && rm -rf /src/ruby-build && \
#    RUBY_CONFIGURE_OPTS=--with-jemalloc ruby-build $RUBY_VERSION /usr/local/
#
#RUN ruby -r rbconfig -e "puts RbConfig::CONFIG['LIBS']"
#
#RUN gem install bundler -v '1.17.3' && gem cleanup
#
## clean up for docker squash
#RUN   rm -fr /usr/share/man && \
#      rm -fr /usr/share/doc && \
#      rm -fr /usr/share/vim/vim74/tutor && \
#      rm -fr /usr/share/vim/vim74/doc && \
#      rm -fr /usr/share/vim/vim74/lang && \
#      rm -fr /usr/local/share/doc && \
#      rm -fr /usr/local/share/ruby-build && \
#      rm -fr /root/.gem && \
#      rm -fr /root/.npm && \
#      rm -fr /tmp/* && \
#      rm -fr /usr/share/vim/vim74/spell/en*
#
## Clean apt-get
#RUN apt-get clean && \
#    rm -rf /var/lib/apt/lists/*
#
#RUN mkdir -p /var/www/slp_table_mapper
#
#WORKDIR /var/www/slp_table_mapper
#
#RUN gem update bundler
#
#COPY slp_table_mapper/ /var/www/slp_table_mapper/
#
#RUN bundle install

FROM ruby:2.5.0-stretch

RUN sed -i 's/archive.ubuntu.com/mirrors.163.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl \
                                                      git-core \
                                                      build-essential \
                                                      libssl-dev libreadline-dev zlib1g-dev \
                                                      libpq-dev \
                                                      nodejs

RUN useradd skylark -s /bin/bash -m -U && mkdir -p /var/www/slp_table_mapper
RUN chown -R skylark:skylark /var/www/slp_table_mapper

RUN gem install bundler

USER skylark
WORKDIR /var/www/slp_table_mapper

COPY ./slp_table_mapper/ /var/www/slp_table_mapper/

USER root

RUN bundle install
