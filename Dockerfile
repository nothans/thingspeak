FROM ruby:2.1

# Fix archived Debian repos (Jessie is EOL)
RUN sed -i 's/httpredir\.debian\.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/deb\.debian\.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's|security\.debian\.org|archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    sed -i '/jessie-updates/d' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Install system dependencies
RUN apt-get update && apt-get install -y --force-yes \
    build-essential \
    libmysqlclient-dev \
    mysql-client \
    nodejs \
    git \
    ca-certificates \
    && update-ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install gems (Gemfile.lock excluded via .dockerignore, fresh resolution)
COPY Gemfile ./
RUN bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Copy Docker-specific database config
COPY config/database.yml.docker config/database.yml

# Copy and set up entrypoint (sed fixes Windows CRLF line endings)
COPY docker-entrypoint.sh /usr/bin/
RUN sed -i 's/\r$//' /usr/bin/docker-entrypoint.sh && chmod +x /usr/bin/docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
