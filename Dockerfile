# Build stage
FROM oven/bun:1 as build-stage

WORKDIR /app

# Copy package.json and lockfile
COPY package.json bun.lock ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy project files
COPY . .

# Build the application
RUN bun run build

# Production stage
FROM nginx:alpine as production-stage

# Copy the built application from the build stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Copy custom nginx config for SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
