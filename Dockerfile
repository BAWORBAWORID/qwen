FROM oven/bun:1-slim

# Install system dependencies needed for CloakBrowser and Playwright Chromium
# Auto-accept EULA for mscorefonts to prevent interactive prompt hanging during build
RUN echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections && \
    apt-get update && apt-get install -y --no-install-recommends \
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
    fontconfig \
    ttf-mscorefonts-installer \
    && fc-cache -f -v \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENV HOST=0.0.0.0
ENV PORT=26405
ENV CLOAKBROWSER_SUPPRESS_FONT_WARNING=1

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
