# CloudFront의 요청 URL에 Prefix 제거
resource "aws_cloudfront_function" "remove_prefix" {
  name = "remove_prefix"
  code = file("cloudfront_functions/default.js")
  runtime = "cloudfront-js-2.0"
}

resource "aws_cloudfront_distribution" "static-website-sre" {
  # S3 Origin 지정
  origin {
    # 'dev' Bucket
    domain_name = var.dev-s3_bucket_regional_domain_name
    origin_id   = "dev"
    # S3 Website용 Origin 설정
    custom_origin_config {
      http_port = 80
      https_port = 443
      # S3 Website는 'http'만 지원
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [ "TLSv1.2" ]
    }
  }
  origin {
    # 'prod' Bucket
    domain_name = var.prod-s3_bucket_regional_domain_name
    origin_id   = "prod"
    # S3 Website용 Origin 설정
    custom_origin_config {
      http_port = 80
      https_port = 443
      # S3 Website는 'http'만 지원
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = [ "TLSv1.2" ]
    }
  }

  # SSL/TLS 인증서 설정
  viewer_certificate {
    # CloudFront 기본 제공 도메인 네임 사용시, 이 옵션 값을 'true' 로 설정
    cloudfront_default_certificate = true
  }

  # 지리적 제한 설정
  restrictions {
    geo_restriction {
      # 지리적 제한 해제
      restriction_type = "none"
    }
  }

  # 기본 캐시 설정
  default_cache_behavior {
    target_origin_id = "prod"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
  }
  # 조건부 캐싱
  ordered_cache_behavior {
    target_origin_id = "dev"
    path_pattern     = "/dev/*"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    # S3 요청에 'dev' prefix를 제거
    function_association {
      event_type = "viewer-request"
      function_arn = aws_cloudfront_function.remove_prefix.arn
    }
  }

  # Distribution이 End user의 컨텐츠 요청 허용 여부
  enabled = true
}