Objective: To demonstrate proficiency in managing AWS networking and compute resources using the AWS Command Line Interface (CLI), specifically focusing on Elastic Network Interfaces (ENI), Placement Groups, and Instance security.


Core Capabilities Demonstrated
Elastic Networking: Provisioning and configuring secondary ENIs and associating them with Elastic IPs (EIPs) for multi-homed instance setups.

Network Security: Dynamic modification of Security Group associations at both the interface and instance levels.

Performance Optimization: Creating Cluster Placement Groups to ensure low-latency, high-throughput networking for distributed workloads.

Instance Governance: Implementing and toggling Termination Protection to prevent accidental data loss or service interruption.



Assignment Structure
Phase 1: Networking Layer - Building the secondary ENI and assigning static public IP addresses.

Phase 2: Compute Layer - Initializing a Cluster Placement Group and launching high-performance EC2 instances.

Phase 3: Security & Lifecycle - Applying "Delete Protection" and hot-swapping security groups to simulate real-world maintenance scenarios.


Services Used: * Amazon EC2: Virtual Servers.

Amazon VPC: Networking (Subnets, Security Groups, ENIs).

IAM: For CLI permissions (pre-requisite).


📊 Flowchart & LogicNetwork Setup: Create ENI $\rightarrow$ Assign Security Group $\rightarrow$ Attach Elastic IP.Compute Setup: Create Placement Group $\rightarrow$ Launch EC2 within it.Management: Apply Termination Protection $\rightarrow$ Update Security Groups as needed.



Folder Structure:

Plaintext
aws-cli-infrastructure-lab/
├── README.md              # Project documentation (Objective, Steps, Conclusion)
├── scripts/
│   └── setup_resources.sh # Shell script containing all commands
├── screenshots/
│   ├── step1_eni.png
│   ├── step2_sg_assoc.png
│   ├── step3_eip.png
│   ├── step4_placement.png
│   ├── step5_protection.png
│   └── step6_change_sg.png
└── architecture/
    └── flowchart.png      # Your architecture diagram





🛠 Step-by-Step Implementation
1. Create a Secondary Elastic Network Interface (ENI)
You need a Subnet ID and Security Group ID for this.

Bash
aws ec2 create-network-interface --subnet-id subnet-12345abcde --description "Secondary ENI for Assignment"
Expected Output:

View the NetworkInterfaceId in the JSON response (e.g., eni-0a1b2c3d4e5f).

2. Associate a Security Group with ENI
To change or add security groups to an existing ENI:

Bash
aws ec2 modify-network-interface-attribute --network-interface-id eni-0a1b2c3d4e5f --groups sg-987654321fed
Note: This command replaces all existing groups with the one(s) you specify.

3. Associate an Elastic IP (EIP) with ENI
First, allocate an address, then associate it.

Bash
# Allocate
aws ec2 allocate-address --domain vpc

# Associate (Use the AllocationId from above)
aws ec2 associate-address --allocation-id eipalloc-0123456789 --network-interface-id eni-0a1b2c3d4e5f
4. Create a Placement Group & Launch EC2
Bash
# Create Placement Group
aws ec2 create-placement-group --group-name MyAssignmentCluster --strategy cluster

# Launch EC2 in that group
aws ec2 run-instances --image-id ami-0123456789abcdef0 --count 1 --instance-type t3.micro --placement GroupName=MyAssignmentCluster
5. Enable/Disable Termination Protection
Bash
# Enable
aws ec2 modify-instance-attribute --instance-id i-0abcdef123456789 --disable-api-termination "{\"Value\":true}"

# Disable
aws ec2 modify-instance-attribute --instance-id i-0abcdef123456789 --disable-api-termination "{\"Value\":false}"
6. Change Security Group of an EC2
On a running instance, you modify the attribute of its primary ENI.

Bash
aws ec2 modify-instance-attribute --instance-id i-0abcdef123456789 --groups sg-newgro





🎯 Final Details
Key Outcomes
Successfully provisioned secondary networking components.

Implemented high-performance instance placement (Cluster strategy).

Applied security best practices through termination protection and dynamic SG updates.

Conclusion

Using the AWS CLI allows for repeatable, scriptable infrastructure management. This assignment demonstrates that complex networking tasks (like multi-homing with secondary ENIs) can be executed efficiently without the AWS Console.

🧹 Post-Lab Clean Up
Always do this to avoid costs:

Terminate Instance: aws ec2 terminate-instances --instance-ids <id>

Disassociate/Release EIP: aws ec2 release-address --allocation-id <id>

Delete ENI: aws ec2 delete-network-interface --network-interface-id <id>

Delete Placement Group: aws ec2 delete-placement-group --group-name MyAssignmentCluster