
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
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.region
}
module "vpc_subnets" {
  source = "./vpc_subnets"
  key_name = "${var.key_name}"
  ip_range = "${var.ip_range}"
  wpsite_name="${var.wpsite_name}"
}
module "rds_instance" {
  source = "./rds_instance"
  wpsite_name="${var.wpsite_name}"
  wpsite_public_subnet_1 ="${module.vpc_subnets.wpsite_public_subnet_1_cidr}"
  wpsite_private_subnet_1 ="${module.vpc_subnets.wpsite_private_subnet_1_cidr}"
  rds_vpc_id="${module.vpc_subnets.vpc_id}"
}

module "build_master" {
    source = "./build_master"
    public_subnet_id = "${module.vpc_subnets.wpsite_public_subnet_1_cidr}"
    build_master_ssh_sg_id = "${module.vpc_subnets.wpsite_ssh_inbound_sg_id}"
    build_master_http_sg_id = "${module.vpc_subnets.wpsite_http_inbound_sg_id}"
    build_master_https_sg_id = "${module.vpc_subnets.wpsite_https_inbound_sg_id}"
    build_master_custom_sg_id = "${module.vpc_subnets.wpsite_custom_inbound_sg_id}"
    build_master_outbound_sg_id = "${module.vpc_subnets.wpsite_outbound_sg_id}"
    key_name = "${var.key_name}"
  }
