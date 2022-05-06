#!/bin/zsh
if [ -n "$3" ]
then
    docker run --rm -i -v /Users/boram/.bpb_keys.toml:/root/.bpb_keys.toml sign-commit "$1" "$2" "$3" 
else
    docker run --rm -i -v /Users/boram/.bpb_keys.toml:/root/.bpb_keys.toml sign-commit
fi
