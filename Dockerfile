FROM ubuntu:22.04

WORKDIR /app

ENV HOST=0.0.0.0
ENV PORT=26405
ENV CLOAKBROWSER_LICENSE_KEY=cb_d1d46e45921a46b79f68d31ed787d325
ENV CLOAKBROWSER_SUPPRESS_FONT_WARNING=1
ENV DISPLAY=:99
ENV BUN_INSTALL=/usr/local
ENV PATH="$BUN_INSTALL/bin:$PATH"

# Install basic tools and Bun
RUN apt-get update && apt-get install -y curl unzip tar ca-certificates && \
    curl -fsSL https://bun.sh/install | bash && \
    rm -rf /var/lib/apt/lists/*

# Copy dependency manifests
COPY package.json bun.lock* ./

# Install npm dependencies
RUN bun install

# Install Playwright Chromium and all required system dependencies (including xvfb)
RUN apt-get update && \
    bunx playwright install chromium --with-deps && \
    rm -rf /var/lib/apt/lists/*

# Copy application files
COPY . .

# Expose server port
EXPOSE 26405

# Run Xvfb in the background, then run the bun server
CMD sh -c "Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset & bun src/index.tsx"
