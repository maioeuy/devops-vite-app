# --- Stage 1: Build the React Application ---
    # Use a Node.js base image for building your React app.
    # 'AS builder' names this stage so we can reference it later.
    FROM node:20-alpine AS builder

    # Set the working directory inside the container for this stage.
    WORKDIR /app

    # Copy package.json and package-lock.json first.
    # This allows Docker to cache the npm install step if these files don't change,
    # speeding up subsequent builds.
    COPY package.json package-lock.json ./

    # Install Node.js dependencies.
    RUN npm install

    # Copy the rest of your application's source code.
    COPY . .

    # Build the React application for production.
    # This runs the 'build' script defined in your package.json (e.g., 'vite build').
    # This will create optimized static assets, typically in a 'dist' folder.
    RUN npm run build

    # --- Stage 2: Serve with Nginx ---
    # Use a lightweight Nginx base image for serving the static files.
    FROM nginx:alpine

    # Remove the default Nginx static assets to prepare for your app's files.
    RUN rm -rf /usr/share/nginx/html/*

    # Copy the built application from the 'builder' stage to Nginx's static files directory.
    # The '--from=builder' flag is crucial here to copy from the previous stage.
    # Assumes 'npm run build' outputs to a 'dist' folder inside /app.
    COPY --from=builder /app/dist /usr/share/nginx/html

    # Expose port 80, which is the default port Nginx listens on for HTTP traffic.
    EXPOSE 80

    # Command to start Nginx in the foreground.
    # 'daemon off;' ensures Nginx runs in the foreground,
    # which is necessary for Docker containers to keep running.
    CMD ["nginx", "-g", "daemon off;"]