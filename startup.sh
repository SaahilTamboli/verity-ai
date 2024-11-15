#!/bin/bash

echo "Starting deployment script..."

# Navigate to the correct directory
cd /home/site/wwwroot

# Create virtual environment
/usr/local/bin/python3 -m venv antenv

# Activate virtual environment (using . instead of source)
. antenv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Start the application
cd app
PYTHONPATH=/home/site/wwwroot antenv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000