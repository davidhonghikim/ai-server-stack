#!/bin/bash
set -e

PENPOT_BACKEND_URL="http://localhost:6060"
USER_EMAIL="thedangerdawg@gmail.com"
USER_PASSWORD="Kos30437"
USER_FULLNAME="thedangerdawg"

# Wait for Penpot backend to be fully ready
echo "Waiting for Penpot backend to be fully ready..."
until docker-compose exec penpot-backend curl --output /dev/null --silent --head --fail ${PENPOT_BACKEND_URL}/api/rpc/command/get-profile; do
  sleep 5;
done;
echo "Penpot backend is ready."

# Check if user exists by attempting to log in
echo "Checking if user ${USER_EMAIL} exists..."
LOGIN_RESPONSE=$(docker-compose exec -T penpot-backend curl -s -X POST -H "Content-Type: application/json" -d "{\"email\": \"${USER_EMAIL}\", \"password\": \"${USER_PASSWORD}\"}" ${PENPOT_BACKEND_URL}/api/rpc/command/login-with-password)

if echo "$LOGIN_RESPONSE" | grep -q "token"; then
  echo "User ${USER_EMAIL} already exists. Skipping creation."
else
  echo "User ${USER_EMAIL} does not exist. Attempting to create user..."
  REGISTER_RESPONSE=$(docker-compose exec -T penpot-backend curl -s -X POST -H "Content-Type: application/json" -d "{\"email\": \"${USER_EMAIL}\", \"password\": \"${USER_PASSWORD}\", \"fullname\": \"${USER_FULLNAME}\"}" ${PENPOT_BACKEND_URL}/api/rpc/command/register-with-password)
  
  if echo "$REGISTER_RESPONSE" | grep -q "token"; then
    echo "User ${USER_EMAIL} created successfully."
  else
    echo "Error creating user ${USER_EMAIL}: ${REGISTER_RESPONSE}"
    exit 1
  fi
fi