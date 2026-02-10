FROM node:22-slim

WORKDIR /app

# Install system dependencies and build tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    bash \
    build-essential \
    python3 \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Clone OpenClaw (latest version)
RUN git clone https://github.com/openclaw/openclaw.git .

# Install pnpm
RUN npm install -g pnpm

# Install project dependencies
RUN pnpm install

# Build the project
RUN pnpm ui:build && pnpm build

# Create workspace and config directories
RUN mkdir -p /root/.openclaw/workspace /root/.openclaw

# Copy configuration script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 18789

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["pnpm", "openclaw", "gateway", "--port", "18789"]
