terraform {
  backend "s3" {
    bucket = "terraform-state-file-ur"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
