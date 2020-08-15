resource "aws_s3_bucket" "assets" {
    bucket = var.s3_bucket_name
    acl = "public-read"
    website {
        index_document = "index.html"
        error_document = "error.html"
    }
    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET"]
        allowed_origins = ["*"]
        expose_headers = ["ETag"]
        max_age_seconds = 4000
    }
}

resource "aws_s3_bucket_notification" "assets_bucket_notification" {
    bucket = aws_s3_bucket.assets.id
    lambda_function {
        lambda_function_arn = aws_lambda_function.create_thumbnail.arn
        events = ["s3:ObjectCreated:*"]
        filter_suffix = ".jpg"
    }
}

resource "aws_s3_bucket_object" "index-html" {
    bucket = aws_s3_bucket.assets.id
    acl = "public-read"
    key    = "index.html"
    source = "../gallery/index.html"
    etag = filemd5("../gallery/index.html")
}