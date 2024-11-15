#!/bin/bash
echo "Starting deployment script..."

# Navigate to the correct directory
cd /home/site/wwwroot
echo "Current directory: $(pwd)"

# Create and activate virtual environment using full path
python -m venv antenv
echo "Virtual environment created"

# Activate virtual environment
. antenv/bin/activate
echo "Virtual environment activated"

# Upgrade pip
python -m pip install --upgrade pip

# Install dependencies with verbose output
echo "Installing dependencies..."
pip install --no-cache-dir -r requirements.txt --verbose

# List installed packages
echo "Installed packages:"
pip list

# Start the application
echo "Starting FastAPI application..."
cd app
export PYTHONPATH=/home/site/wwwroot
export PORT=8000
python -m uvicorn main:app --host 0.0.0.0 --port $PORT --workers 1