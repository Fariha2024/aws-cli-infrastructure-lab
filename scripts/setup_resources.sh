# Shell script containing all commands

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