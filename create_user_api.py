import requests
import json
import sys

PENPOT_BACKEND_URL = "http://localhost:6060"
USER_EMAIL = "thedangerdawg@gmail.com"
USER_PASSWORD = "Kos30437"
USER_FULLNAME = "thedangerdawg"

def create_penpot_user():
    # Check if user exists (simplified check, might need more robust API call)
    try:
        response = requests.post(f"{PENPOT_BACKEND_URL}/api/rpc/command/login-with-password", json={
            "email": USER_EMAIL,
            "password": USER_PASSWORD
        })
        if response.status_code == 200:
            print(f"User {USER_EMAIL} already exists. Skipping creation.")
            return
    except requests.exceptions.ConnectionError:
        print("Penpot backend not reachable. Exiting.")
        sys.exit(1)

    # Create user
    print(f"Attempting to create user {USER_EMAIL}...")
    try:
        response = requests.post(f"{PENPOT_BACKEND_URL}/api/rpc/command/register-with-password", json={
            "email": USER_EMAIL,
            "password": USER_PASSWORD,
            "fullname": USER_FULLNAME
        })
        response.raise_for_status()
        print(f"User {USER_EMAIL} created successfully.")
    except requests.exceptions.HTTPError as e:
        print(f"Error creating user: {e.response.status_code} - {e.response.text}")
    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")

if __name__ == "__main__":
    create_penpot_user()