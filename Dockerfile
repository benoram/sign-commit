FROM ubuntu:22.04

LABEL maintainer="Ben Oram <b@oram.co>"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    # Install Security Updates 
    apt-get -s dist-upgrade | grep "^Inst" | grep -i securi | awk -F " " {'print $2'} | xargs apt-get install && \
    apt-get install -y --no-install-recommends ca-certificates curl openssh-client git build-essential tini && \
    # Allow ssh access to github 
    mkdir /root/.ssh && \
    ssh-keyscan github.com >> /root/.ssh/known_hosts && \
    # Install Cargo 
    cd ~ && \
    curl https://sh.rustup.rs -sSf > rustup.sh && \
    chmod 755 rustup.sh && \
    ./rustup.sh -y && \  
    rm rustup.sh && \  
    # Install https://github.com/dragonmaus/bpb
    cd ~ && \
    git clone https://github.com/dragonmaus/bpb.git && \
    cd ~/bpb && \
    ~/.cargo/bin/cargo install --path . --locked && \
    # Cleanup
    cd ~ && \
     ~/.cargo/bin/rustup self uninstall -y && \
    apt-get remove -y ca-certificates curl openssh-client git build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

ENTRYPOINT ["/bin/tini", "--", "/root/.cargo/bin/bpb"]
