resource "aws_sns_topic" "5xx-error-budget" {
    name = "5XX-error-count"
}