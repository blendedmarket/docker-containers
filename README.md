# Cloudflare Tunnel Docker Setup

This project provides multiple ways to run Cloudflare Tunnel (cloudflared) with Node.js for easy tunnel management and development.

## 🚀 Main Methods: Docker Compose (Recommended)

Choose your preferred base image:

### Option 1: Debian-based (docker-compose.yml)
The **docker-compose.yml** uses Debian Bookworm Slim - stable and reliable.

### Option 2: Alpine-based (docker-compose-alpine.yml) 
The **docker-compose-alpine.yml** uses Alpine Linux - smaller and faster (~5MB vs ~80MB base image).

### Prerequisites

- Docker and Docker Compose installed
- Cloudflare account (for tunnel authentication)

### Quick Start

**Debian-based (recommended for stability):**
```bash
# Run interactively - dependencies install automatically on first run
docker compose run --rm tunnel
```

**Alpine-based (recommended for speed/size):**
```bash
# Run interactively with Alpine Linux
docker compose -f docker-compose-alpine.yml run --rm tunnel

# Then inside the container, run:
cloudflared tunnel --url http://localhost:3000
```

**Note:** The first run will take a few minutes as it installs cloudflared and Node.js. Subsequent runs will be much faster.

### Alpine vs Debian Comparison

| Feature | Alpine (docker-compose-alpine.yml) | Debian (docker-compose.yml) |
|---------|-----------------------------------|----------------------------|
| **Base Image Size** | ~5MB | ~80MB |
| **Package Manager** | `apk` | `apt` |
| **Startup Speed** | Faster | Slower |
| **Stability** | Good | Excellent |
| **Package Availability** | Good | Excellent |
| **Best For** | Development, CI/CD | Production, complex apps |

### 2. Quick Tunnel Commands

Once inside the container, you can run various cloudflared commands:

```bash
# Quick tunnel to localhost:3000
cloudflared tunnel --url http://localhost:3000

# Quick tunnel to any local service
cloudflared tunnel --url http://localhost:8080

# Login to Cloudflare (for persistent tunnels)
cloudflared tunnel login

# Create a new tunnel
cloudflared tunnel create my-tunnel

# Run a named tunnel
cloudflared tunnel run my-tunnel
```

## Usage Examples

### Interactive Development

```bash
# Start interactive session
docker compose run --rm tunnel

# Inside container, test cloudflared
cloudflared --version
node --version
npm --version

# Run a quick tunnel
cloudflared tunnel --url http://localhost:3000
```

### One-time Tunnel

```bash
# Run a quick tunnel directly (no interactive shell)
docker compose run --rm tunnel cloudflared tunnel --url http://localhost:3000
```

### Persistent Tunnel Setup

```bash
# Start interactive session
docker compose run --rm tunnel

# Login to Cloudflare
cloudflared tunnel login

# Create a tunnel
cloudflared tunnel create my-app-tunnel

# Configure the tunnel (optional)
cloudflared tunnel ingress create my-app-tunnel

# Run the tunnel
cloudflared tunnel run my-app-tunnel
```

## Environment Variables

You can customize the tunnel behavior by modifying the `docker-compose.yml`:

```yaml
environment:
  - TUNNEL_MODE=quick          # or 'persistent'
  - TUNNEL_URL=http://localhost:3000
```

## Volume Mounts

- `.:/app` - Mounts current directory to `/app` in container
- `/var/run/docker.sock:/var/run/docker.sock` - Optional Docker socket access

## Troubleshooting

### Missing Files Error

If you get errors about missing `start.sh` or `tunnel-config.yml`, this docker-compose setup bypasses those by overriding the command to use `/bin/bash` directly.

### Permission Issues

```bash
# If you get permission errors, try:
docker compose run --rm --user root tunnel
```

### Network Issues

```bash
# If you need to access host services from container:
docker compose run --rm --network host tunnel
```

## Advanced Usage

### Custom Cloudflared Commands

```bash
# Run with custom configuration
docker compose run --rm tunnel cloudflared tunnel --config /path/to/config.yml

# Run with specific tunnel ID
docker compose run --rm tunnel cloudflared tunnel run <tunnel-id>

# Run with custom ingress rules
docker compose run --rm tunnel cloudflared tunnel ingress create <tunnel-name>
```

### Development Workflow

1. **Start interactive session:**
   ```bash
   docker compose run --rm tunnel
   ```

2. **Test your local service:**
   ```bash
   # In another terminal, start your app on localhost:3000
   npm start
   ```

3. **Create tunnel:**
   ```bash
   # Back in container
   cloudflared tunnel --url http://localhost:3000
   ```

4. **Access via tunnel URL** (provided by cloudflared output)

## Cleanup

```bash
# Stop all containers
docker compose down

# Remove built images
docker compose down --rmi all

# Clean up everything
docker system prune -a
```

## What's Included

- **Base OS:** Debian Bookworm Slim
- **Cloudflared:** Latest version from Cloudflare APT repository
- **Node.js:** Version 22 LTS
- **Additional tools:** curl, git, gnupg, ca-certificates

## Notes

- The container runs as root by default for simplicity
- Tunnel credentials are stored in `~/.cloudflared/` (mounted via volume)
- For production use, consider creating a non-root user and proper credential management

---

## 📁 Other Files in This Project

### Dockerfile
**Purpose:** Clean Docker build with cloudflared + Node.js (no missing files)
**Usage:** Traditional Docker build approach
**Status:** ✅ Works perfectly - just prints versions by default

```bash
# Build and run:
docker build -f Dockerfile -t tunnel-container .
docker run -it --rm tunnel-container

# Or override command for interactive use:
docker run -it --rm tunnel-container /bin/bash
```

### Why Docker Compose is Better

- ✅ **No missing files** - Everything installs at runtime
- ✅ **No build step** - Faster iteration
- ✅ **Interactive by default** - Perfect for development
- ✅ **Volume mounting** - Easy file sharing with host
- ✅ **Environment management** - Built-in env var handling
