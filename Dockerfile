FROM ubuntu:eoan

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    yes | unminimize && \
    apt-get -y install --no-install-recommends apt-utils dialog 2>&1 && \
    apt-get -y install \
        apt-transport-https \
        bash-completion \
        ca-certificates \
        curl \
        git \
        git-man \
        inetutils-ping \
        inotify-tools \
        ipython3 \
        lsb-release \
        man \
        netcat \
        openssl \
        procps \
        python3 \
        python3-pip \
        software-properties-common \
        sudo \
        tzdata

COPY docker-apt-key.gpg /tmp/
RUN apt-key add /tmp/docker-apt-key.gpg && \
    rm /tmp/docker-apt-key.gpg && \
    apt-key fingerprint 0EBFCD88 && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce-cli

RUN curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose && \
    chmod +x /usr/bin/docker-compose

COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

WORKDIR /root

RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && \
    ~/.bash_it/install.sh --silent && \
    sed -i 's/bobby/nwinkler/g' ~/.bashrc && \
    sed -i 's/SCM_CHECK=true/SCM_CHECK=false/g' ~/.bashrc && \
    echo LANG=C.UTF-8 >> ~/.bashrc && \
    bash -i -c "bash-it enable completion docker docker-compose docker-machine git openshift pip3 system" && \
    bash -i -c "bash-it enable alias general"

ENV DEBIAN_FRONTEND=

ENTRYPOINT [ "/bin/entrypoint.sh" ]
CMD [ "/bin/bash", "-i" ]
