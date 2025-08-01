variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "bucket_policy" {
  description = "Bucket policy JSON string"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the bucket"
  type        = map(string)
  default     = {}
}
