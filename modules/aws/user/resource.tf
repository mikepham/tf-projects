data "aws_iam_policy" "user" {
  count = length(var.policies)
  arn   = element(var.policies, count.index)
}

resource "aws_iam_group" "user" {
  name = var.group_name
}

resource "aws_iam_user" "user" {
  name = var.user_name
}

resource "aws_iam_access_key" "user" {
  user = aws_iam_user.user.name
}

resource "aws_iam_user_group_membership" "user" {
  groups = [aws_iam_group.user.name]
  user   = aws_iam_user.user.name
}

resource "aws_iam_group_policy" "user" {
  count  = length(var.policies)
  group  = aws_iam_group.user.id
  name   = "${var.domain}-${element(data.aws_iam_policy.user.*.name, count.index)}"
  policy = element(data.aws_iam_policy.user.*.policy, count.index)
}
