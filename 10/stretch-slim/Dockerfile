FROM node:10.15.1-stretch-slim

ENV APP_USER=hmcts \
    WORKDIR=/opt/app

WORKDIR ${WORKDIR}

RUN addgroup --system --gid 1001 $APP_USER \
    && adduser --system --gid 1001 -uid 1001 --disabled-password --disabled-login $APP_USER \
    && chown -R $APP_USER:$APP_USER $WORKDIR

CMD ["yarn", "start"]
