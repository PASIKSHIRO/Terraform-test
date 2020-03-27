variable "aws_access_key" {
  default = ""
}

variable "aws_secret_key" {
  default = ""
}

variable "bucket_name" {
  default = "terraformdevops"
}

provider "aws" {
  region = "eu-central-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.terraformdevops.id

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"PublicReadForGetBucketObjects",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${aws_s3_bucket.terraformdevops.id}/*"
      ]
    }
  ]  
}
POLICY
}


#Adding html doc to main domain bucket
resource "aws_s3_bucket_object" "index_static" {
  bucket = aws_s3_bucket.terraformdevops.id
  key = "index.html"
  source = "./index.html"
}

#SubDomain bucket - to redirect to main bucket
resource "aws_s3_bucket" "terraformdevops" {
    bucket = var.bucket_name
    acl    = "public-read"
    website {
      index_document = "index.html"
  }
}

output "bucket-url" {
  value = aws_s3_bucket.terraformdevops.website_endpoint
}