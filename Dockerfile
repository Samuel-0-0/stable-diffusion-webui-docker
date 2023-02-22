FROM nvidia/cuda:12.0.1-base-ubuntu22.04

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

# Install some basic utilities.
RUN apt-get update && apt-get install -y --no-install-recommends \
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
 && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENV HOME=/home/samuel

# Create a non-root user and switch to it.
RUN useradd -u 911 -U -d /config -s /bin/false samuel && \
 usermod -G users samuel && \
 mkdir -p /config $HOME/.cache $HOME/.config $HOME/.pip && \
 echo '[global]' > $HOME/.pip/pip.conf && \
 echo 'index-url = https://pypi.tuna.tsinghua.edu.cn/simple' >> $HOME/.pip/pip.conf && \
 echo '[install]' >> $HOME/.pip/pip.conf \
 echo 'trusted-host=pypi.tuna.tsinghua.edu.cn' >> $HOME/.pip/pip.conf \
 && chmod -R 777 $HOME

COPY --chown=samuel:users entrypoint.sh $HOME

WORKDIR /config

EXPOSE 7860
VOLUME /config

ENTRYPOINT ["/bin/bash","/home/samuel/entrypoint.sh"]

CMD ["/bin/bash","webui.sh"]
