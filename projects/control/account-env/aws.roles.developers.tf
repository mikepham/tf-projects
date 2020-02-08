#------------------------------------------------------------------------------
# Create Developers Role
#------------------------------------------------------------------------------

data "aws_iam_policy_document" "developers" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "DevelopersAssumeRoleAccess"

    principals {
      identifiers = formatlist("arn:aws:iam::%s:user/%s", var.account_id, var.developers)
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "developers" {
  count              = length(var.developers) > 0 ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.developers.json
  name               = "${var.environment}-role-developers"
}

resource "aws_iam_role_policy_attachment" "developer_policies" {
  count      = length(local.developer_roles)
  role       = aws_iam_role.developers[0].name
  policy_arn = "arn:aws:iam::aws:policy/${element(local.developer_roles, count.index)}"
}
