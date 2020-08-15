resource "aws_lambda_function" "create_thumbnail" {
    filename = "../lambda/lambda.zip"
    source_code_hash = filebase64sha256("../lambda/lambda.zip")
    description =  "Create thumbnail in S3 bucket"
    function_name = "create_thumbnail"
    runtime = "python3.8"
    timeout = 60
    memory_size = 128
    role = aws_iam_role.lambda_create_thumbnail_role.arn
    handler = "create-thumbnail.handler"
}

resource "aws_lambda_permission" "allow_transcode_bucket" {
    statement_id = "AllowExecutionFromS3Bucket"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.create_thumbnail.arn
    principal = "s3.amazonaws.com"
    source_arn = aws_s3_bucket.assets.arn
}
