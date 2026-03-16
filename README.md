# AWS CLI Infrastructure Lab

## 🔵 Objective
To demonstrate proficiency in managing AWS networking and compute resources using the AWS Command Line Interface (CLI).  
The focus of this lab is on **Elastic Network Interfaces (ENI), Placement Groups, and EC2 Instance Security Management**.




## 🔵 Core Capabilities Demonstrated

### 🔹Elastic Networking
Provisioning and configuring **secondary Elastic Network Interfaces (ENIs)** and associating them with **Elastic IP addresses (EIPs)** to create multi-homed EC2 instance setups.

### 🔹Network Security
Dynamically modifying **Security Group associations** at both the **network interface level** and **instance level**.

### 🔹Performance Optimization
Creating a **Cluster Placement Group** to achieve **low-latency and high-throughput networking** for distributed workloads.

### 🔹Instance Governance
Implementing **Termination Protection (Delete Protection)** to prevent accidental instance deletion.




## 🔵 AWS Services Used

- **Amazon EC2** – Virtual servers used for compute resources.
- **Amazon VPC** – Networking infrastructure including subnets, security groups, and ENIs.
- **AWS IAM** – Required for providing permissions to execute AWS CLI commands.




## 🔵 Assignment Structure

### 🔹 Phase 1 – Networking Layer
Create and configure a **secondary ENI**, attach security groups, and assign a **static public IP (Elastic IP)**.

### 🔹 Phase 2 – Compute Layer
Create a **Cluster Placement Group** and launch an **EC2 instance inside the group** to simulate a high-performance environment.

### 🔹 Phase 3 – Security & Lifecycle
Enable **Termination Protection** and dynamically update **Security Groups** to simulate real-world maintenance and governance scenarios.




## 🔵 Architecture Flow

🔹Network Setup  
Create ENI → Assign Security Group → Attach Elastic IP

🔹Compute Setup  
Create Placement Group → Launch EC2 Instance in Placement Group

🔹Management  
Enable Termination Protection → Update Security Groups




## 🔵 Implementation Steps

### 🔹Step 1 – Create a Secondary Elastic Network Interface

```bash
aws ec2 create-network-interface \
--subnet-id subnet-12345abcde \
--description "Secondary ENI for Assignment"


The command returns JSON output containing a NetworkInterfaceId such as: eni-0a1b2c3d4e5f 



  🔹Step 2 – Associate a Security Group with the ENI


aws ec2 modify-network-interface-attribute \
--network-interface-id eni-0a1b2c3d4e5f \
--groups sg-987654321fed


This replaces existing security groups with the specified group.



  🔹Step 3 – Allocate and Associate an Elastic IP

🔹Allocate a public IP:

aws ec2 allocate-address --domain vpc

🔹Associate the allocated IP with the ENI:

aws ec2 associate-address \
--allocation-id eipalloc-0123456789 \
--network-interface-id eni-0a1b2c3d4e5f



  🔹Step 4 – Create Placement Group and Launch EC2

🔹Create a cluster placement group:

aws ec2 create-placement-group \
--group-name MyAssignmentCluster \
--strategy cluster

🔹Launch an EC2 instance within the placement group:

aws ec2 run-instances \
--image-id ami-0123456789abcdef0 \
--count 1 \
--instance-type t3.micro \
--placement GroupName=MyAssignmentCluster




 🔹Step 5 – Enable or Disable Termination Protection

🔹Enable termination protection:

aws ec2 modify-instance-attribute \
--instance-id i-0abcdef123456789 \
--disable-api-termination "{\"Value\":true}"

🔹Disable termination protection:

aws ec2 modify-instance-attribute \
--instance-id i-0abcdef123456789 \
--disable-api-termination "{\"Value\":false}"
Step 6 – Modify the Security Group of an EC2 Instance
aws ec2 modify-instance-attribute \
--instance-id i-0abcdef123456789 \
--groups sg-newgroup

This updates the security groups associated with the instance’s primary network interface.





🔵 Project Folder Structure
aws-cli-infrastructure-lab/
│
├── README.md
│
├── scripts/
│   └── setup_resources.sh
│
├── screenshots/
│   ├── step1_eni.png
│   ├── step2_sg_assoc.png
│   ├── step3_eip.png
│   ├── step4_placement.png
│   ├── step5_protection.png
│   └── step6_change_sg.png
│
└── architecture/
    └── flowchart.png





🔵 Key Outcomes

. Successfully provisioned secondary networking components.

. Implemented cluster placement strategy for performance optimization.

. Applied instance governance and protection mechanisms.

. Practiced dynamic security group management using AWS CLI.




🔵 Conclusion

Using the AWS CLI enables fully scriptable and repeatable infrastructure management.
This project demonstrates that advanced networking configurations—such as multi-homed EC2 instances using secondary ENIs—can be efficiently implemented without relying on the AWS Management Console.




🔵 Post-Lab Cleanup (Important)

To avoid unnecessary AWS charges, remove all created resources.

- Terminate EC2 instance:

aws ec2 terminate-instances --instance-ids <instance-id>

- Release Elastic IP:

aws ec2 release-address --allocation-id <allocation-id>

- Delete the network interface:

aws ec2 delete-network-interface --network-interface-id <eni-id>

- Delete the placement group:

aws ec2 delete-placement-group --group-name MyAssignmentCluster