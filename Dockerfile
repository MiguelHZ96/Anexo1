FROM nginx:alpine
COPY ./sitio /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
