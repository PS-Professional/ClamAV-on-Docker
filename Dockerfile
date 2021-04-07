FROM ubuntu
#Install requires
RUN apt-get update && apt-get upgrade -y && apt-get install -y clamav \
	clamav-daemon \
	clamav-base \
	clamav-freshclam \
	clamdscan
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
#Update virus database for first time and copy samples
COPY test-clam /test-clam
RUN freshclam
#Set EntryPoint
COPY scripts/clam-start.sh /usr/bin/clam-start
COPY scripts/clam-test.sh /usr/bin/clam-test
COPY scripts/clamer.sh /usr/bin/clamer
RUN chmod 755 /usr/bin/clamer
RUN chmod 755 /usr/bin/clam-start
RUN chmod 755 /usr/bin/clam-test
EXPOSE 3310
ENTRYPOINT ["clam-start"]
