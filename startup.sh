#!/bin/bash
cd /home/site/wwwroot
source antenv/bin/activate
gunicorn main:app --bind=0.0.0.0:8000 --workers=4 --timeout 600 --worker-class uvicorn.workers.UvicornWorker