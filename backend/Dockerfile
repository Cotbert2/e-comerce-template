# Multi-stage build for production optimization
FROM node:18-alpine AS development

# Create app directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies)
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

###################
# BUILD FOR PRODUCTION
###################

FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Copy built application from development stage
COPY --from=development /app/dist ./dist

# Install only production dependencies
RUN npm ci --only=production && npm cache clean --force

###################
# PRODUCTION
###################

FROM node:18-alpine AS production

# Install dumb-init for proper signal handling
RUN apk add --no-cache dumb-init

# Create a non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

# Create app directory and set up structure
WORKDIR /app

# Copy files as root first
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package*.json ./
COPY start.sh ./

# Create necessary directories and set proper permissions
RUN mkdir -p /app/src && \
    chmod +x /app/start.sh && \
    chown -R nestjs:nodejs /app && \
    chmod -R 755 /app

# Environment variables (can be overridden by docker-compose)
ENV NODE_ENV=production
ENV PORT=3000
ENV MONGODB_URI=mongodb://localhost:27017/ecommerce_db

# Use the node user from the image (instead of the root user)
USER nestjs

# Expose the port that the app runs on
EXPOSE 3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node --version || exit 1

# Start the server using the initialization script
CMD ["./start.sh"]