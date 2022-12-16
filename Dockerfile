FROM birdyb/nuclos_arm:latest
ENV DB_HOST="nuclos-db"
ENV DB_PORT="5432"
ENV DB_DATABASE="nuclosdb"
ENV DB_USER="nuclos"
ENV DB_PASSWORD="password"

EXPOSE 22

EXPOSE 8080

RUN apt-get update
RUN apt-get install ssh nano -y

RUN sed -i 's|"postgres"|"$DB_HOST"|' /usr/local/bin/nuclos-config.sh
RUN sed -i 's|"$POSTGRES_PORT_5432_TCP_PORT"|"$DB_PORT"|' /usr/local/bin/nuclos-config.sh
RUN sed -i 's|"$POSTGRES_ENV_POSTGRES_DB"|"$DB_DATABASE"|' /usr/local/bin/nuclos-config.sh
RUN sed -i 's|"$POSTGRES_ENV_POSTGRES_USER"|"$DB_USER"|' /usr/local/bin/nuclos-config.sh
RUN sed -i 's|"$POSTGRES_ENV_DB_PASSWORD"|"$DB_PASSWORD"|' /usr/local/bin/nuclos-config.sh
RUN sed -i 's/|<Connector\.\*\/>|/&<Connector address="0\.0\.0\.0" port="8009" protocol="AJP\/1\.3" redirectPort="8443" secretRequired="false"\/>/' /usr/local/bin/nuclos-config.sh

RUN sed -i '2 i /usr/sbin/service ssh start' /usr/local/bin/docker-run.sh

RUN chown devel:nuclos /home/devel

RUN useradd -rm -d /home/devel -s /bin/bash -g root -G sudo -G nuclos -u 1001 devel -p "$(openssl passwd -1 nuclos)"

RUN chmod -R 775 /opt/nuclos/home/data/codegenerator
