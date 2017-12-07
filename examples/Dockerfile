# Example Node Dockerfile

FROM nodesource/trusty:6.2.1

MAINTAINER Troy Conrad <troy.conrad@mirumagency.com>

RUN mkdir -p /usr/src

WORKDIR /usr/src

# Install common dependencies
COPY /package.json /usr/src
RUN npm i
RUN npm i --global webpack

# Add code and build project
COPY . /usr/src
RUN webpack

# Expose port
ENV PORT=8080
EXPOSE ${PORT}

CMD ["node", "/usr/src/bin/www"]