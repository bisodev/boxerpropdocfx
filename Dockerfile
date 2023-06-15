# Start with a base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libicu-dev \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

ADD . /app/boxerpropdocfx

# Change to the cloned repository directory
WORKDIR /app/boxerpropdocfx

# Install docfx
RUN dotnet tool install -g docfx

# Set path variable
ENV PATH="/root/.dotnet/tools:${PATH}"

# Build the DocFX documentation
RUN docfx --version 2.60.0

# Build the DocFX documentation
RUN docfx build docfx.json

# Expose the necessary port for serving the documentation
EXPOSE 8080

ENTRYPOINT []

# Start the docfx server
CMD ["sh", "-c", "/root/.dotnet/tools/docfx serve _site --port 8080"]
