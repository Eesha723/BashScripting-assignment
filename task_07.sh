#!/bin/bash

ROOT_UID=0     
E_NOTROOT=100

#AWS Credentials gettimg from AWS parameter store
AWS_ACCESS_KEY_ID=$(aws --region=us-east-1 ssm get-parameter --name "EESHA_ACCESS_KEY" --with-decryption --output text --query Parameter.Value)
AWS_SECRET_ACCESS_KEY=$(aws --region=us-east-1 ssm get-parameter --name "EESHA_SECRET_KEY" --with-decryption --output text --query Parameter.Value)
AWS_DEFAULT_REGION=us-east-1

#EC2 DETAILS
AMI=$(aws ssm get-parameters --names /aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id --query 'Parameters[*].[Value]' --output text)
COUNT=1
INSTANCE_TYPE="t2.micro"
KEY_NAME="assignment-02-kp"
SUBNET_ID="subnet-0650cf70762973d58"
TAG='ResourceType=instance,Tags=[{Key=Name,Value=website-server}]'
SG="sg-0875d77027b6c300c"


if [ "$UID" -ne "$ROOT_UID" ]
    then
        echo "Must be root to run this script."
        exit $E_NOTROOT
fi  

source task_03.sh

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION

echo "Launching EC2...."
aws ec2 run-instances \
	--image-id $AMI \
	--count $COUNT \
	--instance-type $INSTANCE_TYPE \
	--key-name $KEY_NAME \
	--security-group-ids $SG \
	--subnet-id $SUBNET_ID \
	--tag-specifications $TAG \
	--user-data file://task7_user_data.txt

