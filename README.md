# docker.bpb

A simple docker container for running [bpb](https://github.com/dragonmaus/bpb) for code signing.

## Setup your macine

### Build the container image

I haven't yet published this to Docker Hub. So be sure to build this locally.

```zsh
./build.sh
```

### Generate keys

You will also need a PGP public key and secret. This container can be used to generate this for you.

Start a shell using this image

```zsh
docker run -it sign-commit bash
```

While instide the container, generate the keys

```zsh
bpb init "Your Name <your@email.domain>" > /dev/null
cat ~/.bpb_keys.toml
```

Copy the text from the ~/.bpb_keys.toml file to a file with the same path on your local machine.

### Put the sign-commit script into your path

Copy the sign-commit.sh file to your /usr/local/bin directory, drop the sh extension and set it to executable

```zsh
cp ./sign-commit.sh /usr/local/bin/sign-commit
chmod +x /usr/local/bin/sign-commit
```

### Configure git

Make sure your user.name and user.email match what you used when generating your keys above.

```zsh
git config --global user.name "Your Name"
git config --global user.email "your@email.domain"
git config --global gpg.program "sign-commit"
git config --global commit.gpgsign true
```
