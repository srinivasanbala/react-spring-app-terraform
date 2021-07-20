#Created this module to implement small react application on EC2 instances
**terraform Modules :**
Terraform-bootstrap
   Used to create S3 bucket and dynamodb table to implement Terraform locking and string the statefiles

**aws-vpc:**
    create the VPC
    1) create the vpc with the cidr modify the variable accordingly
    2) creates public , private and database subnets
    3) created Internet gateway and NAT gateway
    4) enable flowlog and create log groups to store the same (this can enhances to store the logs in S3 buckets)

**asg-springweb:**

  create the classic load balancer , Autoscaling group and launch configuration with min 1 and max 2 instances
  Ec2's scaled out/in when CPU load changes
  creates 2 security groups one at Load balancer level and other at ec2 level , for now rules are opened for all but needs restricted based on the project

**Implementation Steps:**

terraform (linux version copied on this repo , [please unzip it] )
All the codes are written to work with terraform version 0.9.11 , if you are executing in different operating systems please use accordingly

Terraform bootstrap :
cd vpcs/dev/bootstrap/eu-west-1/
../../../../terraform init
../../../../terraform plan --var-file=variable.tfvars
../../../../terraform apply --var-file=variable.tfvars
**VPC:**
cd vpcs/dev/vpcs/eu-west-1/
../../../../terraform init
../../../../terraform plan --var-file=variable.tfvars
../../../../terraform apply --var-file=variable.tfvars

Application:
Assuming we have Jenkins and Nexus installed and configured
configure jenkinsfile available under jenkins directory to build the application code

use the version and update it in the userdata.tpl to download and run when Autoscaling operation .

Impliment Application tier:

cd stacks/dev/poc/eu-west-1/
../../../../terraform init
../../../../terraform plan --var-file=variable.tfvars
../../../../terraform apply --var-file=variable.tfvars
**

Enhancements :**

1 ) We can use Packer to create the immutable image upfron with the application installed , and apply the Launch config versions as part of CI/CD

or

2) can use some container orchestration tool (ECS/EKS) to implement the same . Dockerfile to create the image and push to image registry . Apply the pod/tasks in respective container platforms

or
3) using Ansible/puppet configuration management tool , and from user data invoke ansible local playbook or puppet agent to communicate with master to apply the desired state

dynamodb can used to store the data instead in memory , but didn't have enough time to modify the code.
