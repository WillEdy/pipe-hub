resource "aws_s3_bucket" "logs" {
  bucket = "${var.project_name}-nginx-logs-bucket"

  tags = {
    Environment = "${var.environment}"
    Name        = "${var.project_name}-logs-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block_1" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket" "web" {
  bucket = "${var.project_name}-nginx-web-bucket"

  tags = {
    Environment = "${var.environment}"
    Name        = "${var.project_name}-web-bucket"
  }
}

# Define a bucket policy to allow public read access to objects in the bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.web.id

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Sid":"AddPublicReadAccess",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
            "Resource":["arn:aws:s3:::${var.project_name}-nginx-web-bucket/*"]
        }
    ]
}
POLICY
}

# Configure public access block for the bucket
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.web.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Configure website hosting for the bucket
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.web.id
  index_document {
    suffix = "index.html"
  }
}

# Upload an HTML file to the bucket
resource "aws_s3_object" "html_file" {
  bucket       = aws_s3_bucket.web.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}