FROM node:10.15
MAINTAINER Ali Khalili "hyperir@gmail.com"

# Update aptitude with new repo
RUN apt-get update
# Install software
RUN apt-get install -y git gettext-base

RUN mkdir /ld-r
WORKDIR /ld-r

RUN npm install webpack -g

ADD package.json /ld-r/
RUN npm install

ADD . /ld-r
#handle initial configs
RUN if [ ! -e "/ld-r/configs/general.js" ]; then cp /ld-r/configs/general.sample.js /ld-r/configs/general.js ; fi
RUN if [ ! -e "/ld-r/configs/server.js" ]; then cp /ld-r/configs/server.sample.js /ld-r/configs/server.js ; fi
RUN if [ ! -e "/ld-r/configs/reactor.js" ]; then cp /ld-r/configs/reactor.sample.js /ld-r/configs/reactor.js ; fi
RUN if [ ! -e "/ld-r/configs/facets.js" ]; then cp /ld-r/configs/facets.sample.js /ld-r/configs/facets.js ; fi
RUN if [ ! -e "/ld-r/plugins/email/config.js" ]; then cp /ld-r/plugins/email/config.sample.js /ld-r/plugins/email/config.js ; fi

ENV SE="http://somesparqlendpoint" \
    SE_API_KEY= \
    SE_HOST=localhost \
    SE_PORT=8182 \
    SE_PATH=/sparql \
    SE_PROTOCOL=http

RUN cat /ld-r/configs/vars.js.template | envsubst > /ld-r/configs/vars.js

RUN npm run build:nostart

#specify the port used by ld-r app
EXPOSE 4000

ENTRYPOINT ["./entrypoint.sh"]
RUN ["chmod", "+x", "./entrypoint.sh"]
