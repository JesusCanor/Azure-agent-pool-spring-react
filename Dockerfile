# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu60 \
    libunwind8 \
    netcat \
    libssl1.0 \
  && rm -rf /var/lib/apt/lists/*

# Install dependencies
RUN apt-get update && \
apt-get install -y git build-essential curl wget software-properties-common zip unzip

#Install Nodejs
RUN apt upgrade 
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -  
RUN apt install -y nodejs
#RUN echo "NODE Version:" && node --version
#RUN echo "NPM Version:" && npm --version


#Install JDK 11 in /opt where maven required
WORKDIR /opt
RUN mkdir java
RUN wget https://builds.openlogic.com/downloadJDK/openlogic-openjdk/11.0.8%2B10/openlogic-openjdk-11.0.8%2B10-linux-x64.tar.gz
RUN tar -xvf openlogic-openjdk-11.0.8+10-linux-x64.tar.gz
RUN rm openlogic-openjdk-11.0.8+10-linux-x64.tar.gz
RUN mv openlogic-openjdk-11.0.8+10-linux-x64/ ./java/jdk-11.0.8+10

#Install maven
RUN apt install maven

#Install Docker into docker This was commented because i was doing the bind mode for docker in docker run command without docker.io.
#If you take a look for docker-compose, you will see the bind mode to docker volumes from your host in order to work with it in your new docker container.
#RUN apt install docker.io -y
#RUN docker --version
#CMD nohup dockerd >/dev/null 2>&1 & sleep 10

RUN curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/*

ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.185.1

WORKDIR /azp
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

COPY ./start.sh .
RUN chmod +x start.sh

ENTRYPOINT [ "./start.sh" ]
