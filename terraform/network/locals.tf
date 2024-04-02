locals {
  availability_zone_names = sort(data.aws_availability_zones.available.names)
}