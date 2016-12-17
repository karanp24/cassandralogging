FROM cassandra:3.9


COPY jolokia-jvm-1.3.2-agent.jar /usr/share/cassandra/lib/

RUN echo "JVM_OPTS=\"\$JVM_OPTS -javaagent:/usr/share/cassandra/lib/jolokia-jvm-1.3.2-agent.jar=port=8778,host=0.0.0.0\"" >> /etc/cassandra/cassandra-env.sh

RUN apt-get update && apt-get install -qy telnet sudo net-tools vim  && apt-get install -qqy curl && apt-get install -y wget && apt-get install -qqy apt-transport-https \
    && rm -r /var/lib/apt/lists/*
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-5.x.list
RUN apt-get update && apt-get install filebeat && apt-get clean
RUN sudo update-rc.d filebeat defaults 95 10
ADD filebeat.yml /etc/filebeat/filebeat.yml
RUN mkdir /var/lib/filebeat
RUN chmod 777 /var/lib/filebeat
RUN echo "/etc/init.d/filebeat start" >> /etc/cassandra/cassandra-env.sh

EXPOSE 8778 8000 9499
