FROM ruby:3.4

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    default-libmysqlclient-dev \
    default-mysql-client \
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

# Fix Windows CRLF line endings in scripts
RUN find /app/bin -type f -exec sed -i 's/\r$//' {} + 2>/dev/null || true

# Copy and set up entrypoint
COPY docker-entrypoint.sh /usr/bin/
RUN sed -i 's/\r$//' /usr/bin/docker-entrypoint.sh && chmod +x /usr/bin/docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
