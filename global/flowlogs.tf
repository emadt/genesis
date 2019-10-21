resource "aws_flow_log" "main-flowlogs" {
  iam_role_arn    = "${aws_iam_role.flowlogs.arn}"
  log_destination = "${aws_cloudwatch_log_group.main-loggroup.arn}"
  traffic_type    = "ALL"
  vpc_id          = "${aws_vpc.main.id}"
}

resource "aws_cloudwatch_log_group" "main-loggroup" {
  name = "main-loggroup"
}

resource "aws_iam_role" "flowlogs" {
  name = "flowlogs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "flowlogs-policy" {
  name = "flowlogs-policy"
  role = "${aws_iam_role.flowlogs.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
