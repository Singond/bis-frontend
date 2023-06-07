FROM ubuntu:20.04 AS base

RUN mkdir app
WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
 && rm -rf /var/lib/apt/lists/*

# install node
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash

RUN apt-get update && apt-get install -y \
    nodejs \
 && rm -rf /var/lib/apt/lists/*

RUN npm install --global yarn

EXPOSE 3000

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

COPY package.json yarn.lock ./
RUN yarn install
COPY .eslintignore .eslintrc.yml .prettierrc.yml tsconfig.json ./


FROM base AS prod
COPY public/ public/
COPY src/ src/
RUN yarn build
CMD ["docker-entrypoint.sh"]
