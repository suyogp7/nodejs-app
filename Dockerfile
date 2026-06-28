# Use official Node.js image
FROM node:18

# Set working directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy application source
COPY . .

# Expose port and start app
EXPOSE 3000
CMD ["npm", "start"]
