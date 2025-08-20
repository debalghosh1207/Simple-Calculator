FROM ubuntu:20.04

# Set non-interactive frontend to avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Update and install g++, cmake, and other necessary tools
RUN apt-get update && apt-get install -y \
    g++ \
    cmake \
    make \
    && rm -rf /var/lib/apt/lists/*

COPY . ./ghap

# Set working directory
WORKDIR /ghap/build

# Command to run
RUN cmake . && make

RUN echo "Binary built"


CMD ["/bin/bash"]

ENTRYPOINT []
