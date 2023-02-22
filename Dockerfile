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
    python3-venv \
    python3-dev \
    libgl1-mesa-glx \
    libglib2.0-dev \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory.
RUN mkdir -p /app/stable-diffusion-webui
WORKDIR /app/stable-diffusion-webui

# Create a non-root user and switch to it.
RUN adduser --disabled-password --gecos '' --shell /bin/bash samuel \
 && chown -R samuel:samuel /app \
 && echo "samuel ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-samuel
USER samuel

# All users can use /home/samuel as their home directory.
ENV HOME=/home/samuel
COPY entrypoint.sh $HOME
RUN mkdir $HOME/.cache $HOME/.config $HOME/.pip \
 && echo '[global]' > $HOME/.pip/pip.conf \
 && echo 'index-url = https://pypi.tuna.tsinghua.edu.cn/simple' >> $HOME/.pip/pip.conf \
 && echo '[install]' >> $HOME/.pip/pip.conf \
 && echo 'trusted-host=pypi.tuna.tsinghua.edu.cn' >> $HOME/.pip/pip.conf \
 && chmod -R 777 $HOME

WORKDIR $HOME/stable-diffusion-webui

# Exposed Ports
EXPOSE 7860

ENTRYPOINT ["/home/samuel/entrypoint.sh"]
# Set the default command.
CMD ["/bin/bash","webui.sh"]
