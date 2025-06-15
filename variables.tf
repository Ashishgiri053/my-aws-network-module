// modules/aws_network/variables.tf

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  // No default - must be provided by the calling root module
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  // No default
}

variable "subnet_cidr_block" {
  description = "CIDR block for the single public subnet"
  type        = string
  // No default
}

variable "avail_zone" {
  description = "Availability Zone for the single public subnet"
  type        = string
  // No default
}

variable "prefix" {
  description = "Prefix for resource names (e.g., week5-dev)"
  type        = string
  // No default
}

variable "default_tags" {
  description = "Default tags to be applied to all AWS resources"
  type        = map(any)
  // No default (the calling module should pass this, e.g. an empty map {} if no specific tags)
}