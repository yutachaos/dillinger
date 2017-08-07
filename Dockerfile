FROM nodesource/nsolid:boron-2.1.0

LABEL maintainer "Joe McCann <joe@nodesource.com>"

# Install our dependencies (libfontconfig for phantomjs)
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      ca-certificates \
      curl \
      unzip \
      fontconfig \
      git \
      libfontconfig \
      python-software-properties \
    && rm -rf /var/lib/apt/lists/*

# install to Noto fonts
RUN mkdir noto && \
    curl -O -L https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip && \
    unzip NotoSansCJKjp-hinted.zip -d ./noto && \
    sudo mkdir -p /usr/share/fonts/noto && \
    sudo cp ./noto/*.otf /usr/share/fonts/noto/ && \
    sudo chmod 644 /usr/share/fonts/noto/*.otf && \
    sudo fc-cache -fv
# this is faster via npm run build-docker
COPY package.json ./package.json
RUN npm install \
    && npm cache clean

# Copy source over and create configs dir
COPY . .
RUN mkdir -p /configs

EXPOSE 8080
ENV NODE_ENV=production

CMD ["npm", "start"]
