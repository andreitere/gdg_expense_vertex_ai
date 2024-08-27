FROM ghcr.io/cirruslabs/flutter:3.24.1 as build


# Set the working directory inside the container
WORKDIR /app

# Copy the pubspec and pubspec.lock files to the container
COPY pubspec.* ./

# Fetch Flutter dependencies
RUN flutter pub get

# Copy the rest of the application code
COPY . .

RUN rm -rf "./build/web"

# Build the Flutter web app
RUN flutter build web --release

# Use the Nginx base image to serve the built app
FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy your Nginx configuration file to the container
COPY nginx.conf /etc/nginx/conf.d

# Copy the built Flutter web files to Nginx's web directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]