# Use the official lightweight Nginx image to serve static web content
FROM nginx:alpine

# Clean out any default template files sitting inside the web directory
RUN rm -rf /usr/share/nginx/html/*

# Copy your local static frontend assets directly into the web server directory
COPY . /usr/share/nginx/html/

# Expose port 80 so the web page can be reached from the internet
EXPOSE 80

# Start the Nginx web server engine in the foreground
CMD ["nginx", "-g", "daemon off;"]
