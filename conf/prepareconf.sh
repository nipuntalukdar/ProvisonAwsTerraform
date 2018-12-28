nodeips=`cat /tmp/nodeips`
myip=`cat /tmp/myip`
sed -i "s/{{{LISTEN_ADDRESS}}}/$myip/" /home/ubuntu/cassandraoptions/cassandra.yaml
sed -i "s/{{{SEEDS}}}/$nodeips/" /home/ubuntu/cassandraoptions/cassandra.yaml
cp /home/ubuntu/cassandraoptions/*  /etc/cassandra/
sed -i "s/{{{LISTEN_ADDRESS}}}/$myip/" /home/ubuntu/esoptions/elasticsearch.yml
sed -i "s/{{{SEEDS}}}/$nodeips/" /home/ubuntu/esoptions/elasticsearch.yml
cp /home/ubuntu/esoptions/*  /etc/elasticsearch/
chown -R elasticsearch:elasticsearch /etc/elasticsearch
chown -R cassandra:cassandra /etc/cassandra
