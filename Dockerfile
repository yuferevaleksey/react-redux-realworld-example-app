FROM node:14.17.1-alpine as builder
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
ARG BACKEND_URL $BACKEND_URL
COPY package-lock.json ./
COPY package.json ./
RUN npm ci --silent
COPY . ./
RUN REACT_APP_BACKEND_URL=$BACKEND_URL npm run build

# production
FROM nginx:stable-alpine
COPY --from=builder /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
