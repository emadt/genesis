resource "aws_iam_group" "developers" {
   name = "developers"
  
}

resource "aws_iam_group" "readOnly" {
   name = "readOnly"
}

resource "aws_iam_group_policy_attachment" "devpolicies" {
  count      = "${length(var.managed_policies_developers)}"
  group      = "${aws_iam_group.developers.name}"
  policy_arn = "${element(var.managed_policies_developers, count.index)}"
}

resource "aws_iam_group_policy_attachment" "readOnly" {
  count      = "${length(var.managed_policies_readOnly)}"
  group      = "${aws_iam_group.readOnly.name}"
  policy_arn = "${element(var.managed_policies_readOnly, count.index)}"
}

