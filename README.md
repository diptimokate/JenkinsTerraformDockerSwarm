**End-to-End DevOps Automation Project**

**End-to-End DevOps Automation using GitHub, Jenkins, Terraform, Ansible, Docker, DockerHub and Docker Swarm**

# **1\. Project Overview**

This project demonstrates an end-to-end DevOps automation workflow for deploying a web application using GitHub, Jenkins, Terraform, AWS, Ansible, Docker, DockerHub, and Docker Swarm.

The application source code and the Terraform files required to create the infrastructure are created by the developer and pushed to GitHub. Jenkins automates both the application and infrastructure stages. Docker is used to containerize the application, while DockerHub stores the Docker image.

Terraform provisions the required AWS infrastructure, and Ansible configures the servers and creates the Docker Swarm environment. Finally, the application image is pulled from DockerHub and deployed as a Docker Swarm service.

The application is accessed through the public IP address of the Docker Swarm worker node on port 81.

# **2\. Objectives**

- Automate application deployment using Jenkins.
- Store application source code in GitHub.
- Build a Docker image from the application.
- Push the Docker image to DockerHub.
- Provision AWS infrastructure using Terraform.
- Configure servers using Ansible.
- Create a Docker Swarm cluster.
- Deploy the application as a Docker Swarm service.
- Run multiple replicas of the application.
- Access the application through the worker node's public IP.

# **3\. Prerequisites**

### **Accounts & Access**

- AWS account with an IAM user/role that has permissions for EC2, VPC, and Security Groups (and any other services Terraform touches)
- AWS access key ID and secret access key configured (e.g. via aws configure or environment variables)
- DockerHub account with a repository created (e.g. diptimokat/docker_swarm_devops_project)
- GitHub account with this repository cloned/forked
- SSH key pair for accessing the EC2 instances (manager, worker, Ansible server)

### **Tools Installed on the Jenkins Server / Control Machine**

- Git
- Jenkins (with Pipeline, Git, Docker, and SSH Agent plugins)
- Docker (to build and push images)
- Terraform (version used in this project, e.g. >= 1.5.0)
- Ansible (version used, e.g. >= 2.10)
- AWS CLI

### **Jenkins Configuration**

- Credentials configured for DockerHub (username/password or access token)
- Credentials configured for AWS (access key/secre)
- SSH private key credential for Ansible to reach the provisioned servers
- Jenkins agents/nodes with Docker, Terraform, and Ansible available on PATH

### **Network / Infrastructure**

- An AWS region selected for deployment
- Security group rules allowing SSH (port 22) from your IP/Jenkins
- Security group rules allowing application traffic on port 81
- Security group rules allowing Docker Swarm internal ports between nodes (2377, 7946, 4789)

### **Cost Awareness**

This project provisions real, billable AWS infrastructure (EC2 instances for the manager, worker, and Ansible server). Run terraform destroy when finished testing to avoid ongoing charges.

## **4\. Technologies & Architecture Components**

| **Sr. No.** | **Component** | **Role**                                 |
| ----------- | ------------- | ---------------------------------------- |
| 1           | Git           | Version control                          |
| 2           | GitHub        | Source-code repository                   |
| 3           | Jenkins       | Automates CI/CD and infrastructure tasks |
| 4           | Docker        | Containerizes the application            |
| 5           | DockerHub     | Stores Docker image                      |
| 6           | Terraform     | Creates AWS infrastructure               |
| 7           | AWS           | Provides cloud infrastructure            |
| 8           | Ansible       | Configures servers and Docker Swarm      |
| 9           | Manager Node  | Controls Docker Swarm                    |
| 10          | Worker Node   | Runs application containers              |
| 11          | Docker Swarm  | Container orchestration                  |
| 12          | Nginx         | Web-server / container base image        |
| 13          | HTML          | Web application                          |

# **5\. Project Flow**

The complete project flow is:

Developer

|

v

Create Application Files

|

v

Push Files to GitHub

|

v

Jenkins

|

v

Build Docker Image -> Push Image to DockerHub

|

v

Run Terraform -> Create AWS Infrastructure

|

v

Configure Servers using Ansible -> Create Docker Swarm

|

v

Deploy Application

|

v

Pull Docker Image from DockerHub -> Create Swarm Service

|

v

Access Application through Worker Public IP

# **6\. Jenkins Pipeline / Jobs**

The project uses Jenkins to automate four distinct stages.

### **Job 1 — Build and Push Docker Image**

Jenkins pulls the application files from GitHub, builds the Docker image, and pushes it to DockerHub.

GitHub -> Jenkins -> Docker Build -> Docker Image -> DockerHub

Example:

docker build -t diptimokat/docker_swarm_devops_project:latest .

The image is pushed using:

docker push diptimokat/docker_swarm_devops_project:latest

### **Job 2 — Terraform Infrastructure**

Jenkins executes Terraform to provision the AWS infrastructure.

GitHub -> Jenkins -> Terraform -> AWS Infrastructure

Terraform workflow:

terraform init

terraform validate

terraform plan

terraform apply

### **Job 3 — Docker Swarm Setup**

Jenkins executes Ansible to configure the Docker Swarm environment.

