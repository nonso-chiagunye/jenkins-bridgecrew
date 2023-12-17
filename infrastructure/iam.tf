# This role will be used by Jenkins server to perform operations within the AWS account
resource "aws_iam_role" "jenkins-role" {
  name = "jenkins-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com" #service level Access
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# This policy allows Jenkins server to store artifact in specified S3 Bucket. 
resource "aws_iam_policy" "jenkins-s3-policy" {
  name   = "jenkins-s3-policy"
  depends_on = [aws_s3_bucket.jenkins-artifact]
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3ReadWriteAccess",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::s3-bucket-for-jenkins-artifact",
        "arn:aws:s3:::s3-bucket-for-jenkins-artifact/*",
        "arn:aws:s3:::my-tfstate-file-location",
        "arn:aws:s3:::my-tfstate-file-location/*"
      ]
    }
  ]
}
EOF
}


# Only attach this Administrator Policy if you want to use the Jenkins instance to Create and/or Destroy ALL resources. Modify based on least priviledge. You don't need the S3 policy if you create this one.
resource "aws_iam_policy" "jenkins-policy" {
  name   = "jenkins-policy" 
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : "*",
      "Resource" : "*"
    }
  ]
}
EOF
}

#  Attach the administrator policy to the role
resource "aws_iam_role_policy_attachment" "jenkins-policy-attachment" {
  policy_arn = aws_iam_policy.jenkins-policy.arn
  role       = aws_iam_role.jenkins-role.name
}

#  Or attach the S3 Policy to the role
resource "aws_iam_role_policy_attachment" "jenkins-s3-policy-attachment" {
  policy_arn = aws_iam_policy.jenkins-s3-policy.arn
  role       = aws_iam_role.jenkins-role.name
}

#  Crreeate IAM Instance profile to attach the role to the instance
resource "aws_iam_instance_profile" "jenkins-server-instance-profile" {
  name = "jenkins-server-instance-profile"
  role = aws_iam_role.jenkins-role.name
}