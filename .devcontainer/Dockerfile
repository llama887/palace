# syntax=docker/dockerfile:1.7
FROM node:20-bullseye

# 1. Set working directory
WORKDIR /usr/src/app

# 2. Install curl & tar (for GitHub CLI) and clean up apt cache
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      tar \
 && rm -rf /var/lib/apt/lists/*

# 3. Install GitHub CLI via official tarball (avoids apt timeouts)
ARG GH_VERSION=2.73.0
RUN ARCH=$(dpkg --print-architecture) \
 && curl -fsSL https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${ARCH}.tar.gz \
      -o gh.tar.gz \
 && mkdir gh-cli \
 && tar -xzf gh.tar.gz -C gh-cli --strip-components=1 \
 && mv gh-cli/bin/gh /usr/local/bin/gh \
 && rm -rf gh.tar.gz gh-cli

# 4. Copy only package.json first (for layer caching)
COPY frontend/package.json ./

# 5. Configure npm for retry logic & install dependencies
RUN npm config set fetch-retries 5 \
 && npm config set fetch-retry-maxtimeout 120000 \
 && npm install --ignore-scripts --no-audit

# 6. Copy the rest of your app
COPY . .

# 7. Fix permissions and switch to non-root user
RUN chown -R node:node /usr/src/app
USER node

# 8. Expose React dev server port and start
Expose 3000
CMD ["npm", "start"]
