#!/bin/bash
echo "Installing dependencies..."
python -m pip install --upgrade pip
pip install -r requirements.txt

echo "Starting application..."
gunicorn main:app --workers 2 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000