Jenkins -> Ansible -> Manager + Worker -> Docker Swarm

Ansible performs tasks such as installing Docker, starting the Docker service, configuring Docker Swarm, initializing the manager, and joining the worker node.

### **Job 4 — Application Deployment**

The final Jenkins job deploys the application image available in DockerHub to the Docker Swarm cluster.

DockerHub -> Docker Image -> Ansible/Docker Swarm -> Swarm Service -> Worker Node

# **7\. Terraform & AWS Infrastructure**

Terraform is used as Infrastructure as Code (IaC) to automatically create the AWS infrastructure.

The infrastructure includes:

AWS

|-- VPC

|-- Subnet

|-- Security Configuration

|-- Ansible Server

|-- Docker Swarm Manager

+-- Docker Swarm Worker

Terraform creates the required EC2 instances:

- Ansible Server
- Docker Swarm Manager
- Docker Swarm Worker

The infrastructure is controlled through Jenkins rather than being created manually.

# **8\. Ansible & Docker Swarm**

After Terraform creates the servers, the Ansible server is accessed.

Project directory:

cd /home/itadmin/punepro

Ansible is used to configure the Docker environment and create the Docker Swarm cluster. Ansible automates:

- Docker installation
- Docker service configuration
- Docker service startup
- Docker Swarm initialization
- Worker node joining

After successful Ansible execution, the Docker Swarm cluster is ready for application deployment.

# **9\. Application Deployment & Access**

The application image is stored in DockerHub:

diptimokat/docker_swarm_devops_project:latest

The Docker Swarm deployment uses:

docker service create --name myweb -p 81:80 --replicas 3 diptimokat/docker_swarm_devops_project:latest

## Deployment Configuration

| **Configuration** | **Value**                                     |
| ----------------- | --------------------------------------------- |
| Service Name      | myweb                                         |
| Docker Image      | diptimokat/docker_swarm_devops_project:latest |
| Replicas          | 3                                             |
| Host Port         | 81                                            |
| Container Port    | 80                                            |

The application is accessed using the worker node's public IP:

http://&lt;WORKER_PUBLIC_IP&gt;:81

# **10\. How to Deploy**

### **Step 1 — Clone the Repository**

git clone <https://github.com/&lt;your-username&gt;/&lt;your-repo&gt;.git>

cd &lt;your-repo&gt;

### **Step 2 — Configure AWS & DockerHub Credentials**

Configure AWS CLI locally or on the Jenkins server:

aws configure

In Jenkins, add credentials under Manage Jenkins → Credentials:

- dockerhub-creds — DockerHub username/password or token
- aws-creds — AWS access key/secret (or attach an IAM role to the Jenkins instance)
- ansible-ssh-key — private key used to SSH into the EC2 servers

### **Step 3 — Update Configuration Values**

Before running, update these to match your environment:

- Terraform variables (variables.tf / terraform.tfvars) — region, instance types, key pair name, VPC/subnet CIDRs
- Ansible inventory/variables — server IPs (or use dynamic inventory from Terraform output), SSH user
- Jenkinsfile — DockerHub image name/tag, credential IDs, repo URL

### **Step 4 — Run Job 1: Build & Push Docker Image**

docker build -t &lt;your-dockerhub-username&gt;/docker_swarm_devops_project:latest .

docker push &lt;your-dockerhub-username&gt;/docker_swarm_devops_project:latest

### **Step 5 — Run Job 2: Provision AWS Infrastructure with Terraform**

terraform init

terraform validate

terraform plan

terraform apply -auto-approve

This creates the VPC, subnet, security groups, and the three EC2 instances (Ansible server, Swarm manager, Swarm worker).

### **Step 6 — Run Job 3: Configure Servers & Create Docker Swarm with Ansible**

From the Ansible server:

cd /home/itadmin/punepro

ansible-playbook -i inventory setup-swarm.yml

This installs Docker on all nodes, initializes the Swarm manager, and joins the worker node.

### **Step 7 — Run Job 4: Deploy the Application**

docker service create --name myweb -p 81:80 --replicas 3 &lt;your-dockerhub-username&gt;/docker_swarm_devops_project:latest

### **Step 8 — Verify Deployment**

Check that the service is running:

docker service ls

docker service ps myweb

**Then open the app in a browser:**

http://&lt;WORKER_PUBLIC_IP&gt;:81

### **Step 9 — Tear Down (when done)**

To avoid ongoing AWS charges:

terraform destroy -auto-approve

# **11\. Final Result**

The project successfully demonstrates an end-to-end automated DevOps deployment workflow.

The final workflow integrates:

Git -> GitHub -> Jenkins -> Docker -> DockerHub -> Terraform ->

AWS -> Ansible -> Docker Swarm -> Application Deployment -> Worker Public IP

The final application is deployed as a Docker Swarm service and is accessible through:

http://&lt;WORKER_PUBLIC_IP&gt;:81

This project demonstrates practical implementation of:

- Source Code Management
- CI/CD Automation
- Containerization
- Docker Image Management
- Infrastructure as Code
- Configuration Management
- Container Orchestration
- Automated Application Deployment