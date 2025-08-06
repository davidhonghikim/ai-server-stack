#!/bin/bash
set -e

USER_EMAIL="thedangerdawg@gmail.com"
USER_FULLNAME="thedangerdawg"
# Placeholder Argon2id hash for "password". YOU MUST CHANGE THIS AFTER LOGIN.
USER_PASSWORD_HASH='$argon2id$v=19$m=4096,t=3,p=1$c29tZV9zYWx0$c29tZV9oYXNo'

# Wait for PostgreSQL to be ready
until psql -h postgres -U penpot -d penpot -c "SELECT 1;" &>/dev/null; do
  echo "Waiting for PostgreSQL for user initialization..."
  sleep 1
done

# Check if user exists
if psql -h postgres -U penpot -d penpot -tAc "SELECT 1 FROM public.profile WHERE email = '$USER_EMAIL';" | grep -q 1; then
  echo "User $USER_EMAIL already exists. Skipping creation."
else
  echo "Creating user $USER_EMAIL..."
  psql -h postgres -U penpot -d penpot -c "INSERT INTO public.profile (id, created_at, modified_at, fullname, email, password, is_active, is_demo) VALUES (gen_random_uuid(), NOW(), NOW(), '$USER_FULLNAME', '$USER_EMAIL', '$USER_PASSWORD_HASH', TRUE, FALSE);"
  echo "User $USER_EMAIL created with temporary password. Please change it immediately after login."
fi
