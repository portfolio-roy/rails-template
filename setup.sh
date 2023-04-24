#!/bin/sh
if [ ! -f Gemfile ]; then
  # Fresh install
  gem install rails
  rails new . --database=postgresql
  npm install
else
  # Existing project
  bundle install
  npm install
fi

if grep -q "node_modules" .gitignore; then
  echo "node_modules is already in .gitignore"
else
  echo "Adding node_modules to .gitignore"
  echo "node_modules" >> .gitignore
fi

read -sp "Enter your PostgreSQL password for username `postgres`: " postgres_password

# Check if default block already has the fields
if grep -q 'username: postgres' config/database.yml && grep -q 'password: 123456' config/database.yml && grep -q 'host: localhost' config/database.yml && grep -q 'port: 5432' config/database.yml; then
  # Replace only the password field
  sed -i 's/password:.*/password: '"$postgres_password"'/' config/database.yml
else
  # Add the fields to the default block
  sed -i '/default:/a \  username: postgres\n  password: '"$postgres_password"'\n  host: localhost\n  port: 5432' config/database.yml
fi