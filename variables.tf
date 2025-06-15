// modules/aws_network/variables.tf

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  // No default
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

variable "namespace" { // << REPLACED 'prefix'
  description = "Namespace for resource naming (e.g., week5)"
  type        = string
  // No default
}

variable "stage" { // << NEW
  description = "Deployment stage (e.g., dev, prod)"
  type        = string
  // No default
}

variable "default_tags" {
  description = "Default tags to be applied (merged with Name tag)"
  type        = map(any)
  // No default (calling config must provide, e.g., an empty map {})
}