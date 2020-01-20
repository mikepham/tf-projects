terraform {
  backend "s3" {
    bucket  = "nativecode"
    encrypt = true
    key     = "nativecode.tfstate"
    profile = "nativecode"
    region  = "us-east-1"
  }
}
