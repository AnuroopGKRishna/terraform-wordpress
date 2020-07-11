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

variable "ip_range" {
  default = "0.0.0.0/0" # Change to your IP Range!
}
variable "availability_zones" {
  # No spaces allowed between az names!
   default=["us-east-1a","us-east-1c","us-east-1d","us-east-1e"]
}
variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "172.33.0.0/16"
}
variable "public_subnet_1_cidr" {
  description = "CIDR for the Public  Subnet"
  default = "172.33.16.0/20"
}
variable "private_subnet_1_cidr" {
  description = "CIDR for the Private Subnet"
  default = "172.33.32.0/20"
}

variable "key_name" {}

variable "wpsite_name" {}
