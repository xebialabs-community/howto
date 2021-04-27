from xebialabs/xl-deploy:10.0 as installer
MAINTAINER Rick Broker "rbroker@digital.ai"
user root

RUN apt-get -y install git
RUN curl -LO https://releases.hashicorp.com/terraform/0.14.10/terraform_0.14.10_linux_amd64.zip && \
    unzip terraform_*_linux_amd64.zip && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform_*_linux_amd64.zip

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

user xebialabs
