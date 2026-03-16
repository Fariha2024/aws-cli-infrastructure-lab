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


## Here’s a simple visual diagram showing how a secondary ENI attaches to an EC2 instance and interacts with your VPC:


          ┌───────────────────────────┐
          │        VPC: 10.0.0.0/16  │
          │                           │
          │   ┌───────────────┐       │
          │   │   Subnet A    │       │
          │   │ 10.0.1.0/24  │       │
          │   └───────────────┘       │
          │           │               │
          │           │               │
          │  ┌───────────────────┐   │
          │  │   EC2 Instance    │   │
          │  │  i-0abcdef123456  │   │
          │  │                   │   │
          │  │ Primary ENI (eth0)│◄─ Public/Private IP
          │  │ Secondary ENI     │◄─ Optional extra IP, separate security group
          │  │   (eth1)          │
          │  └───────────────────┘
          │
          │
          │  Internet Gateway / Elastic IP can attach to any ENI
          │
          └───────────────────────────┘


🔹 How it works

1. Primary ENI (eth0)
2. Secondary ENI (eth1)
3. Elastic IP / Internet Gateway

🔹 **What is a Secondary ENI?**

An **Elastic Network Interface (ENI)** is like a **network card** for your EC2 instance in AWS.

- Every EC2 instance comes with **one primary ENI** by default.  
- Normally, it has **one network cable** (the primary ENI) connecting it to the network.



🔹 **What this step does**

When you create a **secondary ENI**, it’s like **plugging in a second network cable**.

- Now the instance can **talk to different networks** at the same time.  
- It can have **multiple IP addresses** or connect to **different subnets**.  
- Useful for **traffic isolation, multi-network communication, or high availability**.



### Find Subnets Available in Your VPC

![Step 1 Subnets](screenshots/step1_find_subnets.png)


# Pick one subnet ID that you want to create your ENI in.

🔹 **What happens after you run it**

1. AWS creates a **secondary ENI** in the subnet you specified.  
2. You will get a **JSON output** like this:

json
{
    "NetworkInterface": {
        "NetworkInterfaceId": "eni-0a1b2c3d4e5f",
        "SubnetId": "subnet-12345abcde",
        "Description": "Secondary ENI for Assignment",
        ...
    }
}
---


![Step-2-ENI-CREATION](screenshots/step1_eni.png)



- - The key thing to note is that the command returns JSON output containing the NetworkInterfaceId (eni-0a1b2c3d4e5f).

- You’ll use this ID in the next steps to attach it to your instance, assign security groups, or associate an Elastic IP.



🔹 Why it’s useful

- Allows multiple IPs per instance.

- Enables high availability setups or multi-network connectivity.

- Useful for applications that need separate public/private IPs or security isolation.



🔹 Why You Might Need This (Requirements / Use Cases)

1. Multiple IPs on One Instance

. Some apps need more than one IP.

. Example: A web server that serves two different domains with different public IPs.

2. Separate Security Groups / Traffic Isolation

. You can attach a different security group to the secondary ENI.

. Example: One interface for internal communication, another for public traffic.

3. High Availability / Failover

. You can move the ENI to another EC2 instance if one fails.

. Example: Critical services need minimal downtime.

4. Multi-Subnet or Multi-VPC Communication

. Secondary ENIs can be in a different subnet.

. Example: One ENI talks to your private database subnet, another to the public internet.

5. Elastic IP Assignment

. You can assign a separate public IP to this ENI without touching the primary one.

. Example: External clients use a dedicated public IP to reach the app.



🔹 TL;DR (Simple Summary)

. What: Add a “second network cable” to your instance.

. Why: To separate traffic, add more IPs, increase availability, or isolate security.

. Requirement: Any scenario where one network interface is not enough.


💡 Example Use Case You Might Relate To

Imagine you have a web server that:

. Needs one IP for the public website

. Needs another IP to talk securely to your database

. Needs traffic isolation for security

Instead of creating two separate EC2 instances, you just attach a secondary ENI with its own IP and security group. ✅





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