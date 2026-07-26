FROM oven/bun:1-slim

# Install system dependencies needed for CloakBrowser and Playwright Chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxcb1 \
    libxkbcommon0 \
    xdg-utils \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy dependency manifests
COPY package.json bun.lock* ./

# Install npm dependencies
RUN bun install --production

# Copy application files
COPY . .

# Expose server port
EXPOSE 26405

# Run the server
CMD ["bun", "src/index.tsx"]
