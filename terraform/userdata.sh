#!/bin/bash
cd /home/ec2-user/
wget https://janstestfastapibucket2.s3.amazonaws.com/fastapi.zip
unzip fastapi.zip
rm fastapi.zip
python3 -m venv jobs_venv
source jobs_venv/bin/activate
pip install -r requirements.txt
python3 jobs.py
