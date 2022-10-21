FROM ubuntu:22.04

ARG RUNNER_VERSION="2.298.2"

RUN apt-get update -y && apt-get upgrade -y && useradd -m docker
    
RUN cd /home/docker && mkdir actions-runner
ADD https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz /home/docker/actions-runner/
RUN cd /home/docker/actions-runner && ls && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
    
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]
