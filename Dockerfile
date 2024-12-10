# Use the official Node.js 18 image as a parent image
FROM node:18

# Install latest Chrome dev package and fonts to support major charsets
RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 \
       libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libxcomposite1 libxrandr2 libxdamage1 libfontconfig1 libx11-xcb1 \
       libxcb-dri3-0 libxkbcommon0 libwayland-client0 libwayland-cursor0 libwayland-egl1 libdbus-glib-1-2 \
       --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Verify Chrome installation (optional for debugging)
RUN google-chrome-stable --version

# Set the working directory
WORKDIR /usr/src/app

# Copy and install dependencies
COPY package*.json ./
COPY .puppeteerrc.cjs ./
RUN npm install

# Install Puppeteer-specific browsers
RUN npx puppeteer browsers install chrome

# Copy application source code
COPY . .

# Build TypeScript code
RUN npm run build

# Copy additional folders to the build folder
RUN cp -r ./src/prod_config ./dist/src/prod_config

# Expose port (optional)
EXPOSE 8080

# Start the production server
CMD ["npm", "run", "start:dist"]