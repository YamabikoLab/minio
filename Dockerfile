FROM ubuntu:22.04

WORKDIR /root

RUN apt-get update \
    && apt-get -y install build-essential procps curl file git \
    && mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew \
    && echo 'eval "$(/root/homebrew/bin/brew shellenv)"' >> $HOME/.bashrc && eval "$(/root/homebrew/bin/brew shellenv)" \
    && brew update --force --quiet \
    && chmod -R go-w "$(brew --prefix)/share/zsh" \
    && brew install minio/stable/minio

RUN curl -o certgen -L  https://github.com/minio/certgen/releases/download/v1.2.0/certgen-linux-amd64 && chmod +x /root/certgen \
    && /root/certgen -host "127.0.0.1,localhost"  && mkdir -p /root/.minio/certs && mv /root/public.crt /root/.minio/certs/ && mv /root/private.key /root/.minio/certs/

EXPOSE 9000 9001