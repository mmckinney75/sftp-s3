terraform {
  backend "s3" {
    bucket = "mmckinney-tfstate"
    key    = "sftp-s3/server"
    region = "us-east-1"
  }
}
