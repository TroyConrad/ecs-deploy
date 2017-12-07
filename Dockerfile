FROM ubuntu:16.10

MAINTAINER Troy Conrad <troy.conrad@mirumagency.com>

#
##
### SETUP AWS CLI ###

# Configure locale (for UTF-8 support)
ARG LC=en_US.UTF-8
RUN sed -i -e "s/# $LC UTF-8/$LC UTF-8/" /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=$LC

# Configure timezone
RUN rm /etc/localtime ; \
	echo "US/Pacific" > /etc/timezone && \   
	dpkg-reconfigure -f noninteractive tzdata

# AWS CLI needs the PYTHONIOENCODING environment varialbe to handle UTF-8 correctly:
ENV PYTHONIOENCODING=UTF-8

RUN apt-get update && \
	apt-get install -y \
    python \
    python-pip && \
    pip install awscli && \
	apt-get purge -y --auto-remove python-pip && apt-get clean    

#
##
### SETUP ECS-DEPLOY ###

# Install Perl then remove all unneeded files and dependencies
RUN apt-get update \
	&& apt-get install -y perl \
	&& apt-get autoremove -y \
	&& apt-get clean

COPY ecs-deploy* /opt/ecs-deploy/

#
##
### SETUP NON-ROOT USER ###

RUN adduser --disabled-login --gecos '' aws
WORKDIR /home/aws

USER aws

ENTRYPOINT ["/usr/bin/perl","/opt/ecs-deploy/ecs-deploy"]
CMD ["-h"]