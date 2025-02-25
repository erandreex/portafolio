# Usa una imagen base de Node.js para construir la aplicación
FROM node:22-alpine3.20 AS builder

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de configuración del proyecto
COPY package.json package-lock.json ./

# Instala las dependencias del proyecto
RUN npm install

# Copia el resto de los archivos del proyecto
COPY . .

# Construye el proyecto de Astro
RUN npm run build

# Usa una imagen base de Nginx para servir la aplicación
FROM nginx:1.27.4

# Copia los archivos construidos desde la etapa de construcción
COPY --from=builder /app/dist /usr/share/nginx/html

# Copia la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Copia los certificados SSL (asegúrate de tener estos archivos en tu proyecto)
COPY certificate.crt /etc/nginx/ssl/certificate.crt
COPY private.key /etc/nginx/ssl/private.key

# Expone el puerto 80 (HTTP) y 443 (HTTPS)
EXPOSE 80
EXPOSE 443

# Comando para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]