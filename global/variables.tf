variable "region" {
  description = "AWS region of choice"
  default = "us-east-1"
}

variable "cidr_block" {
   description = "The CIDR IP address for the VPC"
   type = string
   default = "10.0.0.0/16"
}
variable "public_subnet_1" {
   description = "The CIDR IP address for the first public subnet in the VPC"
   type = string
   default = "10.0.1.0/24"
}

variable "managed_policies_developers" {
  default = ["arn:aws:iam::aws:policy/AWSLambdaFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchEventsReadOnlyAccess",
    "arn:aws:iam::aws:policy/service-role/AWSDataPipelineRole",
    "arn:aws:iam::aws:policy/CloudWatchLogsReadOnlyAccess",
    "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser",
    "arn:aws:iam::aws:policy/AWSXrayFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

variable "managed_policies_readOnly" {
  default = ["arn:aws:iam::aws:policy/AWSLambdaFullAccess"]
}

