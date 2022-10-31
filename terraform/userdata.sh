#!/bin/bash
cd /home/ec2-user/
aws s3 cp s3://janstestfastapibucket2.s3.amazonaws.com/fastapi.zip fastapi.zip
unzip fastapi.zip
rm fastapi.zip
pip install -r requirements.txt
python3 jobs.py
