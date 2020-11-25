FROM ubuntu:18.04

MAINTAINER FOR_EVERY_ONE

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    curl apt-utils apt-transport-https \
    git \
    python3.7 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    nginx \
    supervisor \
    mysql-client \
    libmysqlclient-dev \
    unixodbc-dev \
    sqlite3 \
    locales && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install -U pip setuptools
RUN apt-get install python3-setuptools

ADD requirements/requirements.txt /project/

RUN pip install -r /project/requirements.txt

ADD . /project/

ARG SERVICE_ARG=development
ENV DJANGO_SETTINGS_MODULE=django_gunicorn.settings.$SERVICE_ARG
ENV SERVICE_ENV=$SERVICE_ARG

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY nginx-app.conf /etc/nginx/sites-available/default
COPY supervisor-app-staging.conf /etc/supervisor/conf.d/

EXPOSE 80
EXPOSE 443

WORKDIR /project/django_gunicorn
CMD ["supervisord", "-n"]
