FROM fedora:38
WORKDIR /root

# Make UID and GID customizable
ARG USER=lab
ARG GROUP=lab
ARG PASSWORD=lab
ARG USER_ID=1000
ARG GROUP_ID=1000

# Basic set of tools
RUN yum -y install \
    @development-tools \
    @c-development

# Linux git repository
RUN git init linux
RUN git -C linux remote add stable \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
RUN git -C linux fetch --depth 1 stable linux-6.6.y
RUN git -C linux checkout FETCH_HEAD

# Additional tools
RUN yum -y install \
    vim \
    fedpkg

# ARM Linux source
RUN curl -O \
    https://kojipkgs.fedoraproject.org//packages/kernel/6.8.8/300.fc40/aarch64/kernel-core-6.8.8-300.fc40.aarch64.rpm
RUN rpmdev-extract kernel-core-6.8.8-300.fc40.aarch64.rpm

# Add packages required by Yocto
RUN yum -y install \
    glibc-all-langpacks \
    chrpath hostname lz4 rpcgen wget \
    python3-websockets \
    perl \
    tmux

# Yocto requires a non-root user
RUN groupadd -g ${GROUP_ID} ${GROUP} &&\
    useradd -m -u ${USER_ID} -g ${GROUP} -s /bin/bash ${USER} -G wheel && \
    echo "${USER}:${PASSWORD}" | chpasswd

USER ${USER}
WORKDIR /home/${USER}
