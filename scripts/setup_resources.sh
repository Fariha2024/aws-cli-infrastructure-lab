# Shell script containing all commands

## 🔹Step 1: Create the secondary ENI with a real subnet ID


~ $ # Step 1: Find your subnet ID
~ $ aws ec2 describe-subnets --query "Subnets[*].[SubnetId, VpcId, CidrBlock, AvailabilityZone]" --output table
----------------------------------------------------------------------------------------
|                                    DescribeSubnets                                   |
+---------------------------+-------------------------+-----------------+--------------+
|  subnet-0b4d03067ff36906b |  vpc-0690311ae61c48aec  |  172.31.16.0/20 |  ap-south-1c |
|  subnet-003cbe0885aa9c2d0 |  vpc-0690311ae61c48aec  |  172.31.0.0/20  |  ap-south-1b |
|  subnet-0b5c3a1c46751ea8f |  vpc-0690311ae61c48aec  |  172.31.32.0/20 |  ap-south-1a |
+---------------------------+-------------------------+-----------------+--------------+
~ $ # Pick one subnet ID that you want to create your ENI in.


# Step 2: Create the secondary ENI in the chosen subnet
# Returns JSON containing NetworkInterfaceId (used in later steps)
aws ec2 create-network-interface \
--subnet-id subnet-0b4d03067ff36906b \
--description "Secondary ENI for Assignment"

## The Network Interface ID in your JSON output is this line:

"NetworkInterfaceId": "eni-0d83541175ca081f2"





🔹Step 2 – Associate a Security Group with the ENI


$ # Find security groups available in your VPC
~ $ aws ec2 describe-security-groups


# From the output you shared, your Security Group ID is:
sg-089cd5939a591ad7a

aasociate


Run this command to confirm the security group is attached:
# Verify security group attached to the ENI
aws ec2 describe-network-interfaces \
--network-interface-ids eni-0d83541175ca081f2


🔹Where the Verification Appears in Your Output

Look at this section:

"Groups": [
    {
        "GroupId": "sg-089cd5939a591ad7a",
        "GroupName": "launch-wizard-9"
    }
]


# Show ENI and associated security groups
aws ec2 describe-network-interfaces \
--network-interface-ids eni-0d83541175ca081f2 \
--query "NetworkInterfaces[*].[NetworkInterfaceId,Groups[*].GroupId]" \
--output table

output:
-----------------------------------------
|      DescribeNetworkInterfaces        |
+----------------------+----------------+
| eni-0d83541175ca081f2 | sg-089cd5939a591ad7a |
+----------------------+----------------+




# Allow SSH from your IP only
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 22 \
  --cidr $MY_IP/32

Notes:

Remove --comment — AWS CLI does not support it here.

Make sure no comments come after a backslash \ — only end-of-line backslashes.

Replace $SG_ID and $MY_IP with your values if not using variables.



output: ~ $ # Allow SSH from your IP only
~ $ aws ec2 authorize-security-group-ingress \
>   --group-id $SG_ID \
>   --protocol tcp \
>   --port 22 \
>   --cidr $MY_IP/32
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0e2db3899f0b35797",
            "GroupId": "sg-089cd5939a591ad7a",
            "GroupOwnerId": "856221042950",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 22,
            "ToPort": 22,
            "CidrIpv4": "203.0.113.25/32",
            "SecurityGroupRuleArn": "arn:aws:ec2:ap-south-1:856221042950:security-group-rule/sgr-0e2db3899f0b35797"
        }
    ]
}




~ $ # Allow HTTP (public)
~ $ aws ec2 authorize-security-group-ingress \
>   --group-id $SG_ID \
>   --protocol tcp \
>   --port 80 \
>   --cidr 0.0.0.0/0
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-00afc40ae156107b3",
            "GroupId": "sg-089cd5939a591ad7a",
            "GroupOwnerId": "856221042950",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "CidrIpv4": "0.0.0.0/0",
            "SecurityGroupRuleArn": "arn:aws:ec2:ap-south-1:856221042950:security-group-rule/sgr-00afc40ae156107b3"
        }
    ]
}




~ $ # Allow HTTPS (public)
~ $ aws ec2 authorize-security-group-ingress \
>   --group-id $SG_ID \
>   --protocol tcp \
>   --port 443 \
>   --cidr 0.0.0.0/0
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-083fdc4412c343c6d",
            "GroupId": "sg-089cd5939a591ad7a",
            "GroupOwnerId": "856221042950",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 443,
            "ToPort": 443,
            "CidrIpv4": "0.0.0.0/0",
            "SecurityGroupRuleArn": "arn:aws:ec2:ap-south-1:856221042950:security-group-rule/sgr-083fdc4412c343c6d"
        }
    ]
}



~ $ # Database access from private subnet
~ $ aws ec2 authorize-security-group-ingress \
>   --group-id $SG_ID \
>   --protocol tcp \
>   --port 3306 \
>   --cidr $PRIVATE_SUBNET_CIDR
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0b5cba32cce8dddbd",
            "GroupId": "sg-089cd5939a591ad7a",
            "GroupOwnerId": "856221042950",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 3306,
            "ToPort": 3306,
            "CidrIpv4": "10.0.1.0/24",
            "SecurityGroupRuleArn": "arn:aws:ec2:ap-south-1:856221042950:security-group-rule/sgr-0b5cba32cce8dddbd"
        }
    ]
}

Run: 
 aws ec2 describe-security-groups \
>   --group-ids $DB_SG_ID \
>   --query "SecurityGroups[*].IpPermissions"


From the output you shared:

Port 3306 (MySQL) is now correctly open only for the private subnet 172.31.16.0/20.

Port 80 (HTTP) is open to everyone (0.0.0.0/0), which is normal if this SG also handles web traffic.

This confirms that your database security group is correctly restricted to the private subnet, and the ingress rule is applied.