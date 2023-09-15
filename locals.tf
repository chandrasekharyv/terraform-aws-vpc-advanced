# slice function is use to restrict the list according to requirement
locals {
  azs = slice(data.aws_availability_zones.available.names,0,2)
}

