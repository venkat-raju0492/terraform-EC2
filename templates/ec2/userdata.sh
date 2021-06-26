#!/bin/bash
apt-get update -y

#Qualys Agent
aws s3 cp ${qualys_s3_url} /tmp
rpm -ivh /tmp/qualys-cloud-agent.x86_64.rpm
/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=32561831-6999-4cf8-80a5-660147741d7d CustomerId=9c0e25ce-dfec-5af6-e040-10ac13043f6a
chkconfig qualys-cloud-agent on