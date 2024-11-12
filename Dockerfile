# Use the official R image from Docker Hub
FROM rocker/r-ver:4.2.3

# Set the working directory inside the container
WORKDIR /usr/local/src/app

# Install system dependencies (for building R packages)
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Plumber package and any other R packages you need
RUN R -e "install.packages('plumber')"

# Copy your code.R file into the container
COPY code.R /usr/local/src/app/code.R

# Expose port 8000 to access the Plumber API
EXPOSE 8000

# Run the Plumber API when the container starts
CMD ["R", "-e", "pr <- plumber::plumb('/usr/local/src/app/code.R'); pr$run(host='0.0.0.0', port=8000)"]
