resource "aws_iam_user" "fastapiuser" {
  name = "fastapi"
}

resource "aws_iam_policy" "fastapiadmin" {
  name   = "fastapi_admin"
  policy = file("s3policy.json")
}

resource "aws_iam_user_policy_attachment" "fastapiuser-admin" {
  user       = aws_iam_user.fastapiuser.name
  policy_arn = aws_iam_policy.fastapiadmin.arn
}
