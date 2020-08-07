
curl http://shared-file.siyuanketang.com/kafka_2.12-2.3.1.tgz -o kafka_2.12-2.3.1.tgz
tar xvfz kafka_2.12-2.3.1.tgz
cd kafka_2.12-2.3.1

apt update && apt install -y default-jdk

bin/kafka-console-consumer.sh --bootstrap-server host:port --topic topic1 --from-beginning
bin/kafka-consumer-groups.sh --bootstrap-server host:port --list | tee groups.txt
bin/kafka-consumer-groups.sh --bootstrap-server host:port --group group1 --describe

bin/kafka-consumer-groups.sh --zookeeper host:2181,host:2181,host:2181/kafka-staging --topic topic1 list
bin/kafka-consumer-groups.sh --bootstrap-server host:port --list | tee groups.txt
bin/kafka-consumer-groups.sh --bootstrap-server host:port --group group1 --describe
bin/kafka-consumer-groups.sh --help
