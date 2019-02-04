FROM node:10.15.1-alpine

ENV APP_USER=hmcts \
  WORKDIR=/opt/app

WORKDIR ${WORKDIR}

RUN addgroup -g 1001 -S $APP_USER \
  && adduser -u 1001 -S $APP_USER -G $APP_USER \
  && chown -R $APP_USER:$APP_USER /opt/app

CMD ["yarn", "start"]
