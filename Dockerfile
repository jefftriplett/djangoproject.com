# pull official base image
FROM python:3.5-alpine

# set work directory
WORKDIR /usr/src/app

# set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV LIBRARY_PATH=/lib:/usr/lib

RUN apk update \
    && apk add --virtual build-deps gcc python3-dev musl-dev git \
    && apk add postgresql-dev postgresql-client \
        # install node and npm \
        nodejs nodejs-npm \
        # install pillow dependencies \
        build-base python-dev py-pip jpeg-dev zlib-dev \
    && apk del build-deps \
    && pip install --upgrade pip

# install dependencies
COPY ./requirements ./requirements

RUN pip install --no-cache-dir \
    -r ./requirements/tests.txt \
    tox \
    && rm -rf /root/.cache

# TODO: Add back...
# RUN npm install

# copy project
COPY . .

# run docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
