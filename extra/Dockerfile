ARG RUBY_IMAGE=ruby:3
FROM ${RUBY_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV DEVEL=1
ENV LANG=C.UTF-8

RUN apt-get update -qq
RUN apt-get install -yqq --no-install-recommends build-essential chromium less libyaml-dev nano netcat-traditional pkg-config

ARG BUNDLER_VERSION
RUN gem install bundler -v ${BUNDLER_VERSION}
RUN echo 'gem: --no-document' > /etc/gemrc

ARG UID
RUN useradd -u $UID --shell /bin/bash app 

RUN mkdir -p /home/app && chown -R app:app /home/app
RUN chown -R app:app /usr/local/bundle
RUN ln -s /app/extra/.bashrc /home/app/.bashrc

ARG RAILS_VERSION
ENV RAILS_VERSION=$RAILS_VERSION

ARG RANSACK_VERSION
ENV RANSACK_VERSION=$RANSACK_VERSION

ARG ADMINISTRATE_VERSION
ENV ADMINISTRATE_VERSION=$ADMINISTRATE_VERSION

USER $UID
WORKDIR /app
COPY . /app
