# Use Node.js 22 Alpine
FROM node:22-alpine

# Set environment variables
ENV NODE_ENV=production
ENV PORT=8080

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json (if exists)
COPY package*.json ./

# Install dependencies (using npm; if you use pnpm, change to pnpm install)
RUN npm install --production

# Copy the rest of the application source
COPY . .

# Expose the port
EXPOSE 8080

# Start the server
CMD ["node", "server.js"]
