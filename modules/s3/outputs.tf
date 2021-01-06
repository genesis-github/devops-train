output "bucketName" {
  value = "${element(concat(aws_s3_bucket.buckets.*.bucket, list("")), 0)}"
}

output "bucketARN" {
  value = "${element(concat(aws_s3_bucket.buckets.*.arn, list("")), 0)}"
}