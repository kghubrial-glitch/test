# ============================================================================
# Nulls Report — Docker edition
# ============================================================================

# ---- Build stage ----
FROM node:22-alpine AS build

# pnpm is required by this repo
RUN corepack enable

WORKDIR /repo

# Copy package manifests first for better caching
COPY package.json pnpm-workspace.yaml ./
COPY artifacts ./artifacts
COPY editions ./editions
COPY packages ./packages

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Build all workspace packages first
RUN pnpm -r --if-present run build

# Now build the Docker edition specifically
RUN pnpm --filter @workspace/api-server run build:docker-edition || \
    pnpm --filter api-server run build:docker-edition || \
    (echo "Failed to build Docker edition" && exit 1)

# ---- Runtime stage ----
FROM node:22-alpine

ENV NODE_ENV=production
ENV PORT=8080

WORKDIR /app

# Copy package metadata
COPY --from=build /repo/editions/docker/package.json /app/package.json

# Copy the bundled server
COPY --from=build /repo/editions/docker/server.js /app/server.js

# Copy built frontend assets if they exist
COPY --from=build /repo/artifacts/nulls-report/dist/public /app/dist

EXPOSE 8080

CMD ["node", "server.js"]
