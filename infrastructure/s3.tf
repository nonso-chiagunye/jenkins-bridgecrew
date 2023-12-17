#  S3 Bucket to store jenkins artifact
resource "aws_s3_bucket" "jenkins-artifact" {
  bucket = "s3-bucket-for-jenkins-artifact"

  tags = {
    Name = "s3-bucket-for-jenkins-artifact"
  }
}

resource "aws_s3_bucket_ownership_controls" "jenkins-artifact-bucket-acl-ownership" {
  bucket = aws_s3_bucket.jenkins-artifact.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "jenkins_bucket_acl" {
  bucket = aws_s3_bucket.jenkins-artifact.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.jenkins-artifact-bucket-acl-ownership]
}