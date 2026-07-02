FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV BUN_INSTALL=/root/.bun
ENV PATH="$BUN_INSTALL/bin:$PATH"

RUN apt-get update -qq && \
    apt-get install -y -qq curl git unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://bun.sh/install | bash

WORKDIR /app

RUN git clone https://github.com/youssefvdel/qwen-gate.git /app/qwen-gate

WORKDIR /app/qwen-gate

RUN bun install

COPY start.sh /app/qwen-gate/start.sh

EXPOSE 8080

CMD ["bash", "start.sh"]
