resource "aws_vpc" "mzgcpa_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  vpc_id      = "${aws_vpc.mzgcpa_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_iam_user" "mzgcpa_iam_user" {
  name = "mzgcpa"
  path = "/system/"
}

resource "aws_iam_access_key" "mzgcpa_access_key" {
  user = "${aws_iam_user.mzgcpa_iam_user.name}"
}

resource "aws_iam_user_policy" "mzgcpa_user_policy" {
  name = "mzgcpa"
  user = "${aws_iam_user.mzgcpa_iam_user.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
