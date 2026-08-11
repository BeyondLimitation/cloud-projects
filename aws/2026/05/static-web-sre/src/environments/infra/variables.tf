# S3
variable "dev-s3_bucket_regional_domain_name" {
  type        = string
  description = "AWS S3 Bucket의 지리적 도메인 네임. FQDN 형식으로 입력"

  validation {
    condition     = can(regex("^(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,63}\\.?$", var.dev-s3_bucket_regional_domain_name))
    error_message = "잘못된 FQDN 형식 입니다. 다시 확인해 주십시요."
  }
}

variable "prod-s3_bucket_regional_domain_name" {
  type        = string
  description = "AWS S3 Bucket의 지리적 도메인 네임. FQDN 형식으로 입력"

  validation {
    condition     = can(regex("^(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,63}\\.?$", var.prod-s3_bucket_regional_domain_name))
    error_message = "잘못된 FQDN 형식 입니다. 다시 확인해 주십시요."
  }
}

# SNS
variable "email_address" {
  type        = string
  description = "CloudWatch Alarm을 받을 Email 주소. Github Secret에서 값을 가져오기"
  default     = ""
}

# Cloudwatch
variable "alarm_name" {
  type        = string
  description = "Cloudwatch Metric Alarm의 이름"
  default     = "default"
}

variable "cloudfront_distribution_id" {
  type        = string
  description = "CloudFront의 Distribution ID"
  default     = ""
}