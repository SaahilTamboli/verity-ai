#!/bin/bash
echo "Current directory: $(pwd)"
echo "Listing directory contents:"
ls -la

echo "Creating and activating virtual environment..."
python -m venv antenv
source antenv/bin/activate

echo "Installing requirements..."
pip install -r requirements.txt

echo "Starting application..."
cd app
echo "Current directory before starting app: $(pwd)"
echo "Listing app directory contents:"
ls -la

uvicorn main:app --host 0.0.0.0 --port 8000