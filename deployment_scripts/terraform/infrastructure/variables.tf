variable "availability_zones" {
  description = "A list containing 3 AZs"
  type        = list(string)
  default = [ "a", "b" ]
}

variable "aws_region" {
    description = "AWS region to deploy to"
    type = string
    default = "us-east-1"
}
