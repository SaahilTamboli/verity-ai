#!/bin/bash
echo "Starting deployment script..."

# Navigate to the correct directory
cd /home/site/wwwroot
echo "Current directory: $(pwd)"

# Create and activate virtual environment using full path
python3 -m venv /home/site/wwwroot/antenv
echo "Virtual environment created"

# Use . instead of source for better compatibility
. /home/site/wwwroot/antenv/bin/activate
echo "Virtual environment activated"

# Install dependencies
echo "Installing dependencies..."
pip install --no-cache-dir -r requirements.txt

# Start the application
echo "Starting FastAPI application..."
cd app
export PYTHONPATH=/home/site/wwwroot
/home/site/wwwroot/antenv/bin/uvicorn main:app --host 0.0.0.0 --port 8000