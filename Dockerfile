FROM ubuntu:latest
MAINTAINER Kirsten Hunter (khunter@akamai.com)
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes -q curl python-all wget vim python-pip ruby ruby-dev perl5-base npm nano 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes mongodb-server mongodb-dev mongodb httpie
RUN curl -sL https://deb.nodesource.com/setup_4.x |  bash -
RUN apt-get install -y --force-yes nodejs
RUN mkdir -p /data/db
ADD . /opt
WORKDIR /opt/ruby
RUN gem install bundler
RUN bundle install
WORKDIR /opt/python
RUN pip install -r requirements.txt
WORKDIR /opt/node
RUN npm install
WORKDIR /opt/perl
RUN cpan -i -f Dancer Dancer::Plugin::CRUD MongoDB JSON YAML
WORKDIR /opt/data
EXPOSE 8080
ADD ./MOTD /opt/MOTD
RUN echo "cat /opt/MOTD" >> /root/.bashrc
ENTRYPOINT ["/bin/bash"]
