resource "aws_iam_policy" "ec2_policy" {
  name = "ec2-cloudwatch-policy"
  description = "Policy for Cloudwatch EC2"
  tags = {
    name = "EC2 Policy"
  }
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": "iam:CreateServiceLinkedRole",
        "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
        "Condition": {
          "StringLike": {
            "iam:AWSServiceName": "events.amazonaws.com"
          }
        }
      },
      {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": [
          "sns:*",
          "iam:GetRole",
          "iam:GetPolicyVersion",
          "autoscaling:Describe*",
          "iam:GetPolicy",
          "logs:*",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:Describe*",
          "cloudwatch:ListMetrics",
          "ec2:Describe*",
          "oam:ListSinks",
          "cloudwatch:*",
          "elasticloadbalancing:Describe*"
        ],
        "Resource": "*"
      },
      {
        "Sid": "VisualEditor2",
        "Effect": "Allow",
        "Action": "oam:ListAttachedLinks",
        "Resource": "arn:aws:oam:*:*:sink/*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
  tags = {
    name = "EC2 Role"
  }
}

resource "aws_iam_policy_attachment" "ec2_policy_attachment" {
  name       = "ec2-attachment"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
  depends_on = [aws_iam_policy.ec2_policy, aws_iam_role.ec2_role]
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
  depends_on = [aws_iam_role.ec2_role]
}