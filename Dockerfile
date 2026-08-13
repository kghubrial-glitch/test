# Use Node.js 22 Alpine
FROM node:22-alpine

# Enable pnpm via corepack
RUN corepack enable

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install dependencies using pnpm
RUN pnpm install --prod --no-frozen-lockfile

# Copy the rest of the application source
COPY . .

# Expose the port
EXPOSE 8080

# Start the server
CMD ["node", "server.js"]
