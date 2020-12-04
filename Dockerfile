FROM php:7.4-apache
LABEL Description="Ubuntu for Bitbucket Pipelines CI/CD" \
    Maintainer="Hendrik Prinsloo <hendrik.prinsloo@clevva.com>"\
	License="Apache License 2.0" \
	Version="1.0"

# Args
ARG VERSION_NODE=14
ARG VERSION_SENCHA=7.3.0.19

# Classic update
RUN apt-get update -qy

# Install common packages
RUN apt-get install -qfy \
    zip \
    unzip \
    git \
    nodejs \
    npm \
    nano \
    tree \
    vim \
    curl \
    ftp \
    default-mysql-client \
    software-properties-common \
    build-essential

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node & npm
RUN curl -sL https://deb.nodesource.com/setup_${VERSION_NODE}.x | bash - \
    && apt-get install -qfy nodejs

# JRE (BUG)
# - See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199#23
RUN mkdir -p /usr/share/man/man1

# JRE (required for Sencha Ext)
RUN set -x \
    && apt-get update -qy \
    && apt-get install --no-install-recommends -qfy default-jre

# Sencha Ext
RUN curl -o /cmd.run.zip http://cdn.sencha.com/cmd/${VERSION_SENCHA}/no-jre/SenchaCmd-${VERSION_SENCHA}-linux-amd64.sh.zip && \
    unzip -p /cmd.run.zip > /cmd-install.run && \
    chmod +x /cmd-install.run && \
    /cmd-install.run -q -dir /opt/Sencha/Cmd/${VERSION_SENCHA} && \
    rm /cmd-install.run /cmd.run.zip

ENV PATH="/opt/Sencha/Cmd:$PATH"

# Clean & autoremove
RUN apt-get autoclean -qy && apt-get clean -qy && apt-get autoremove -qy

# Starting script
COPY start.sh /usr/sbin/
RUN chmod +x /usr/sbin/start.sh

# Volumes
mkdir -p /var/www/html/clevva
VOLUME /var/www/html/clevva

# Ports
EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/start.sh"]
