 #!/bin/bash

SG_ID="sg-047414b5251141a52"
AMI_ID="ami-0220d79f3f480ecf5"
# Create a new EC2 instance

for instance in $@
do  
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


