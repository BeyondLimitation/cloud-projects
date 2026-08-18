output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.static-website-sre.id
}

output "cloudfront_domain_name" {
  description = "CloudFront 도메인"
  value       = aws_cloudfront_distribution.static-website-sre.domain_name
}

output "aws_sns_topic_arn" {
  description = "SNS Topic의 ARN"
  value       = aws_sns_topic.error-budget.arn
}