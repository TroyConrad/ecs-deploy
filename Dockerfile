FROM ubuntu:16.04

MAINTAINER Troy Conrad <troy.conrad@mirumagency.com>

# Install Perl then remove all unneeded files and dependencies
RUN apt-get update \
	&& apt-get install -y perl \
	&& apt-get autoremove -y \
	&& apt-get clean

COPY ecs-deploy* /opt/ecs-deploy/

ENTRYPOINT ["/usr/bin/perl","/opt/ecs-deploy/ecs-deploy"]
CMD ["-h"]