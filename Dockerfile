FROM ubuntu:22.04

LABEL maintainer="Ben Oram <b@oram.co>"

ARG DEBIAN_FRONTEND=noninteractive

# Install security update
RUN apt-get update && \
    apt-get -s dist-upgrade | grep "^Inst" | grep -i securi | awk -F " " {'print $2'} | xargs apt-get install 
    
# Install tools
RUN apt-get install -y ca-certificates curl openssh-client git build-essential tini

# Init known_hosts with github.com
RUN mkdir /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts

# Install Cargo
RUN cd ~ && \
    curl https://sh.rustup.rs -sSf > rustup.sh && \
    chmod 755 rustup.sh && \
    ./rustup.sh -y && \
    rm rustup.sh

## Install https://github.com/dragonmaus/bpb
RUN cd ~ && \
    git clone https://github.com/dragonmaus/bpb.git && \
    cd ~/bpb && \
    ~/.cargo/bin/cargo install --path . --locked 

ENTRYPOINT ["/bin/tini", "--", "/root/.cargo/bin/bpb"]
