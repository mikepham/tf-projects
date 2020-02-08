#------------------------------------------------------------------------------
# Create Operators Role
#------------------------------------------------------------------------------

data "aws_iam_policy_document" "operators" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "OperatorsAssumeRoleAccess"

    principals {
      identifiers = formatlist("arn:aws:iam::%s:user/%s", var.account_id, var.operators)
      type        = "AWS"
    }
  }
}

resource "aws_iam_role" "operators" {
  count              = length(var.operators) > 0 ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.operators.json
  name               = "${var.environment}-role-operators"
}

resource "aws_iam_role_policy_attachment" "operator_policies" {
  count      = length(local.operator_roles)
  role       = aws_iam_role.operators[0].name
  policy_arn = "arn:aws:iam::aws:policy/${element(local.operator_roles, count.index)}"
}
