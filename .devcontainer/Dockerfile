# Use Python 3.12 with Debian slim, then install Node.js
FROM python:3.12-slim

# Install Node.js 20.x (from NodeSource)
RUN apt-get update \
 && apt-get install -y curl ca-certificates \
 && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
 && apt-get install -y nodejs \
 && rm -rf /var/lib/apt/lists/*

# 1. Set working directory
WORKDIR /usr/src/app

# 2. Install curl & tar (for GitHub CLI) and clean up apt cache
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      curl \
      tar \
 && rm -rf /var/lib/apt/lists/*

# Add GitHub CLI repo and key
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
 && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo \
    "deb [arch=$(dpkg --print-architecture) \
         signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
     https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
 && apt-get update \
 && apt-get install -y gh \
 && rm -rf /var/lib/apt/lists/*

# 4. Copy only package.json first (for layer caching)
COPY frontend/package.json ./

# 5. Configure npm for retry logic & install dependencies
RUN npm config set fetch-retries 5 \
 && npm config set fetch-retry-maxtimeout 120000 \
 && npm install --ignore-scripts --no-audit

# Copy uv from the official distroless Docker image
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy your requirements.txt first (this is to cache dependencies installation)
COPY requirements.txt /tmp/requirements.txt

# Install dependencies
RUN pip install --upgrade pip && \
    uv pip install --system -r /tmp/requirements.txt

# 6. Copy the rest of your app
COPY . .

# 7. Fix permissions and switch to non-root user
RUN chown -R root:root /usr/src/app

# 8. Expose React dev server port and start
EXPOSE 3000
CMD ["npm", "start"]
