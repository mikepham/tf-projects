locals {
  user_account_id = data.aws_caller_identity.current.account_id
  user_arn        = data.aws_caller_identity.current.arn
  user_id         = data.aws_caller_identity.current.user_id
}
