terraform {
  backend "s3" {
    bucket = "lee-static-web-sre-state-storage"
    key    = "infra/state.tfstate"
    region = "ap-northeast-2"
  }
}

provider "aws" {
  region = "us-east-1"
  alias = "virginia"
  endpoints {
    cloudwatch = "https://monitoring.us-east-1.amazonaws.com"
  }
}