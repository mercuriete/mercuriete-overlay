FROM gentoo/stage3:amd64-systemd

# Use binary packages
RUN echo 'FEATURES="getbinpkg binpkg-request-signature"' >> /etc/portage/make.conf

# Install packages for gentoo development
RUN emerge-webrsync
RUN emerge app-admin/sudo
RUN emerge app-portage/gentoolkit
RUN emerge dev-util/pkgcheck
RUN emerge dev-util/pkgdev
RUN USE=npm emerge net-libs/nodejs

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
