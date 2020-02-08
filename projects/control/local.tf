locals {
  domain          = "nativecode.net"
  full_aws_access = "arn:aws:organizations::aws:policy/service_control_policy/p-FullAWSAccess"
  project_name    = "control-plane"
  root_account    = "329267330377"

  domains = [
    "nativecode.com",
    "nativecode.net",
    "storyserver.com",
  ]

  environments = [
    {
      arn = aws_organizations_account.dev.arn
      id  = aws_organizations_account.dev.id
    },
    {
      arn = aws_organizations_account.test.arn
      id  = aws_organizations_account.test.id
    },
    {
      arn = aws_organizations_account.stage.arn
      id  = aws_organizations_account.stage.id
    },
    {
      arn = aws_organizations_account.prod.arn
      id  = aws_organizations_account.prod.id
    },
  ]

  users = [
    {
      import   = true,
      username = "mike.pham",
    },
  ]
}
