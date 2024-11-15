#!/bin/bash
cd /home/site/wwwroot

# Create and activate virtual environment
python -m venv antenv
source antenv/bin/activate

# Install requirements
pip install -r requirements.txt

# Start the application
cd app
uvicorn main:app --host 0.0.0.0 --port 8000