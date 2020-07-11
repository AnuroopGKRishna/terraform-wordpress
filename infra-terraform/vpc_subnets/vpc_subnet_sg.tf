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

resource "aws_security_group" "wpsite_http_inbound" {
  name = "${var.wpsite_name}_http_inbound"
  description = "Allow HTTP from Anywhere"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.wpsite_vpc.id}"
  tags = map("Name","${var.wpsite_name}_http_inbound")
}
output "wpsite_http_inbound_sg_id" {
  value = "${aws_security_group.wpsite_http_inbound.id}"
}

resource "aws_security_group" "wpsite_http_ipv6_inbound" {
  name = "${var.wpsite_name}_http_ipv6_inbound"
  description = "Allow HTTP for ipv6 from Anywhere"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
  vpc_id = "${aws_vpc.wpsite_vpc.id}"
  tags = map("Name" ,"${var.wpsite_name}_http_ipv6_inbound")
}
output "wpsite_http_ipv6_inbound_sg_id" {
  value = "${aws_security_group.wpsite_http_ipv6_inbound.id}"
}

resource "aws_security_group" "wpsite_ssh_inbound_sg" {
  name = "${var.wpsite_name}_ssh_inbound"
  description = "Allow SSH from certain ranges"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.wpsite_vpc.id}"
  tags = map("Name", "${var.wpsite_name}_ssh_inbound")
}
output "wpsite_ssh_inbound_sg_id" {
  value = "${aws_security_group.wpsite_ssh_inbound_sg.id}"
}

resource "aws_security_group" "wpsite_outbound_sg" {
  name = "${var.wpsite_name}_outbound"
  description = "Allow outbound connections"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.wpsite_vpc.id}"
  tags  = map("Name", "${var.wpsite_name}_outbound")
}
output "wpsite_outbound_sg_id" {
  value = "${aws_security_group.wpsite_outbound_sg.id}"
}

#cutom tcp rule for the port 20
resource "aws_security_group" "wpsite_custom_inbound" {
  name = "${var.wpsite_name}_custom_inbound"
  description = "Allow cutom port   from Anywhere"
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.wpsite_vpc.id}"
  tags = map("Name", "${var.wpsite_name}_custom_inbound")
}
output "wpsite_custom_inbound_sg_id" {
  value = "${aws_security_group.wpsite_custom_inbound.id}"
}

resource "aws_security_group" "wpsite_https_inbound" {
  name = "${var.wpsite_name}_https_inbound"
  description = "Allow HTTPS from Anywhere"
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.wpsite_vpc.id}"
  tags = map("Name","${var.wpsite_name}_https_inbound")
}
output "wpsite_https_inbound_sg_id" {
  value = "${aws_security_group.wpsite_https_inbound.id}"
}
