FROM ubuntu:16.04

ENV LC_ALL C.UTF-8	
ENV TZ=America/New_York	
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN set -x \
    && apt-get update \
    && apt-get install -y python python-dev python-pip python-setuptools hydra wget alien curl apt-transport-https \
    && python -m pip install pip==9.0.3 \
    && wget https://nmap.org/dist/nmap-7.70-1.x86_64.rpm \
    && alien nmap-7.70-1.x86_64.rpm \
    && dpkg --install nmap_7.70-2_amd64.deb

RUN set -x \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 \
    && echo "deb https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.6.list \
    && apt-get update \
    && apt-get install -y mongodb-org

RUN mkdir -p /opt/fuxi
COPY . /opt/fuxi

RUN set -x \
    && pip install -r /opt/fuxi/requirements.txt

WORKDIR /opt/fuxi

VOLUME ["/data"]

ENTRYPOINT ["/opt/fuxi/migration/docker_start.sh"]

EXPOSE 5000
