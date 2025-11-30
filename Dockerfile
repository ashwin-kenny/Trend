# Use official NGINX image
FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy your built React/Vite files
COPY dist/assets /usr/share/nginx/html/assets
COPY dist/index.html /usr/share/nginx/html/index.html
COPY dist/vite.svg /usr/share/nginx/html/vite.svg

# Expose Nginx port
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
