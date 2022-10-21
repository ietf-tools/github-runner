FROM ubuntu:22.04

ARG RUNNER_VERSION="2.298.2"

RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq ca-certificates gnupg lsb-release build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip
    
# Install Docker CLI
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin

# Download Runner
RUN cd /home/docker && mkdir actions-runner
ADD https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz /home/docker/actions-runner/
RUN cd /home/docker/actions-runner && ls && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
    
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x start.sh

USER docker

ENTRYPOINT ["./start.sh"]
