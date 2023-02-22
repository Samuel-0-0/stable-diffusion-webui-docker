FROM nvidia/cuda:12.0.1-base-ubuntu22.04

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

# Install some basic utilities.
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    python3-virtualenv \
    python3-dev \
    libgl1-mesa-glx \
    libglib2.0-dev \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory.
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it.
RUN adduser --disabled-password --gecos '' --shell /bin/bash samuel \
 && chown -R samuel:user /app
RUN echo "samuel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER samuel

# All users can use /home/samuel as their home directory.
ENV HOME=/home/samuel
RUN mkdir $HOME/.cache $HOME/.config \
 && chmod -R 777 $HOME

# Set the default command.
CMD ["/bin/bash"]
