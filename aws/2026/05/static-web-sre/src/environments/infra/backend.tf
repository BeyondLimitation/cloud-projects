terraform {
  backend "s3" {
    bucket = "lee-static-web-sre-state-storage"
    key    = "infra/state.tfstate"
    region = "ap-northeast-2"
  }
}

# Cloudwatch를 위한 Region 설정
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}