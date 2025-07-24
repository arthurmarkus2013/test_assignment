variable "availability_zones" {
  description = "A list containing 3 AZs"
  type        = list(string)
  default = [ "a", "b", "c" ]
}

variable "node_count" {
  description = "The number of ec2 instances to deploy"
  type        = number
  default = 3
}

variable "aws_region" {
    description = "AWS region to deploy to"
    type = string
    default = "us-east-1"
}
