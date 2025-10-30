# Debian (bookworm) slim base
FROM debian:bookworm-slim

# Make noninteractive apt and reduce layer size
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
     && apt-get install -y --no-install-recommends \
    ca-certificates curl bash git gnupg \
     && rm -rf /var/lib/apt/lists/* \
     && update-ca-certificates

# --- Install cloudflared from Cloudflare APT repo ---
# (official instructions)
RUN mkdir -p --mode=0755 /usr/share/keyrings \
    && curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg \
    | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null \
    && echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' \
    | tee /etc/apt/sources.list.d/cloudflared.list \
     && apt-get update \
     && apt-get install -y --no-install-recommends cloudflared \
     && rm -rf /var/lib/apt/lists/*

# --- Install Node.js directly (simpler and more reliable) ---
# Install Node.js 22 LTS directly from NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Verify Node.js installation
RUN node --version && npm --version

# Sanity check layer (optional; you can remove to slim further)
RUN node -v && npm -v && cloudflared --version

WORKDIR /app

# Default command: print versions (override in your image)
CMD ["/bin/bash", "-c", "echo Node: $(node -v); echo NPM: $(npm -v); cloudflared --version"]

