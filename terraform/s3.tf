resource "aws_s3_bucket" "fastapibucket" {
  bucket = "jansfastapibucket87293847"
}

# resource "aws_s3_bucket_acl" "fastapibucket" {
#   bucket = aws_s3_bucket.fastapibucket.id
#   acl    = "public-read-write"
# }

data "aws_iam_user" "fastapiuser" {
  user_name = aws_iam_user.fastapiuser.id
}

data "archive_file" "fastapi" {
  type        = "zip"
  source_dir  = "../fastapi"
  output_path = "fastapi.zip"
}

resource "aws_s3_object" "fastapifiles" {
  bucket     = aws_s3_bucket.fastapibucket.id
  key        = "fastapi.zip"
  source     = "fastapi.zip"
  depends_on = [data.archive_file.fastapi, aws_s3_bucket.fastapibucket]
}
