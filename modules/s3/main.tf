resource "aws_s3_bucket" "buckets" {

    count = length(var.bucketName)
    bucket  = var.bucketName[count.index]
    acl    = var.acl

    versioning {
        enabled = var.versioning
    }
}