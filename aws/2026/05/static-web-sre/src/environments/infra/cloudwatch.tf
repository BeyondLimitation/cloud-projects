# CloudWatch가 이메일로 경고를 보내기 위해 설정
resource "aws_sns_topic" "error-budget" {
  provider = aws.virginia
  name     = "static-web-sre-5XX_error_budget"
}

# resource "aws_sns_topic_subscription" "via_email" {
#   topic_arn = aws_sns_topic.error-budget.arn
#   protocol  = "email"
#   endpoint  = var.email_address
#   depends_on = [ aws_sns_topic.error-budget ]
# }

# # CloudWatch Alarm 설정
# resource "aws_cloudwatch_metric_alarm" "budget_alarm" {
#   provider = aws.virginia
#   # Alarm 기본 설정
#   alarm_name         = var.alarm_name
#   alarm_description  = "CloudFront 5XX 에러 건수가 최근 30일 기간에 6건 이상 발생했습니다."
#   metric_name        = "5xxErrorRate"
#   namespace          = "AWS/CloudFront"
#   evaluation_periods = 1

#   # 조건 설정
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   period              = 86400
#   statistic           = "Average"
#   threshold           = 0.1

#   # 오작동 방지 설정. 데이터 없는 경우
#   treat_missing_data = "notBreaching"

#   # CloudFront Distribution ID 지정
#   dimensions = {
#     DistributionId = var.cloudfront_distribution_id
#     Region         = "Global"
#   }

#   # 임계치 초과 시 알림을 보낼 SNS Topic
#   alarm_actions = [aws_sns_topic.error-budget.arn]

#   # SNS Topic의 생성 대기
#   depends_on = [aws_sns_topic.error-budget]
# }