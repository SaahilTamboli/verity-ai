#!/bin/bash
cd /home/site/wwwroot
source antenv/bin/activate
cd app
export ALLOWED_HOSTS="verity-bggwhqaqeze3agd2.westindia-01.azurewebsites.net"
uvicorn main:app --host 0.0.0.0 --port 8000