locals {
  ami_wordpress      = "ami-0fd5632db7ba00939"
  allowed_hosts      = ["97.106.33.210/32"]
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  domain             = "nativecode.net"
  project_name       = "gitlab"
}
