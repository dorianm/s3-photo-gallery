resource "aws_s3_bucket" "assets" {
  bucket = var.s3_bucket_name
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 4000
  }
}

resource "aws_s3_bucket_notification" "assets_bucket_notification" {
  bucket = aws_s3_bucket.assets.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.create_thumbnail.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }
}

resource "aws_s3_bucket_policy" "assets_bucket_public" {
  bucket = aws_s3_bucket.assets.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicRead",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "${aws_s3_bucket.assets.arn}/*"
        }
    ]
}
EOF
}

data "template_file" "tmpl_index_html" {
  template = file("../gallery/index.html")
  vars = {
    "tf_aws_region"     = aws_s3_bucket.assets.region
    "tf_s3_bucket_name" = aws_s3_bucket.assets.id
    "gallery_title"     = var.gallery_title
  }
}

resource "aws_s3_bucket_object" "index-html" {
  bucket       = aws_s3_bucket.assets.id
  key          = "index.html"
  content      = data.template_file.tmpl_index_html.rendered
  etag         = md5(data.template_file.tmpl_index_html.rendered)
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "content-file" {
  bucket = aws_s3_bucket.assets.id
  key    = "content.json"
  source = "empty-content.json"
}
