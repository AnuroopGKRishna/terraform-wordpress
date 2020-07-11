# terraform-wordpress
# Basic Terraform setup

# Requirements:
 Terraform
 Ansible
 AWS admin access
# Tools Used:
 ansible --version
 ansible 2.7.6
 terraform version
 Terraform v0.12.28
# TO use terraform, :

infra-terraform/ :
 Specify the AWS access keys  in variables.tf file located at :
      infra-terraform/variables.tf
            variable "aws_access_key" {
            default=""
            }
      variable "aws_secret_key" {
            default = ""
            }

  Also create a private pem key for the user  to connect different  instances
 # specifies the  private key to connect via ssh to different instances
            variable "key_name" {
            default = ""
            }
# To setup terraform run
terraform get
terrafrom init

# To Generate and show an execution plan (dry run):

terraform plan
# To Builds or makes actual changes in infrastructure:

terraform apply
# To inspect Terraform state or plan:
terraform show

# To destroy Terraform-managed infrastructure:
terraform destroy


# Ansible deployment :

deploy-ansible/

Once the Terraform will create all the resources over AWS, you can use the Ansible to install the wordpress over the EC2 instance(s)

# To use the provided Role:
ansible-playbook site.yml -e@../secret/secure.yml -e@../infra-terraform/interviewanruoop.yml

Where  interviewanruoop.yml is dynamicaly created while creating resources using terraform

# Note 
Here inventory also being created dynamicaly and uses key authentication to login to resources,so place the key (private key-pem) under the folder

deploy-ansible/

Also here I have specife us-east region and uses linix image where ubuntu is the default user to login

Once the Ansible deployment is completed you can check the wordpress site under the url :

http://{{inventory dns host name}} -located at path deploy-ansible/inventory
