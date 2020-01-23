locals {
  ami_gitlab         = "ami-07e527713adb89f0d"
  allowed_hosts      = ["97.106.33.210/32"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  domain             = "nativecode.net"
  project_name       = "gitlab"
  vpc_id             = "vpc-0f6025c1d1944919a"
}
