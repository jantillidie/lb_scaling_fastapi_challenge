#!/bin/bash
cd /home/ec2-user/
wget https://jansfastapibucket87293847.s3.amazonaws.com/fastapi.zip
unzip fastapi.zip
rm fastapi.zip
pip install -r requirements.txt
python3 jobs.py
