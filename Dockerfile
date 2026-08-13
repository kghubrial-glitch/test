# ============================================================================
# Nulls Report — Docker edition
# ============================================================================

# ---- Build stage ----
FROM node:22-alpine AS build

# pnpm is required by this repo
RUN corepack enable

WORKDIR /repo

# Copy the entire repository
COPY . .

# Install dependencies
RUN pnpm install --no-frozen-lockfile

# Build the api-server package (using the standard 'build' script)
RUN pnpm --filter @workspace/api-server run build


# ---- Runtime stage ----
FROM node:22-alpine

ENV NODE_ENV=production
ENV PORT=8080

WORKDIR /app

# Docker-edition package metadata
COPY --from=build /repo/editions/docker/package.json /app/package.json

# Bundled production server
COPY --from=build /repo/editions/docker/server.js /app/server.js

# Built frontend
COPY --from=build /repo/artifacts/nulls-report/dist/public /app/dist

EXPOSE 8080

CMD ["node", "server.js"]
