/******************************************************************************
  Organization: Development
******************************************************************************/

resource "aws_organizations_account" "dev" {
  name                       = "Development Environment"
  email                      = "admin+dev@nativecode.com"
  iam_user_access_to_billing = "DENY"
  role_name                  = "admin-dev"

  lifecycle {
    ignore_changes = [role_name]
  }
}

/******************************************************************************
  Organization: Testing
******************************************************************************/

resource "aws_organizations_account" "test" {
  name                       = "Testing Environment"
  email                      = "admin+test@nativecode.com"
  iam_user_access_to_billing = "DENY"
  role_name                  = "admin-test"

  lifecycle {
    ignore_changes = [role_name]
  }
}

/******************************************************************************
  Organization: Staging
******************************************************************************/

resource "aws_organizations_account" "stage" {
  name                       = "Staging Environment"
  email                      = "admin+stage@nativecode.com"
  iam_user_access_to_billing = "DENY"
  role_name                  = "admin-stage"

  lifecycle {
    ignore_changes = [role_name]
  }
}

/******************************************************************************
  Organization: Production
******************************************************************************/

resource "aws_organizations_account" "prod" {
  name                       = "Production Environment"
  email                      = "admin+prod@nativecode.com"
  iam_user_access_to_billing = "DENY"
  role_name                  = "admin-prod"

  lifecycle {
    ignore_changes = [role_name]
  }
}
