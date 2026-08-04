resource "aws_sns_topic" "error-budget" {
  name = "static-web-sre-5XX_error_budget"
}

resource "aws_sns_topic_subscription" "via_email" {
  topic_arn = aws_sns_topic.error-budget.arn
  protocol = "email"
  endpoint = var.email_address
}