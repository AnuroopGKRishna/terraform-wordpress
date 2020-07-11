# Copyright 2016 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file
# except in compliance with the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under the License.

resource "aws_instance" "wpsite_buid_master" {
  ami = lookup(var.amis, var.region)
  instance_type = var.instance_type
  tags = {
    Name = "build_master"
  }
  subnet_id = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.build_master_ssh_sg_id,var.build_master_http_sg_id,var.build_master_https_sg_id,var.build_master_custom_sg_id,var.build_master_outbound_sg_id]
  key_name = var.key_name

provisioner "local-exec" {
  command = "echo [web] > ../deploy-ansible/inventory &&  echo ${aws_instance.wpsite_buid_master.public_dns}  ansible_ssh_private_key_file=wordpress.pem >> ../deploy-ansible/inventory"
}
}
