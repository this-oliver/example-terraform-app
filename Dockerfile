ARG NODE_VERSION=18.19.0
FROM node:${NODE_VERSION}

# create the server directory
WORKDIR /server

# setup pnpm
ARG PNPM_VERSION=8.15.1
RUN npm install -g pnpm@${PNPM_VERSION}

# install dependencies
COPY package.json .
COPY pnpm-lock.yaml .
RUN pnpm install

# copy source code
COPY . .

# expose the port
EXPOSE 3000

# run the server
CMD ["pnpm", "start"]
