resource "aws_s3_bucket" "fastapibucket" {
  bucket = "jansfastapibucket87293847"
}

resource "aws_s3_bucket_acl" "fastapibucket" {
  bucket = aws_s3_bucket.fastapibucket.id
  acl    = "public-read-write"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "archive_file" "fastapi" {
  type        = "zip"
  source_dir  = "fastapi"
  output_path = "fastapi.zip"
}

resource "aws_s3_object" "fastapifiles" {
  bucket     = "jansfastapibucket87293847"
  key        = "fastapi.zip"
  source     = "fastapi.zip"
  depends_on = [data.archive_file.fastapi, aws_s3_bucket.fastapibucket]
}
