FROM alpine:latest

RUN apk add --no-cache openssh openssh-server-pam
RUN mkdir /var/run/sshd

RUN sed -i 's/^[#]*PermitRootLogin.*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
RUN sed -i 's/^[#]*AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
RUN sed -i 's/^[#]*UseDNS.*/UseDNS no/' /etc/ssh/sshd_config
RUN sed -i 's/^[#]*UsePAM.*/UsePAM yes/' /etc/ssh/sshd_config
RUN sed -i 's/^[#]*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config

RUN mkdir -p /root/.ssh

ADD entrypoint.sh /usr/local/sbin/

EXPOSE 22
ENTRYPOINT ["entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]