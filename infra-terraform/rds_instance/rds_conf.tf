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
resource "aws_db_instance" "wpsite_rds_instance" {
  identifier        = "${var.wpsite_name}-${var.rds_instance_identifier}"
  allocated_storage = "${var.rds_allocated_storage}"
  engine            = "${var.rds_engine_type}"
  engine_version    = "${var.rds_engine_version}"
  instance_class    = "${var.rds_instance_class}"
  name              = "${var.wpsite_name}"
  username          = "${var.database_user}"
  password          = "${var.database_password}"

  port = "${var.database_port}"

  # Because we're assuming a VPC, we use this option, but only one SG id
  vpc_security_group_ids = ["${aws_security_group.wpsite_db_access.id}"]

  # We're creating a subnet group in the module and passing in the name
  db_subnet_group_name = "${aws_db_subnet_group.main_db_subnet_group.id}"
  parameter_group_name = "${var.use_external_parameter_group ? var.parameter_group_name : aws_db_parameter_group.main_rds_instance[0].id}"

  # We want the multi-az setting to be toggleable, but off by default
  multi_az            = "${var.rds_is_multi_az}"
  storage_type        = "${var.rds_storage_type}"
  iops                = "${var.rds_iops}"
  publicly_accessible = "${var.publicly_accessible}"

  # Upgrades
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"

  # Snapshots and backups
  skip_final_snapshot   = "${var.skip_final_snapshot}"
  copy_tags_to_snapshot = "${var.copy_tags_to_snapshot}"

  backup_retention_period = "${var.backup_retention_period}"
  backup_window           = "${var.backup_window}"

  # enhanced monitoring
  monitoring_interval = "${var.monitoring_interval}"

  tags = "${merge(var.tags, map("Name", format("%s", var.rds_instance_identifier)))}"

 provisioner "local-exec" {
   command = "echo DB_HOSTNAME: ${aws_db_instance.wpsite_rds_instance.address} > ${var.wpsite_name}.yml"
 }
}

resource "aws_db_parameter_group" "main_rds_instance" {
  count = "${var.use_external_parameter_group ? 0 : 1}"

  name   = "${var.rds_instance_identifier}-${replace(var.db_parameter_group, ".", "")}-custom-params"
  family = "${var.db_parameter_group}"

  # Example for MySQL
#   parameter {
#     name = "character_set_server"
#    value = "utf8"
#   }


#  parameter {
#     name = "character_set_client"
#    value = "utf8"
#   }

  tags = "${merge(var.tags, map("Name", format("%s", var.rds_instance_identifier)))}"
}

resource "aws_db_subnet_group" "main_db_subnet_group" {
  name        = "${var.rds_instance_identifier}-subnetgrp"
  description = "RDS subnet group"
  subnet_ids  = ["${var.wpsite_private_subnet_1}","${var.wpsite_public_subnet_1}"]

  tags = "${merge(var.tags, map("Name", format("%s", var.rds_instance_identifier)))}"
}

# Security groups
resource "aws_security_group" "wpsite_db_access" {
  name        = "${var.wpsite_name}-${var.rds_instance_identifier}-access"
  description = "Allow access to the database"
  vpc_id      = "${var.rds_vpc_id}"

  tags = "${merge(var.tags, map("Name", format("%s", var.rds_instance_identifier)))}"
}

resource "aws_security_group_rule" "allow_db_access" {
  type = "ingress"

  from_port   = "${var.database_port}"
  to_port     = "${var.database_port}"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.wpsite_db_access.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
  type = "egress"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.wpsite_db_access.id}"
}
