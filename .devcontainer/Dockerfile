FROM gentoo/stage3:amd64-systemd

# Use binary packages
RUN echo 'FEATURES="getbinpkg binpkg-request-signature -ipc-sandbox -network-sandbox -pid-sandbox"' >> /etc/portage/make.conf

# install nodejs with USE=npm
RUN echo 'net-libs/nodejs npm' >> /etc/portage/package.use/nodejs

# install english language as per official Gentoo documentation
RUN echo 'LANG="en_US.UTF-8"' >> /etc/locale.conf && \
    sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

# Install packages for gentoo development
RUN emerge-webrsync
RUN emerge app-admin/sudo \
           app-portage/gentoolkit \
           dev-util/pkgcheck \
           dev-util/pkgdev \
           net-libs/nodejs

# Set up non-root user
ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
WORKDIR /workspace

CMD [ "sleep", "infinity" ]
