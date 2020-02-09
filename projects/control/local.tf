locals {
  domain          = "nativecode.net"
  envdomains      = module.prod.subdomains
  full_aws_access = "arn:aws:organizations::aws:policy/service_control_policy/p-FullAWSAccess"
  project_name    = "control-plane"
  root_account    = "329267330377"

  domains = [
    "nativecode.com",
    "nativecode.net",
    "storyserver.com",
  ]

  users = [
    {
      import   = true,
      username = "mike.pham",
    },
  ]
}
