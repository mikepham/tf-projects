#------------------------------------------------------------------------------
# Create DevOps Role
#------------------------------------------------------------------------------

data "aws_iam_policy_document" "devops" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "DevOpsAssumeRoleAccess"

    principals {
      identifiers = formatlist("arn:aws:iam::%s:user/%s", var.account_id, var.devops)
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "devops" {
  count              = length(var.devops) > 0 ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.devops.json
  name               = "${var.environment}-role-devops"
}

resource "aws_iam_role_policy_attachment" "devops_policies" {
  count      = length(local.devops_roles)
  role       = aws_iam_role.devops[0].name
  policy_arn = "arn:aws:iam::aws:policy/${element(local.devops_roles, count.index)}"
}
