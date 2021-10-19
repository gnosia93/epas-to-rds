data "aws_availability_zones" "azlist" {
    state = "available"
}

data "aws_vpc" "tf_vpc" {
    default = true
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids
data "aws_subnet_ids" "tf_subnet_ids" {
  vpc_id = data.aws_vpc.tf_vpc.id
}

output "azlist" {
    value = data.aws_availability_zones.azlist.names[0]
}

