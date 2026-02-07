 #!/bin/bash

SG_ID="sg-047414b5251141a52"
AMI_ID="ami-0220d79f3f480ecf5"
# Create a new EC2 instance


for instance in $@
do  

INSTANCE_NAME="your_instance_name"
INSTANCE_CHECK=$(your_command_to_check_instance "$INSTANCE")

if [ -z "$INSTANCE_CHECK" ]; then
    echo "Instance does not exist. Creating..."
    # Your instance creation command here
    your_create_instance_command "$INSTANCE"
else
    echo "Instance already exists. Skipping creation."
fi
   INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [ "$INSTANCE" == "frontend" ]; then
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text
     )
  else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[0].Instances[0].PrivateIpAddress' \
            --output text
     )
  fi

    echo "Instance $instance created with ID: $INSTANCE_ID and IP: $IP"
done


